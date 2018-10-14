#include "BLOCK.hpp"

#include <iostream>
#include <cstdio>
#include <cstdlib>

using namespace std;

BLOCK::BLOCK(int _nmode, int _size_a):nmode (_nmode),size_a(_size_a)
{
    xx = (POINT*)malloc(sizeof(POINT) * size_a);

    xs = (POINT**) malloc(sizeof(POINT*) * nmode);

    for (int i = 0; i < nmode; i++)
    {
        xs[i] = (POINT*) malloc(sizeof(POINT) * size_a);
    }
}

BLOCK::~BLOCK()
{
    free(xx);

    for (int i = 0; i < nmode; i++)
    {
        free(xs[i]);
    }

    free(xs);
}

void BLOCK::readData()
{
    //double a, b, c;

    for (int j = 0; j < size_a; j++)
    {
        xx[j].readModeShape();

        for (int i = 0; i < nmode; i++)
        {
            xs[i][j].readModeShape();
        }
    }
}

void BLOCK::writeData()
{
    for (int i = 0; i < nmode; i++)
    {
        for (int j = 0; j < size_a; j++)
        {
            xs[i][j].writeModeShape();
        }
    }
}

void BLOCK::DisData(int mode_i)
{
    for (int j = 0; j < size_a; j++)
    {
        xx[j] += xs[mode_i][j];
    }

    for (int j = 0; j < size_a; j++)
    {
        xx[j].writeModeShape();
    }
}
