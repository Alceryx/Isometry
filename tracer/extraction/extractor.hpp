#ifndef EXTRACTOR
#define EXTRACTOR

#include "mesh.hpp"
#include "detection.hpp"
#include "vec.hpp"

#include <onnxruntime_cxx_api.h>
#include <opencv2/opencv.hpp>
#include <opencv2/dnn.hpp>

#include <filesystem>
#include <memory>
#include <string>
#include <vector>
#include <algorithm>
#include <optional>

class Extractor
{
    public:
    static constexpr float BOX_PAD = 1.2f;

    Extractor() = default;
    Extractor(Ort::Env& env, const std::string& model_path);

    std::optional<Mesh> Extract(cv::Mat& frame, const Detection& detection);

    private:
    std::unique_ptr<Ort::Session> session;

    Vec2 input_size;
};

#endif