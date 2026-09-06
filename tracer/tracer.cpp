#include "tracer.hpp"

bool Tracer::Init(const std::string& model_path)
{
    try {
    env = std::make_unique<Ort::Env>(ORT_LOGGING_LEVEL_WARNING, "Tracer");
    Ort::SessionOptions options;

    #ifdef _WIN32
    std::wstring path = std::filesystem::path(model_path).wstring();
    session = std::make_unique<Ort::Session>(*env, path.c_str(), options);
    #else
    session = std::make_unique<Ort::Session>(*env, model_path.c_str(), options);
    #endif

    auto shape = session->GetInputTypeInfo(0).GetTensorTypeAndShapeInfo().GetShape();
    input_width = shape[3];
    input_height = shape[2];

    return true;

    } catch (const Ort::Exception &e) {
        std::cerr << "ONNX Runtime Exception: " << e.what() << "\n";
        return false;
    }
}

void Tracer::Shutdown()
{
    env.reset();
    session.reset();
}

Detection Tracer::ProcessFrame(cv::Mat& frame)
{
    try {
    Ort::AllocatorWithDefaultOptions allocator;

    if (frame.empty())
    {
        std::cerr << "Error: Could not load frame\n";
        exit(EXIT_FAILURE);
    }

    cv::Mat blob;
    cv::dnn::blobFromImage(frame, blob, 1.0 / 255.0,
                           cv::Size(static_cast<int>(input_width), static_cast<int>(input_height)),
                           cv::Scalar(0, 0, 0), true, false);

    Ort::MemoryInfo memory_info = Ort::MemoryInfo::CreateCpu(OrtArenaAllocator, OrtMemTypeDefault);
    std::vector<int64_t> input_shape = {blob.size[0], blob.size[1], blob.size[2], blob.size[3]};

    size_t input_tensor_size = blob.total();
    Ort::Value input_tensor = Ort::Value::CreateTensor<float>(
        memory_info,
        blob.ptr<float>(),
        input_tensor_size,
        input_shape.data(),
        input_shape.size());

    Ort::AllocatedStringPtr input_name_ptr = session->GetInputNameAllocated(0, allocator);
    Ort::AllocatedStringPtr output_name_ptr = session->GetOutputNameAllocated(0, allocator);

    std::vector<const char *> input_names = {input_name_ptr.get()};
    std::vector<const char *> output_names = {output_name_ptr.get()};

    std::vector<Ort::Value> output_tensors = session->Run(
        Ort::RunOptions{nullptr},
        input_names.data(), &input_tensor, 1,
        output_names.data(), 1);

    std::vector<int64_t> output_shape = output_tensors[0].GetTensorTypeAndShapeInfo().GetShape();

    float *data = output_tensors[0].GetTensorMutableData<float>();
    Detection detected = Detection::BestCandidate(data);

    float scale_x = static_cast<float>(frame.cols) / static_cast<float>(input_width);
    float scale_y = static_cast<float>(frame.rows) / static_cast<float>(input_height);
    detected.Rescale(scale_x, scale_y);

    return detected;

    } catch (const Ort::Exception& e) {
        std::cerr << "ONNX Runtime Exception: " << e.what() << "\n";
        exit(EXIT_FAILURE);
    }
}