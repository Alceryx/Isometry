#ifndef TRACER
#define TRACER

#include "detector.hpp"
#include "detection.hpp"
#include "extractor.hpp"
#include "rig.hpp"

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

    bool Init(const std::string& det_path, const std::string& ext_path);
    void Shutdown();

    std::optional<Detection> DetectBody(cv::Mat& frame);
    std::optional<Rig> ExtractRig(cv::Mat& frame, const Detection& detection);

    void AnnotateFrame(cv::Mat& frame, Detection& detection);

    // Debugging
    void Analytic(cv::Mat& img);

private: 
    // TODO: No hmr2 but is it a mesh?
    Ort::Env env;
    Detector yolo;
    Extractor hsmr;

    void ConnectJoint(cv::Mat&frame, Keypoint &start, Keypoint&end);
};

#endif