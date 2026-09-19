#ifndef TRACER
#define TRACER

#include "detector.hpp"
#include "detection.hpp"
#include "extractor.hpp"
#include "mesh.hpp"

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
    std::optional<Mesh> ExtractMesh(cv::Mat& frame, const Detection& detection);

    void AnnotateFrame(cv::Mat& frame, Detection& detection);

    // Debugging
    void Snippet(cv::Mat& frame, Detection& detection);

    private: 
    Ort::Env env;
    Detector yolo;
    Extractor hmr2;

    void ConnectJoint(cv::Mat&frame, Keypoint &start, Keypoint &end);
};

#endif