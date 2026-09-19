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

    cv::VideoCapture vid("tests/Ang_Occ_Hor.mov");
    cv::Mat frame;

    cv::Mat img = cv::imread("tests/Ang_Hor_BodStr_ArmStr_Occ.jpg");

    std::optional<Detection> detect = tracer.DetectBody(img);

    if (!detect.has_value()) std::cout << "err" << "\n";

    Detection& body = detect.value();
    tracer.AnnotateFrame(img, body);

    std::cout << "Box Min: " << body.box_min << "\n";
    std::cout << "Box Max: " << body.box_max << "\n";

    // while (vid.read(frame))
    // {
    //     std::optional<Detection> detected = tracer.DetectBody(frame);

    //     if (!detected.has_value()) continue;
    //     tracer.AnnotateFrame(frame, detected.value());
        
    //     // std::optional<Mesh> mesh = tracer.ExtractMesh(frame, detected.value());

    //     // if (!mesh.has_value()) continue;
        
    //     // std::cout << mesh.value().betas[0] << "\n";
    
    //     // std::map<Joint, float> joint_angles;
    
    //     // std::optional<float> re_ang = detected.Angle(detected.kp(Joint::RightShoulder), detected.kp(Joint::RightElbow), detected.kp(Joint::RightWrist));
    
    //     // if (re_ang.has_value())
    //     // {
    //     //     joint_angles[Joint::RightElbow] = re_ang.value();
    //     //     std::cout << "Right Elbow Angle: " << joint_angles[Joint::RightElbow] << "\n";
    //     // }

    //     cv::imshow("Tracer", frame);
    //     if (cv::waitKey(1) == 27) break;
    // }

    return EXIT_SUCCESS;
}