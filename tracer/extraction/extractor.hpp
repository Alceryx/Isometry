#ifndef EXTRACTOR
#define EXTRACTOR

#include "rig.hpp"
#include "detection.hpp"
#include "vec.hpp"
#include "preprocess.hpp"

#include <onnxruntime_cxx_api.h>
#include <opencv2/opencv.hpp>
#include <opencv2/dnn.hpp>

#include <filesystem>
#include <memory>
#include <string>
#include <vector>
#include <unordered_map>
#include <assert.h>

class Extractor
{
    public:
    Extractor() = default;
    Extractor(Ort::Env& env, const std::string& model_path);

    Rig Extract(cv::Mat& frame, const Detection& detection);

    private:
    std::unique_ptr<Ort::Session> session;

    Vec2 input_size;
    
    private:
    static constexpr float kTgtW = 192.0f;
    static constexpr float kTgtH = 256.0f;
};

#endif