#include "extractor.hpp"

Extractor::Extractor(Ort::Env& env, const std::string& model_path)
{
    Ort::SessionOptions options;

    #ifdef _WIN32
    std::wstring path = std::filesystem::path(model_path).wstring();
    session = std::make_unique<Ort::Session>(env, path.c_str(), options);
    #else
    session = std::make_unique<Ort::Session>(env, model_path.c_str(), options);
    #endif    
}
