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

Rig Extractor::Extract(cv::Mat& frame, const Detection& detection)
{
    assert(!frame.empty());

    CropBox box = Preprocess::ComputeCropBox(detection.box_min, detection.box_max, kTgtW, kTgtH);
    cv::Mat crop = Preprocess::CropWithPadding(frame, box);
    cv::Mat blob = Preprocess::NormalizeToBlob(crop, input_size);

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

    std::unordered_map<std::string, float*> outputs;
    outputs.reserve(output_tensors.size());
    for (size_t i = 0; i < output_tensors.size(); i++)
    {
        outputs[output_names[i]] = output_tensors[i].GetTensorMutableData<float>();
    }

    Rig extraction{outputs};
    return extraction;

    } catch (const Ort::Exception& e) {
        std::cerr << "ONNX Runtime Exception: " << e.what() << "\n";
    }
}