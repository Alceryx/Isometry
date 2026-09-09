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

    static constexpr float VISIBILITY_THRESHOLD = 0.5;
    bool visible() const { return conf >= VISIBILITY_THRESHOLD; };
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
    static constexpr size_t KEY_NUM = 17;
    static constexpr size_t KEY_COL = 6;
    static constexpr size_t KEY_DIM = 57;

    std::array<Keypoint, KEY_NUM> keypoints;
    std::array<float, KEY_COL> box;

    Detection() = default;
    Detection(const float *data, size_t candidate);

    void Rescale(float scale_x, float scale_y);

    Keypoint kp(Joint j) const { return keypoints[static_cast<size_t>(j)]; };


    // TODO: Move to Vec or Math
    std::optional<float> Angle(const Keypoint& start, const Keypoint& mid, const Keypoint& end) const;
};

#endif