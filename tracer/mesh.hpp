#ifndef MESH
#define MESH

#include <math/vec.hpp>

#include <array>

class Mesh
{
    public:
    static constexpr size_t VERTICES_NUM = 6890;
    static constexpr size_t KEY_NUM = 44;

    std::array<Vec3, VERTICES_NUM> vertices;
    std::array<Vec3, KEY_NUM> keypoints3d;
    std::array<Vec3, KEY_NUM> keypoints2d;
};

#endif