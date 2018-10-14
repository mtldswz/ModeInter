#ifndef BLOCK_HPP

#define BLOCK_HPP

#include "POINT.hpp"


class BLOCK
{

public:

    /*BLOCK初始化时申请一个二维数组，
    nmode是模态数目，
    size_a是数组长度*/
     BLOCK(int _nmode, int _size_a);
    ~BLOCK();

    void readData ();
    void writeData();
    void DisData(int);

private:

    POINT *xx;
    POINT **xs;

    int nmode;
    int size_a;


};
#endif // BLOCK_HPP
