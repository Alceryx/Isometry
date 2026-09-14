#ifndef DETECTOR
#define DETECTOR

#include "detection.hpp"

#include <onnxruntime_cxx_api.h>
#include <opencv2/opencv.hpp>
#include <opencv2/dnn.hpp>

#include <memory>
#include <string>
#include <filesystem>
#include <vector>

class Detector
{
    public:
    static constexpr size_t DETECT_NUM = 300;
    static constexpr float DETECT_THRESHOLD = 0.5;

    Detector() = default;
    Detector(const Ort::Env& env, const std::string& model_path);

    std::vector<Detection> Detect(cv::Mat& frame);

    private:
    std::unique_ptr<Ort::Session> session;

    int64_t input_width = 0;
    int64_t input_height = 0;
    int frame_width = 0;
    int frame_height = 0;
};

#endif