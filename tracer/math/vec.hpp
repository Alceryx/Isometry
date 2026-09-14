#ifndef VEC
#define VEC

#include <cmath>
#include <array>

template<size_t N>
struct VecBase
{
    std::array<float, N> e;

    VecBase() { e.fill(0.0f); };
    VecBase(std::array<float, N> init) : e(init) {}; 

    VecBase operator-() const
    {
        VecBase v;
        for (size_t i = 0; i < N; i++) v.e[i] = -e[i];
        return v;
    }

    // Scalar Compound Assignment
    VecBase &operator*=(float t)
    {
        for (size_t i = 0; i < N; i++) e[i] *= t;
        return *this;
    }
    VecBase &operator/=(float t)
    {
        return *this *= (1 / t);
    }

    // Compound Assignment
    VecBase& operator+=(const VecBase& v)
    {
        for (size_t i = 0; i < N; i++) e[i] += v.e[i];
        return *this;
    }
    VecBase& operator-=(const VecBase& v)
    {
        for (size_t i = 0; i < N; i++) e[i] -= v.e[i];
        return *this;
    }
    VecBase& operator*=(const VecBase& v)
    {
        for (size_t i = 0; i < N; i++) e[i] *= v.e[i];
        return *this;
    }

    float Dot(const VecBase& v) const
    {
        float sum = 0;
        for (size_t i = 0; i < N; i++) sum += e[i] * v.e[i];
        return sum;
    }

    float Length() const
    {
        return std::sqrt(LengthSquared());
    }
    float LengthSquared() const
    {
        float lq = 0;
        for (size_t i = 0; i < N; i++) lq += e[i] * e[i];
        return lq;
    }

    VecBase Normalized() const
    {
        return *this / this->Length();
    }
};

struct Vec2 : VecBase<2>
{
    Vec2() : VecBase<2>() {};
    Vec2(float x, float y) : VecBase<2>({x, y}) {};
    Vec2(const VecBase<2>& base) : VecBase<2>(base) {};

    float x() const { return e[0]; };
    float y() const { return e[1]; };
};

struct Vec3 : VecBase<3>
{
    Vec3() : VecBase<3>() {};
    Vec3(float x, float y, float z) : VecBase<3>({x, y, z}) {};
    Vec3(const VecBase<3>& base) : VecBase<3>(base) {};

    float x() const { return e[0]; };
    float y() const { return e[1]; };
    float z() const { return e[2]; };

    Vec3 Cross(const Vec3& v) const
    {
        return Vec3(e[1] * v.e[2] - e[2] * v.e[1],
                    e[2] * v.e[0] - e[0] * v.e[2],
                    e[0] * v.e[1] - e[1] * v.e[0]);
    }
};

struct Mat3
{
    std::array<Vec3, 3> e;
    
    Mat3() : e{Vec3{}, Vec3{}, Vec3{}} {};
    Mat3(Vec3 i, Vec3 j, Vec3 k) : e{i, j, k} {};

    // Columns
    Vec3 i() const { return e[0]; };
    Vec3 j() const { return e[1]; };
    Vec3 k() const { return e[2]; };

    Mat3 Transpose() const
    {
        return Mat3(
            Vec3(e[0].x(), e[1].x(), e[2].x()),
            Vec3(e[0].y(), e[1].y(), e[2].y()),
            Vec3(e[0].z(), e[1].z(), e[2].z())
        );   
    }
};

template<size_t N>
VecBase<N> operator+(VecBase<N> u, const VecBase<N>& v)
{
    u += v;
    return u;
}

template<size_t N>
VecBase<N> operator-(VecBase<N> u, const VecBase<N>& v)
{
    u -= v;
    return u;
}

template<size_t N>
VecBase<N> operator*(VecBase<N> u, const VecBase<N>& v)
{
    u *= v;
    return u;
}

template<size_t N>
VecBase<N> operator*(float t, VecBase<N> v)
{
    v *= t;
    return v;
}

template<size_t N>
VecBase<N> operator*(const VecBase<N>& v, float t)
{
    return t * v;
}

template <size_t N>
VecBase<N> operator/(VecBase<N> v, float t)
{
    v /= t;
    return v;
}

inline Vec3 operator*(const Mat3 &M, const Vec3 &v)
{
    return M.e[0] * v.e[0] + M.e[1] * v.e[1] + M.e[2] * v.e[2];
}

#endif