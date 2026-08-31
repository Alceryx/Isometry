#ifndef DETECTION
#define DETECTION

#include "vec2.hpp"

#include <array>
#include <cassert>
#include <cmath>
#include <map>
#include <optional>

struct Keypoint
{
    Vec2 pos;
    float conf;
};

enum class Joint
{
    Nose = 0, 
    LeftShoulder = 5, RightShoulder = 6,
    LeftElbow = 7, RightElbow = 8,
    LeftWrist = 9, RightWrist = 10,
    LeftHip = 11, RightHip = 12,
    LeftKnee = 13, RightKnee = 14,
    LeftAnkle = 15, RightAnkle = 16
};

class Detection
{
    public:
    static constexpr size_t key_num = 17;
    static constexpr size_t key_row = 5;
    static constexpr size_t dim_size = 8400;

    static constexpr float visibility_threshold = 0.5;
    bool visible(const Keypoint& kp) const { return kp.conf >= visibility_threshold; };

    std::array<Keypoint, key_num> keypoints;
    std::array<float, key_row> box;

    Detection(const float *data, size_t can_idx);
    static Detection best_candidate(const float *data);

    Keypoint kp(Joint j) const { return keypoints[static_cast<size_t>(j)]; };
    float x(size_t index) const
    {
        assert(index < key_num);
        return keypoints[index].pos.x;
    }
    float y(size_t index) const
    {
        assert(index < key_num);
        return keypoints[index].pos.y;
    }
    float conf(size_t index) const
    {
        assert(index < key_num);
        return keypoints[index].conf;
    }

    void rescale(float scale_x, float scale_y);

    std::optional<float> angle(const Keypoint& start, const Keypoint& mid, const Keypoint& end) const;
    
};

#endif