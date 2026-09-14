#pragma once

#include "detection.hpp"
#include "tracer.hpp"

#include <onnxruntime_cxx_api.h>
#include <opencv2/opencv.hpp>
#include <opencv2/dnn.hpp>

#include <vector>
#include <filesystem>
#include <memory>
#include <cstdint>

#ifdef _WIN32
#define TRACER_EXPORT extern "C" __declspec(dllexport)
#else
#define TRACER_EXPORT extern "C" __attribute__((visibility("default")))
#endif

typedef enum
{
    TRACER_PIXEL_FORMAT_NV21 = 0,
    TRACER_PIXEL_FORMAT_NV12 = 1,
    TRACER_PIXEL_FORMAT_I420 = 2,
    TRACER_PIXEL_FORMAT_BGRA = 3,
    TRACER_PIXEL_FORMAT_RGBA = 4,
    TRACER_PIXEL_FORMAT_BGR = 5
} TracerPixelFormat;

TRACER_EXPORT bool tracer_ping();
TRACER_EXPORT bool tracer_init(const char* model_path);
TRACER_EXPORT void tracer_shutdown();
TRACER_EXPORT bool tracer_process_frame(
    uint8_t* pixels, 
    int width, int height,
    int pixel_format,
    float* out_keypoints
);


TRACER_EXPORT bool tracer_video_check(const char* path);