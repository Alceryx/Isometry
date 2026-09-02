#include "tracer_api.h"
#include "detection.hpp"

#include <onnxruntime_cxx_api.h>
#include <opencv2/opencv.hpp>
#include <opencv2/dnn.hpp>

#include <vector>
#include <filesystem>
#include <memory>

static std::unique_ptr<Ort::Env> g_env;
static std::unique_ptr<Ort::Session> g_session = nullptr;

bool tracer_ping()
{
    return true;
}

bool tracer_init(const char* model_path)
{
    try
    {
        g_env = std::make_unique<Ort::Env>(ORT_LOGGING_LEVEL_WARNING, "Tracer");
        Ort::SessionOptions options;
#ifdef _WIN32
        std::wstring path = std::filesystem::path(model_path).wstring();
        g_session = std::make_unique<Ort::Session>(*g_env, path.c_str(), options);
#else
        g_session = std::make_unique<Ort::Session>(*g_env, model_path, options);
#endif
        return true;
    }
    catch (const Ort::Exception&)
    {
        return false;
    }
}

void tracer_shutdown()
{
    g_env.reset();
    g_session.reset();
}

bool tracer_process_frame(
    uint8_t *pixels, 
    int width, int height,
    int pixel_format,
    float *out_keypoints)
{
    if (!pixels || !out_keypoints || !g_session) return false;

    cv::Mat frame;

    switch (static_cast<TracerPixelFormat>(pixel_format))
    {
    case TRACER_PIXEL_FORMAT_NV21:
    {
        int yuv_height = height + (height / 2);
        cv::Mat yuv_mat(yuv_height, width, CV_8UC1, pixels);
        cv::cvtColor(yuv_mat, frame, cv::COLOR_YUV2BGR_NV21);
        break;
    }
    case TRACER_PIXEL_FORMAT_NV12:
    {
        int yuv_height = height + (height / 2);
        cv::Mat yuv_mat(yuv_height, width, CV_8UC1, pixels);
        cv::cvtColor(yuv_mat, frame, cv::COLOR_YUV2BGR_NV12);
        break;
    }
    case TRACER_PIXEL_FORMAT_I420:
    {
        int yuv_height = height + (height / 2);
        cv::Mat yuv_mat(yuv_height, width, CV_8UC1, pixels);
        cv::cvtColor(yuv_mat, frame, cv::COLOR_YUV2BGR_I420);
        break;
    }
    case TRACER_PIXEL_FORMAT_BGRA:
    {
        cv::Mat bgra_mat(height, width, CV_8UC4, pixels);
        cv::cvtColor(bgra_mat, frame, cv::COLOR_BGRA2BGR);
        break;
    }
    case TRACER_PIXEL_FORMAT_RGBA:
    {
        cv::Mat rgba_mat(height, width, CV_8UC4, pixels);
        cv::cvtColor(rgba_mat, frame, cv::COLOR_RGBA2BGR);
        break;
    }
    case TRACER_PIXEL_FORMAT_BGR:
    {
        frame = cv::Mat(height, width, CV_8UC3, pixels);
        break;
    }
    default:
        return false;
    }
    
    if (frame.empty()) return false;
    
    try
    {
        int64_t in_wid = g_session->GetInputTypeInfo(0).GetTensorTypeAndShapeInfo().GetShape()[3];
        int64_t in_hei = g_session->GetInputTypeInfo(0).GetTensorTypeAndShapeInfo().GetShape()[2];
        
        Ort::AllocatorWithDefaultOptions allocator;

        Ort::AllocatedStringPtr input_name_ptr = g_session->GetInputNameAllocated(0, allocator);
        Ort::AllocatedStringPtr output_name_ptr = g_session->GetOutputNameAllocated(0, allocator);

        cv::Mat blob;
        cv::dnn::blobFromImage(frame, blob, 1.0 / 255.0, 
            cv::Size(static_cast<int>(in_wid), static_cast<int>(in_hei)), 
            cv::Scalar(0,0,0), true, false);
        
        Ort::MemoryInfo memory_info = Ort::MemoryInfo::CreateCpu(OrtArenaAllocator, OrtMemTypeDefault);
        
        std::vector<int64_t> input_shape = { blob.size[0], blob.size[1], blob.size[2], blob.size[3] };
        Ort::Value input_tensor = Ort::Value::CreateTensor<float>(
            memory_info,
            blob.ptr<float>(),
            blob.total(),
            input_shape.data(), input_shape.size()
        );

        std::vector<const char*> input_names = {input_name_ptr.get()};
        std::vector<const char*> output_names = {output_name_ptr.get()};

        std::vector<Ort::Value> output_tensors = g_session->Run(
            Ort::RunOptions{nullptr},
            input_names.data(), &input_tensor, 1,
            output_names.data(), 1);

        float *data = output_tensors[0].GetTensorMutableData<float>();
        Detection detected = Detection::best_candidate(data);

        float scale_x = static_cast<float>(frame.cols) / static_cast<float>(in_wid);
        float scale_y = static_cast<float>(frame.rows) / static_cast<float>(in_hei);

        detected.rescale(scale_x, scale_y);

        for (size_t i = 0; i < Detection::key_num; i++)
        {
            out_keypoints[i * 3 + 0] = detected.keypoints[i].pos.x;
            out_keypoints[i * 3 + 1] = detected.keypoints[i].pos.y;
            out_keypoints[i * 3 + 2] = detected.keypoints[i].conf;
        }

        return true;
    }
    catch(const Ort::Exception&)
    {
        return false;
    }
}