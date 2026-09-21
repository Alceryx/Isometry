#include "detection.hpp"
#include "tracer.hpp"

#include <onnxruntime_cxx_api.h>
#include <opencv2/opencv.hpp>
#include <opencv2/dnn.hpp>

#include <iostream>
#include <optional>
#include <string>

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
        std::optional<Rig> mesh = tracer.ExtractRig(frame, target);

        if (!mesh.has_value()) continue;
        Rig& body = mesh.value();
        
        std::cout << body.poses[0] << "\n";

        cv::imshow("Tracer", frame);
        if (cv::waitKey(1) == 27) break;
    }

    return EXIT_SUCCESS;
}