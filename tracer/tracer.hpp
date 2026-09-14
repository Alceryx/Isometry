#ifndef TRACER
#define TRACER

#include "detector.hpp"
#include "detection.hpp"

#include <onnxruntime_cxx_api.h>
#include <opencv2/opencv.hpp>
#include <opencv2/dnn.hpp>

#include <string>
#include <cstdint>
#include <memory>
#include <filesystem>
#include <optional>

class Tracer
{
    public:

    bool Init(const std::string& model_path);
    void Shutdown();

    std::optional<Detection> DetectPose(cv::Mat& frame);

    void AnnotateFrame(cv::Mat& frame, Detection& detection);

    // Debugging
    void Snippet(cv::Mat& frame, Detection& detection);

    private: 
    Ort::Env env;

    Detector yolo;

    void ConnectJoint(cv::Mat&frame, Keypoint &start, Keypoint &end);
};

#endif