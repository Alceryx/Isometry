#include "extractor.hpp"

Extractor::Extractor(Ort::Env& env, const std::string& model_path)
{
    Ort::SessionOptions options;

    #ifdef _WIN32
    std::wstring path = std::filesystem::path(model_path).wstring();
    session = std::make_unique<Ort::Session>(env, path.c_str(), options);
    #else
    session = std::make_unique<Ort::Session>(env, model_path.c_str(), options);
    #endif    

    auto input_shape = session->GetInputTypeInfo(0).GetTensorTypeAndShapeInfo().GetShape();
    input_size = Vec2(static_cast<float>(input_shape[3]), static_cast<float>(input_shape[2]));   
}

std::optional<Mesh> Extractor::Extract(cv::Mat& frame, const Detection& detection)
{
    if (frame.empty())
    {
        std::cerr << "Error: Could not load frame\n";
        return std::nullopt;
    }

    Vec2 box_center = (detection.box_max + detection.box_min) / 2;

    float width = detection.box_max.x() - detection.box_min.x();
    float height = detection.box_max.y() - detection.box_min.y();

    float box_size = std::max(width, height) * BOX_PAD;

    cv::Point2i origin(static_cast<int>(box_center.x()-box_size/2), static_cast<int>(box_center.y()-box_size/2));
    cv::Size2i size(static_cast<int>(box_size), static_cast<int>(box_size));

    cv::Rect raw_box(origin, size);
    cv::Rect frame_bounds(0, 0, frame.cols, frame.rows);

    cv::Rect box = raw_box & frame_bounds;
    if (box.height <= 0 || box.width <= 0) 
    {
        std::cout << "Bounding Box out of bound\n";
        return std::nullopt;
    }

    cv::Mat crop(frame, box);
    
    cv::Mat input;
    crop.convertTo(input, CV_32FC3);

    // Mean: (103.53, 116.28, 123.675) | Std: (57.375, 57.12, 58.395)
    // (Pixel/255 - Mean) / Std
    cv::subtract(input, cv::Scalar(103.53, 116.28, 123.675), input);
    cv::divide(input, cv::Scalar(57.375, 57.12, 58.395), input);

    cv::Mat blob;
    cv::dnn::blobFromImage(input, blob, 1.0 / 255.0, cv::Size(static_cast<int>(input_size.x()), static_cast<int>(input_size.y())), cv::Scalar(0,0,0), true, false);

    try {
    Ort::AllocatorWithDefaultOptions allocator;

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
    std::vector<const char *> input_names = {input_name_ptr.get()};
    
    std::vector<Ort::AllocatedStringPtr> output_name_ptrs;
    output_name_ptrs.reserve(session->GetOutputCount());

    std::vector<const char *> output_names;
    output_names.reserve(session->GetOutputCount());

    for (size_t i = 0; i < session->GetOutputCount(); i++)
    {
        output_name_ptrs.push_back(session->GetOutputNameAllocated(i, allocator));
        output_names.push_back(output_name_ptrs.back().get());
    }

    std::vector<Ort::Value> output_tensors = session->Run(
        Ort::RunOptions{nullptr},
        input_names.data(), &input_tensor, input_names.size(),
        output_names.data(), output_names.size()
    );

    std::vector<float *> outputs;
    outputs.reserve(output_tensors.size());
    for (auto& tensor : output_tensors)
    {
        outputs.push_back(tensor.GetTensorMutableData<float>());
    }

    Mesh extraction{outputs};
    return extraction;

    } catch (const Ort::Exception& e) {
        std::cerr << "ONNX Runtime Exception: " << e.what() << "\n";
        exit(EXIT_FAILURE);
    }
}