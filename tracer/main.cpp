#include "detection.hpp"
#include "tracer.hpp"
#include "metrics.hpp"

#include <onnxruntime_cxx_api.h>
#include <opencv2/opencv.hpp>
#include <opencv2/dnn.hpp>

#include <iostream>
#include <optional>
#include <string>

// Debugging
#include <filesystem>

void TestAll(Tracer& tracer)
{
    std::string path = "tests";
    for (const auto& entry : std::filesystem::directory_iterator(path))
    {
        auto file_path = entry.path();
        if (file_path.extension().string() != ".jpg") continue;
        std::cout << "\n" << file_path.string() << "\n";
        cv::Mat img = cv::imread(file_path.string());
        tracer.Analytic(img);
    }
}

int main(void)
{
    std::string yolo_path = "models/yolo26s-pose.onnx";
    std::string hmr2_path = "models/hsmr/hsmr.onnx";

    Tracer tracer{};
    bool status = tracer.Init(yolo_path, hmr2_path);

    if (!status)
    {
        std::cerr << "Error Loading Model" << "\n";
    }

    cv::VideoCapture vid("tests/Ang_Up_Occ.mov");
    cv::Mat frame;

    while (vid.read(frame))
    {
        std::optional<Detection> detected = tracer.DetectBody(frame);
        if (!detected.has_value()) continue;
        Detection& target = detected.value();

        tracer.AnnotateFrame(frame, target);
        Rig body = tracer.ExtractRig(frame, target);
        
        // std::cout << body.poses[0] << "\n";
        std::cout << Metrics::Angle(target.kp(Joint::LeftShoulder).pos, target.kp(Joint::LeftElbow).pos, target.kp(Joint::LeftWrist).pos) << "\n";

        cv::imshow("Tracer", frame);
        if (cv::waitKey(1) == 27) break;
    }

    return EXIT_SUCCESS;
}