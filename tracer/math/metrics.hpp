#ifndef METRICS
#define METRICS

#define PI 3.14159265358979323846f

#include "vec.hpp"

class Metrics
{
    public:
    template <size_t N>
    static float Angle(const VecBase<N>& start, const VecBase<N>& mid, const VecBase<N>& end);
};

template <size_t N>
float Metrics::Angle(const VecBase<N>& start, const VecBase<N>& mid, const VecBase<N>& end)
{
    VecBase<N> v1 = start - mid;
    VecBase<N> v2 = end - mid;

    float angle = std::acos(v1.Dot(v2) / (v1.Length() * v2.Length()));
    return angle * 180.0f / PI;
}

#endif