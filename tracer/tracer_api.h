#pragma once

#include <cstdint>

#ifdef _WIN32
    #define TRACER_EXPORT extern "C" __declspec(dllexport)
#else
    #define TRACER_EXPORT extern "C" __attribute__((visibility("default")))
#endif

TRACER_EXPORT bool tracer_ping();
TRACER_EXPORT bool tracer_init(const char* model_path);
TRACER_EXPORT void tracer_shutdown();
TRACER_EXPORT bool tracer_process_frame(
    uint8_t* pixels, int width, int height,
    float* out_keypoints
);