#ifndef VEC2
#define VEC2

#include <cmath>

struct Vec2
{
    float x, y;
    Vec2 operator-(const Vec2& o) const { return {x - o.x, y - o.y}; };
    float dot(const Vec2& o) const { return x * o.x + y * o.y; };
    float length() const { return std::sqrt(x*x + y*y); };
};



#endif