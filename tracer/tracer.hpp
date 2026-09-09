#ifndef TRACER
#define TRACER

#include "detection.hpp"

#include <onnxruntime_cxx_api.h>
#include <opencv2/opencv.hpp>
#include <opencv2/dnn.hpp>

#include <string>
#include <cstdint>
#include <memory>
#include <filesystem>

class Tracer
{
    public:
    
    bool Init(const std::string& model_path);
    void ProcessFrame(cv::Mat& frame);
    void Shutdown();
    Detection GetDetection(size_t candidate);

    void AnnotateFrame(cv::Mat& frame, Detection& detection);
    
    private: 
    std::unique_ptr<Ort::Env> env;
    std::unique_ptr<Ort::Session> session;
    
    int64_t input_width = 0;
    int64_t input_height = 0;
    int frame_width = 0;
    int frame_height = 0;

    float* data;

    void ConnectJoint(cv::Mat&frame, Keypoint &start, Keypoint &end);
};

#endif