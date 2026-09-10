#include "detection.hpp"
#include "tracer.hpp"

#include <onnxruntime_cxx_api.h>
#include <opencv2/opencv.hpp>
#include <opencv2/dnn.hpp>

#include <iostream>

void shape_info(Ort::Session& session)
{
    std::vector<int64_t> input_shape_info = session.GetInputTypeInfo(0).GetTensorTypeAndShapeInfo().GetShape();
    std::vector<int64_t> output_shape_info = session.GetOutputTypeInfo(0).GetTensorTypeAndShapeInfo().GetShape();

    std::cout << "Input Dimension: ";
    for (int64_t dim : input_shape_info)
        std::cout << dim << " ";
    std::cout << "\n";

    std::cout << "Output Dimension: ";
    for (int64_t dim : output_shape_info)
        std::cout << dim << " ";
    std::cout << "\n";
}

int main(void)
{
    Tracer tracer{};
    bool status = tracer.Init("models/yolo26s-pose.onnx");

    if (!status)
    {
        std::cerr << "Error Loading Model" << "\n";
    }

    cv::VideoCapture vid(0);
    cv::Mat frame;

    while (vid.read(frame))
    {
        tracer.ProcessFrame(frame);
        Detection detected = tracer.GetDetection(0);

        tracer.AnnotateFrame(frame, detected);
    
        std::map<Joint, float> joint_angles;
    
        std::optional<float> re_ang = detected.Angle(detected.kp(Joint::RightShoulder), detected.kp(Joint::RightElbow), detected.kp(Joint::RightWrist));
    
        if (re_ang.has_value())
        {
            joint_angles[Joint::RightElbow] = re_ang.value();
            std::cout << "Right Elbow Angle: " << joint_angles[Joint::RightElbow] << "\n";
        }
    
        cv::imshow("Tracer", frame);
        if (cv::waitKey(1) == 27) break;
    }

    tracer.Shutdown();

    return EXIT_SUCCESS;
}