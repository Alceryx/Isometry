#include <Windows.h>
#include <iostream>
#include <cstdint>
#include <vector>

typedef bool (*TracerPingFn)();
typedef bool (*TracerInitFn)(const char*);
typedef bool (*TracerProcessFrameFn)(uint8_t*, int, int, float*);

int main()
{
    HMODULE lib = LoadLibraryA("tracer.dll");
    if (lib == nullptr)
    {
        std::cerr << "Failed to load tracer.dll\n";
        return -1;
    }

    TracerInitFn tracer_init = (TracerInitFn)GetProcAddress(lib, "tracer_init");
    if (tracer_init == nullptr)
    {
        std::cerr << "Failed to find tracer_init\n";
        FreeLibrary(lib);
        return -1;
    }
    bool result = tracer_init("yolov8n-pose.onnx");
    std::cout << "tracer_init() returned: " << result << "\n";

    TracerProcessFrameFn tracer_process_frame = (TracerProcessFrameFn)GetProcAddress(lib, "tracer_process_frame");
    if (tracer_process_frame == nullptr)
    {
        std::cerr << "Failed to find tracer_process_frame\n";
        FreeLibrary(lib);
        return -1;
    }

    int width = 640;
    int height = 400;

    std::vector<uint8_t> pixels(static_cast<size_t>(width) * height * 3 / 2, 128);
    std::vector<float> out_keypoints(17 * 3, 0.0f);

    bool ok = tracer_process_frame(pixels.data(), width, height, out_keypoints.data());
    std::cout << "tracer_process_frame() returned: " << ok << "\n";

    for (size_t i = 0; i < 17; i++)
    {
        std::cout << "kp[" << i << "] = (" << out_keypoints[i * 3 + 0] << ", " << out_keypoints[i * 3 + 1] << ", " << out_keypoints[i * 3 + 2] << ")\n";
    }

    FreeLibrary(lib);
    return 0;
}