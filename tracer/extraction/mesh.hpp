#ifndef MESH
#define MESH

#include "math/vec.hpp"

#include <array>

class Mesh
{
    public:
    static constexpr size_t VERTICES_NUM = 6890;
    static constexpr size_t KEY_NUM = 44;

    std::array<Vec3, VERTICES_NUM> vertices;
    std::array<Vec3, KEY_NUM> keypoints3d;
    std::array<Vec2, KEY_NUM> keypoints2d;

    static constexpr size_t BODY_POSE_NUM = 23;
    static constexpr size_t BETAS_NUM = 10;
    static constexpr size_t CAM_NUM = 3;
    static constexpr size_t CAM_T_NUM = 3;

    Mat3 global_orient{};
    std::array<Mat3, BODY_POSE_NUM> body_pose;
    std::array<float, BETAS_NUM> betas;
    std::array<float, CAM_NUM> pred_cam;
    std::array<float, CAM_T_NUM> pred_cam_t;

    Mesh(const float* const* outputs);
    void ExtractVertices(const float* data);
};

#endif