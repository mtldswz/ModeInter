#ifndef POINT_HPP
#define POINT_HPP

class POINT
{
public:
     POINT();
    ~POINT();

    void readModeShape();
    void writeModeShape();

    POINT &operator+=(POINT);
private:
    double x;
    double y;
    double z;
};

#endif // POINT_HPP
