#include "mesh.hpp"

namespace
{
    inline float Read(const float* data, size_t row, size_t col, size_t row_size)
    {
        return data[row * row_size + col];
    }

    inline Vec2 ReadVec2(const float* data, size_t row, size_t row_size = 2)
    {
        return Vec2(Read(data, row, 0, row_size), Read(data, row, 1, row_size));
    }

    inline Vec3 ReadVec3(const float* data, size_t row, size_t row_size = 3)
    {
        return Vec3(Read(data, row, 0, row_size), Read(data, row, 1, row_size), Read(data, row, 2, row_size));
    }

    inline Mat3 ReadMat3(const float* data, size_t row, size_t row_size = 9)
    {
        const float* base = data + row * row_size;
        return Mat3(ReadVec3(base, 0), ReadVec3(base, 1), ReadVec3(base, 2));
    }
}

Mesh::Mesh(const float* const* outputs)
{
    const float* key3d_data = outputs[1];
    const float* key2d_data = outputs[2];
    const float* orient_data = outputs[3];
    const float* pose_data = outputs[4];
    const float* betas_data = outputs[5];
    const float* cam_data = outputs[6];
    const float* cam_t_data = outputs[7];

    for (size_t i = 0; i < KEY_NUM; i++)
    {
        keypoints3d[i] = ReadVec3(key3d_data, i);
    }

    for (size_t i = 0; i < KEY_NUM; i++)
    {
        keypoints2d[i] = ReadVec2(key2d_data, i);
    }

    global_orient = ReadMat3(orient_data, 0).Transpose();
    for (size_t i = 0; i < BODY_POSE_NUM; i++)
    {
        body_pose[i] = ReadMat3(pose_data, i).Transpose();
    }
    for (size_t i = 0; i < BETAS_NUM; i++) betas[i] = betas_data[i];
    for (size_t i = 0; i < CAM_NUM; i++) pred_cam[i] = cam_data[i];
    for (size_t i = 0; i < CAM_T_NUM; i++) pred_cam_t[i] = cam_t_data[i];
}

void Mesh::ExtractVertices(const float* data)
{
    for (size_t i = 0; i < VERTICES_NUM; i++)
    {
        vertices[i] = ReadVec3(data, i);
    }
}