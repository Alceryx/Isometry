#ifndef MESH
#define MESH

#include "vec.hpp"

#include <algorithm>
#include <array>
#include <string>
#include <unordered_map>

class Rig
{
    public:
    
    static constexpr size_t POSE_NUM = 46;
    static constexpr size_t BETAS_NUM = 10;
    static constexpr size_t CAM_T_NUM = 3;

    Mat3 global_orient{};
    std::array<float, POSE_NUM> poses;
    std::array<float, BETAS_NUM> betas;
    std::array<float, CAM_T_NUM> pd_cam_t;
    
    static constexpr size_t VERTICES_NUM = 6890;
    static constexpr size_t KEY_NUM = 44;

    std::array<Vec3, VERTICES_NUM> vertices;
    std::array<Vec3, KEY_NUM> keypoints3d;
    std::array<Vec2, KEY_NUM> keypoints2d;
    
    
    Rig() = default;
    Rig(const std::unordered_map<std::string, float*>& outputs);
    void ExtractVertices(const float *data);

    Vec3 CamCropToFull(const Vec2& box_center, const float box_size, const Vec2& image);
};

#endif