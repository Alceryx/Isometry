#ifndef EXTRACTOR
#define EXTRACTOR

#include "mesh.hpp"

#include <onnxruntime_cxx_api.h>
#include <opencv2/opencv.hpp>
#include <opencv2/dnn.hpp>

#include <filesystem>
#include <memory>
#include <string>
#include <vector>

class Extractor
{
    public:
    Extractor() = default;
    Extractor(Ort::Env& env, const std::string& model_path);

    std::vector<Mesh> Extract();

    private:
    std::unique_ptr<Ort::Session> session;
};

#endif