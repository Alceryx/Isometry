#include "preprocess.hpp"

CropBox Preprocess::ComputeCropBox(const Vec2& box_min, const Vec2& box_max, float tgt_w, float tgt_h)
{
    Vec2 center = (box_min + box_max) / 2;
    float width = box_max.x() - box_min.x();
    float height = box_max.y() - box_min.y();
    float size = std::max(height, width * (tgt_h / tgt_w));
    return CropBox{center, size};
}
cv::Mat Preprocess::CropWithPadding(const cv::Mat& frame, const CropBox& box)
{
    int l = static_cast<int>(box.center.x() - box.size / 2);
    int u = static_cast<int>(box.center.y() - box.size / 2);
    int patch_size = static_cast<int>(box.size);

    cv::Mat crop = cv::Mat::zeros(patch_size, patch_size, frame.type());

    int valid_l = std::max(0, l);
    int valid_u = std::max(0, u);
    int valid_r = std::min(frame.cols, l + patch_size);
    int valid_b = std::min(frame.rows, u + patch_size);

    if (valid_r > valid_l && valid_b > valid_u)
    {
        cv::Rect src_roi(valid_l, valid_u, valid_r - valid_l, valid_b - valid_u);
        cv::Rect dst_roi(valid_l - l, valid_u - u, valid_r - valid_l, valid_b - valid_u);
        frame(src_roi).copyTo(crop(dst_roi));
    }
    return crop;
}
cv::Mat Preprocess::NormalizeToBlob(const cv::Mat& crop, const Vec2& input_size)
{
    cv::Mat patch;
    cv::resize(crop, patch, cv::Size(static_cast<int>(input_size.x()), static_cast<int>(input_size.y())), 0, 0, cv::INTER_LINEAR);

    cv::Mat input;
    patch.convertTo(input, CV_32FC3);
    // Mean: (0.485, 0.456, 0.406) | Std: (0.229, 0.224, 0.225)
    // (Pixel/255 - Mean) / Std = (Pixel - Mean*255) / Std*255
    cv::subtract(input, cv::Scalar(0.406, 0.456, 0.485) * 255, input);
    cv::divide(input, cv::Scalar(0.225, 0.224, 0.229) * 255, input);

    cv::Mat blob;
    cv::dnn::blobFromImage(input, blob, 1.0, cv::Size(), cv::Scalar(), true, false);
    return blob;
}