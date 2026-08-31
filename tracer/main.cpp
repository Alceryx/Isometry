#include "detection.hpp"
#include "tracer_api.h"

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
    try
    {
        Ort::Env env(ORT_LOGGING_LEVEL_WARNING, "Clinker");
        Ort::SessionOptions options;
        const wchar_t* model_path = L"yolov8n-pose.onnx";
        Ort::Session session(env, model_path, options);

        Ort::AllocatorWithDefaultOptions allocator;
        
        cv::VideoCapture cap(0);
        cv::Mat frame;

        int64_t in_wid = session.GetInputTypeInfo(0).GetTensorTypeAndShapeInfo().GetShape()[3];
        int64_t in_hei = session.GetInputTypeInfo(0).GetTensorTypeAndShapeInfo().GetShape()[2];

        while (cap.read(frame))
        {

            if (frame.empty())
            {
                std::cerr << "Error: Could not find or open test.jpg\n";
                return -1;
            }
            
            cv::Mat blob;
            cv::dnn::blobFromImage(frame, blob, 1.0 / 255.0, 
                cv::Size(static_cast<int>(in_wid), static_cast<int>(in_hei)), 
                cv::Scalar(0,0,0), true, false);

            Ort::MemoryInfo memory_info = Ort::MemoryInfo::CreateCpu(OrtArenaAllocator, OrtMemTypeDefault);

            std::vector<int64_t> input_shape = {blob.size[0], blob.size[1], blob.size[2], blob.size[3]};

            size_t input_tensor_size = blob.total();
            Ort::Value input_tensor = Ort::Value::CreateTensor<float>(
                memory_info,
                blob.ptr<float>(),
                input_tensor_size,
                input_shape.data(),
                input_shape.size()
            );


            Ort::AllocatedStringPtr input_name_ptr = session.GetInputNameAllocated(0, allocator);
            Ort::AllocatedStringPtr output_name_ptr = session.GetOutputNameAllocated(0, allocator);
            
            std::vector<const char*> input_names = {input_name_ptr.get()};
            std::vector<const char*> output_names = {output_name_ptr.get()};

            std::vector<Ort::Value> output_tensors = session.Run(
                Ort::RunOptions{nullptr},
                input_names.data(), &input_tensor, 1,
                output_names.data(), 1
            );

            std::vector<int64_t> output_shape = output_tensors[0].GetTensorTypeAndShapeInfo().GetShape();

            float* data = output_tensors[0].GetTensorMutableData<float>();
            Detection detected = Detection::best_candidate(data);

            float scale_x = static_cast<float>(frame.cols) / static_cast<float>(in_wid);
            float scale_y = static_cast<float>(frame.rows) / static_cast<float>(in_hei);

            detected.rescale(scale_x, scale_y);
            
            for (Keypoint& kp : detected.keypoints)
            {
                if (!detected.visible(kp)) continue;
                cv::circle(frame, 
                    cv::Point(static_cast<int>(kp.pos.x), static_cast<int>(kp.pos.y)), 
                    7, cv::Scalar(0, 255, 0), -1);
            }
            
            std::map<Joint, float> joint_angles;

            std::optional<float> re_ang = detected.angle(detected.kp(Joint::RightShoulder), detected.kp(Joint::RightElbow), detected.kp(Joint::RightWrist));

            if (re_ang.has_value())
            {
                joint_angles[Joint::RightElbow] = re_ang.value();
                std::cout << "Right Elbow Angle: " << joint_angles[Joint::RightElbow] << "\n";
            }
            
            cv::imshow("Tracer", frame);
            if (cv::waitKey(1) == 27) break;
        }
    }
    catch (const Ort::Exception& e)
    {
        std::cerr << "ONNX Runtime Exception: " << e.what() << "\n";
        return -1;
    }

    return EXIT_SUCCESS;
}