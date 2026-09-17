#include "tracer.hpp"

bool Tracer::Init(const std::string& det_path, const std::string& ext_path)
{
    try {
    env = Ort::Env(ORT_LOGGING_LEVEL_WARNING, "Tracer");
    yolo = {env, det_path};
    hmr2 = {env, ext_path};
    return true;

    } catch (const Ort::Exception &e) {
        std::cerr << "ONNX Runtime Exception: " << e.what() << "\n";
        return false;
    }
}

std::optional<Detection> Tracer::DetectPose(cv::Mat& frame)
{
    std::vector<Detection> detections = yolo.Detect(frame);
    if (detections.empty()) return std::nullopt;
    return detections[0];
}

std::optional<Mesh> Tracer::ExtractMesh(cv::Mat& frame, const Detection& detection)
{
    return hmr2.Extract(frame, detection);
}

void Tracer::Shutdown()
{
    delete this;
}

void Tracer::AnnotateFrame(cv::Mat& frame, Detection& detection)
{
    cv::rectangle(frame, 
    cv::Point(static_cast<int>(detection.box_min.x()), static_cast<int>(detection.box_min.y())),
    cv::Point(static_cast<int>(detection.box_max.x()), static_cast<int>(detection.box_max.y())),
    cv::Scalar(60,60,229), 3);

    for (Keypoint &kp : detection.keypoints)
    {
        // if (!kp.visible()) continue;
        // cv::circle(frame,
        // cv::Point(static_cast<int>(kp.pos.x), static_cast<int>(kp.pos.y)),
        // 7, cv::Scalar(0, 255, 0), cv::FILLED);
    }

    auto conf_y = detection.box_min.y() - 15;
    if (conf_y < 0) conf_y = detection.box_max.y() + 30; 
    cv::putText(frame, "Conf " + std::to_string(detection.stats[0]),
    cv::Point(static_cast<int>(detection.box_min.x()), static_cast<int>(conf_y)),
    cv::FONT_HERSHEY_SIMPLEX, 1,
    cv::Scalar(60, 60, 229), 1);

    // ConnectJoint(frame, detection.kp(Joint::RightShoulder), detection.kp(Joint::RightElbow));
    // ConnectJoint(frame, detection.kp(Joint::RightElbow), detection.kp(Joint::RightWrist));
}

void Tracer::ConnectJoint(cv::Mat& frame, Keypoint& start, Keypoint& end)
{
    if (!start.visible() || !end.visible()) return;
    cv::line(frame, cv::Point(static_cast<int>(start.pos.x()), static_cast<int>(start.pos.y())),
    cv::Point(static_cast<int>(end.pos.x()), static_cast<int>(end.pos.y())),
    cv::Scalar(60,60,229), 5);
}


// Debugging
void Tracer::Snippet(cv::Mat& frame, Detection& detection)
{
    if (cv::waitKey(1) == 99)
    {
        std::cout << "x_min: " << detection.box_min.x() << " | y_min: " << detection.box_min.y() << "\n";
        std::cout << "x_max: " << detection.box_max.x() << " | y_max: " << detection.box_max.y() << "\n";
        cv::imwrite("snippet.jpg", frame);
    }
}
