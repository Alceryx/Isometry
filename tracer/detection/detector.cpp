#include "detector.hpp"

Detector::Detector(const Ort::Env& env, const std::string &model_path)
{
    Ort::SessionOptions options;

    #ifdef _WIN32
    std::wstring path = std::filesystem::path(model_path).wstring();
    session = std::make_unique<Ort::Session>(env, path.c_str(), options);
    #else
    session = std::make_unique<Ort::Session>(env, model_path.c_str(), options);
    #endif

    auto input_shape = session->GetInputTypeInfo(0).GetTensorTypeAndShapeInfo().GetShape();
    input_width = input_shape[3];
    input_height = input_shape[2];
}

std::vector<Detection> Detector::Detect(cv::Mat &frame)
{
    try {
    frame_width = frame.cols;
    frame_height = frame.rows;

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

    float* data = output_tensors[0].GetTensorMutableData<float>();
        
    std::vector<Detection> detections;
    for (size_t i = 0; i < DETECT_NUM; i++)
    {
        Detection det {data, i};
        if (det.stats[0] < DETECT_THRESHOLD) break;
        
        float scale_x = static_cast<float>(frame_width) / input_width;
        float scale_y = static_cast<float>(frame_height) / input_height;
        det.Rescale(scale_x, scale_y);

        detections.push_back(det);
    }
    return detections;
    
    } catch (const Ort::Exception& e) {
        std::cerr << "ONNX Runtime Exception: " << e.what() << "\n";
        exit(EXIT_FAILURE);
    }
}