#ifndef PREPROCESS
#define PROPROCESS

#include "vec.hpp"

#include <opencv2/opencv.hpp>
#include <opencv2/dnn.hpp>

#include <algorithm>

struct CropBox
{
    Vec2 center;
    float size;
};

class Preprocess
{
    public:
    static CropBox ComputeCropBox(const Vec2 &box_min, const Vec2 &box_max, float tgt_w, float tgt_h);
    static cv::Mat CropWithPadding(const cv::Mat& frame, const CropBox& box);
    static cv::Mat NormalizeToBlob(const cv::Mat& crop, const Vec2& input_size);
};

#endif