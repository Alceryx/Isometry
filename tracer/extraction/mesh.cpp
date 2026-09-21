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

Mesh::Mesh(const std::unordered_map<std::string, float*>&outputs)
{
    for (size_t i = 0; i < POSE_NUM; i++) poses[i] = outputs.at("poses")[i];
    for (size_t i = 0; i < BETAS_NUM; i++) betas[i] = outputs.at("betas")[i];
    for (size_t i = 0; i < CAM_T_NUM; i++) pd_cam_t[i] = outputs.at("pd_cam_t")[i];

    for (size_t i = 0; i < KEY_NUM; i++) keypoints3d[i] = ReadVec3(outputs.at("pd_kp3d"), i);
    for (size_t i = 0; i < KEY_NUM; i++) keypoints2d[i] = ReadVec2(outputs.at("pd_kp2d"), i);
}

void Mesh::ExtractVertices(const float* data)
{
    for (size_t i = 0; i < VERTICES_NUM; i++)
    {
        vertices[i] = ReadVec3(data, i);
    }
}

Vec3 Mesh::CamCropToFull(const Vec2& box_center, const float box_size, const Vec2& image)
{
    float scale = pd_cam_t[0];
    float h_offset = pd_cam_t[1];
    float v_offset = pd_cam_t[2];
    
    // TODO: Maybe move to extractor (should not hard code 256)
    float focal_length = 5000.0f / 256.0f * std::max(image.x(), image.y());

    float tz = (2.0f * focal_length) / (scale * box_size);

    Vec2 converted = 2.0f * (box_center - image/2) / (scale * box_size);
    float tx = converted.x() + h_offset;
    float ty = converted.y() + v_offset;

    return Vec3(tx, ty, tz);
}