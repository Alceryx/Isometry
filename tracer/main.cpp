#include "detection.hpp"
#include "tracer.hpp"

#include <onnxruntime_cxx_api.h>
#include <opencv2/opencv.hpp>
#include <opencv2/dnn.hpp>

#include <iostream>

int main(void)
{
    Tracer tracer{};
    bool status = tracer.Init("models/yolo26s-pose.onnx");

    if (!status)
    {
        std::cerr << "Error Loading Model" << "\n";
    }

    cv::VideoCapture vid("tests/Ang_Occ_Hor.mov");
    cv::Mat frame;

    while (vid.read(frame))
    {
        std::optional<Detection> detected = tracer.DetectPose(frame);

        if (detected.has_value())
        {
            tracer.AnnotateFrame(frame, detected.value());
        }
    
        // std::map<Joint, float> joint_angles;
    
        // std::optional<float> re_ang = detected.Angle(detected.kp(Joint::RightShoulder), detected.kp(Joint::RightElbow), detected.kp(Joint::RightWrist));
    
        // if (re_ang.has_value())
        // {
        //     joint_angles[Joint::RightElbow] = re_ang.value();
        //     std::cout << "Right Elbow Angle: " << joint_angles[Joint::RightElbow] << "\n";
        // }


        // tracer.Snippet(frame, detected);


        cv::imshow("Tracer", frame);
        if (cv::waitKey(1) == 27) break;
    }

    return EXIT_SUCCESS;
}