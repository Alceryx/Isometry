#include "detection.hpp"

namespace
{
    inline float Read(const float* data, size_t col, size_t candidate)
    {
        return data[candidate * Detection::KEY_DIM + col];
    }
}

Detection::Detection(const float* data, size_t candidate)
{
    box_min = Vec2(Read(data, BOX_COL, candidate), Read(data, BOX_COL + 1, candidate));
    box_max = Vec2(Read(data, BOX_COL + 2, candidate), Read(data, BOX_COL + 3, candidate));

    for (size_t i = 0; i < STATS_SZ; i++)
    {
        stats[i] = Read(data, STATS_COL + i, candidate);
    }

    for (size_t i = 0; i < KEY_NUM; i++)
    {
        size_t col = KEY_COL + i * 3;
        keypoints[i] = {Vec2(Read(data, col, candidate), Read(data, col + 1, candidate)),
                        Read(data, col + 2, candidate)};
    }
}

void Detection::Rescale(float scale_x, float scale_y)
{
    box_min *= Vec2(scale_x, scale_y);
    box_max *= Vec2(scale_x, scale_y);

    for (Keypoint& kp : keypoints)
    {
        kp.pos *= Vec2(scale_x, scale_y);
    }
}