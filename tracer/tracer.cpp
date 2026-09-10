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

    auto input_shape = session->GetInputTypeInfo(0).GetTensorTypeAndShapeInfo().GetShape();
    input_width = input_shape[3];
    input_height = input_shape[2];

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

void Tracer::ProcessFrame(cv::Mat &frame, float* data)
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

    std::vector<int64_t> output_shape = output_tensors[0].GetTensorTypeAndShapeInfo().GetShape();

    if (data != nullptr) data = this->data;
    this->data = output_tensors[0].GetTensorMutableData<float>();
    
    } catch (const Ort::Exception& e) {
        std::cerr << "ONNX Runtime Exception: " << e.what() << "\n";
        exit(EXIT_FAILURE);
    }
}

Detection Tracer::GetDetection(size_t candidate)
{
    Detection detected(data, 0);

    float scale_x = static_cast<float>(frame_width) / static_cast<float>(input_width);
    float scale_y = static_cast<float>(frame_height) / static_cast<float>(input_height);
    detected.Rescale(scale_x, scale_y);

    return detected;
}

void Tracer::AnnotateFrame(cv::Mat &frame, Detection& detection)
{
    cv::rectangle(frame, cv::Point(static_cast<int>(detection.box[0]), static_cast<int>(detection.box[1])),
    cv::Point(static_cast<int>(detection.box[2]), static_cast<int>(detection.box[3])),
    cv::Scalar(60,60,229), 3);

    auto prev_conf = 0;
    for (Keypoint &kp : detection.keypoints)
    {
        // if (!kp.visible()) continue;
        // cv::circle(frame,
        // cv::Point(static_cast<int>(kp.pos.x), static_cast<int>(kp.pos.y)),
        // 7, cv::Scalar(0, 255, 0), cv::FILLED);
    }

    cv::putText(frame, "Conf " + std::to_string(detection.stats[0]),
    cv::Point(static_cast<int>(detection.box[0]), static_cast<int>(detection.box[1] - 15)),
    cv::FONT_HERSHEY_SIMPLEX, 1,
    cv::Scalar(60, 60, 229), 1);

    // ConnectJoint(frame, detection.kp(Joint::RightShoulder), detection.kp(Joint::RightElbow));
    // ConnectJoint(frame, detection.kp(Joint::RightElbow), detection.kp(Joint::RightWrist));
}

void Tracer::ConnectJoint(cv::Mat& frame, Keypoint& start, Keypoint& end)
{
    if (!start.visible() || !end.visible()) return;
    cv::line(frame, cv::Point(static_cast<int>(start.pos.x), static_cast<int>(start.pos.y)),
    cv::Point(static_cast<int>(end.pos.x), static_cast<int>(end.pos.y)),
    cv::Scalar(60,60,229), 5);
}
