#include "detection.hpp"

namespace
{
    inline float read(const float *data, size_t col, size_t candidate)
    {
        return data[candidate * Detection::KEY_DIM + col];
    }
}

Detection::Detection(const float *data, size_t candidate)
{
    for (size_t i = 0; i < BOX_SZ; i++) 
    {
        box[i] = read(data, BOX_COL + i, candidate);
    }

    for (size_t i = 0; i < STATS_SZ; i++) 
    {
        stats[i] = read(data, STATS_COL + i, candidate);
    }

    for (size_t i = 0; i < KEY_NUM; i++)
    {
        size_t col = KEY_COL + i * 3;
        keypoints[i] = {read(data, col, candidate), 
                        read(data, col + 1, candidate),
                        read(data, col + 2, candidate)};
    }
}

std::optional<float> Detection::Angle(const Keypoint& start, const Keypoint& mid, const Keypoint& end) const
{
    if (!start.visible() || !mid.visible() || !end.visible() )
    {
        return std::nullopt;
    }
    
    Vec2 v1 = start.pos - mid.pos;
    Vec2 v2 = end.pos - mid.pos;

    float angle = std::acos(v1.dot(v2) / (v1.length() * v2.length()));

    return angle * 180.0 / (float)3.14159265358979323846;
}

void Detection::Rescale(float scale_x, float scale_y)
{
    box[0] *= scale_x; box[2] *= scale_x;
    box[1] *= scale_y; box[3] *= scale_y;

    for (Keypoint& kp : keypoints)
    {
        kp.pos.x *= scale_x;
        kp.pos.y *= scale_y;
    }
}