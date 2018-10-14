#include "POINT.hpp"

#include <cstdio>

POINT::POINT()
{

}

POINT::~POINT()
{

}

void POINT::readModeShape()
{
    scanf("%lf%lf%lf", &x, &y, &z);
}

void POINT::writeModeShape()
{
    printf("%14.6E %14.6E %14.6E\n", x, y, z);
}

POINT &POINT::operator+=(POINT p)
{
    x += p.x;
    y += p.y;
    z += p.z;
    return *this;
}
