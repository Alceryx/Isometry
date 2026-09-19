#include "tracer_api.h"

Tracer g_tracer{};

bool tracer_ping()
{
    return true;
}

bool tracer_init(const char* det_path, const char* ext_path)
{
    return g_tracer.Init(det_path, ext_path);
}

void tracer_shutdown()
{
    g_tracer.Shutdown();
}

bool tracer_process_frame(
    uint8_t *pixels, 
    int width, int height,
    int pixel_format,
    float *out_keypoints)
{
    if (!pixels || !out_keypoints) return false;

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

    std::optional<Detection> detected = g_tracer.DetectBody(frame);
    if (!detected.has_value()) return false;

    Detection body = detected.value();
    for (size_t i = 0; i < Detection::KEY_NUM; i++)
    {
        out_keypoints[i * 3 + 0] = body.keypoints[i].pos.x();
        out_keypoints[i * 3 + 1] = body.keypoints[i].pos.y();
        out_keypoints[i * 3 + 2] = body.keypoints[i].conf;
    }

    return true;
}

bool tracer_video_check(const char *path)
{
    cv::VideoCapture video(path);
    if (!video.isOpened())
        return false;

    cv::Mat frame;
    bool read_ok = video.read(frame);
    return read_ok && !frame.empty();
}