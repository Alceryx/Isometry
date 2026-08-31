#include "Detection.hpp"

namespace
{
    inline float read(const float *data, size_t row, size_t candidate)
    {
        return data[row * Detection::dim_size + candidate];
    }
}

Detection::Detection(const float *data, size_t can_idx)
{
    for (size_t i = 0; i < key_row; i++) 
    {
        box[i] = read(data, i, can_idx);
    }

    for (size_t i = 0; i < key_num; i++)
    {
        size_t row = key_row + i * 3;
        keypoints[i] = {read(data, row, can_idx), 
                        read(data, row + 1, can_idx),
                        read(data, row + 2, can_idx)};
    }
}

Detection Detection::best_candidate(const float *data)
{
    size_t best_idx = 0;
    for (size_t c = 1; c < dim_size; c++)
    {
        if (read(data, 4, c) > read(data, 4, best_idx)) best_idx = c;
    }
    return Detection(data, best_idx);
}

std::optional<float> Detection::angle(const Keypoint &start, const Keypoint &mid, const Keypoint &end) const
{
    if (!visible(start) || !visible(mid) || !visible(end))
    {
        return std::nullopt;
    }

    Vec2 v1 = start.pos - mid.pos;
    Vec2 v2 = end.pos - mid.pos;

    float angle = std::acos(v1.dot(v2) / (v1.length() * v2.length()));

    return angle * 180.0 / 3.14159265358979323846;
}

void Detection::rescale(float scale_x, float scale_y)
{
    for (Keypoint& kp : keypoints)
    {
        kp.pos.x *= scale_x;
        kp.pos.y *= scale_y;
    }
}