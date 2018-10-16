#!/usr/bin/env python
# -*-coding: utf-8-*-


class Point(object):
    def __init__(self, x, y, z):
        super(Point, self).__init__()
        self.x = x
        self.y = y
        self.z = z

    def write_data(self, fp=None):
        self.x = float(self.x)
        self.y = float(self.y)
        self.z = float(self.z)
        print("%15.7E %15.7E %15.7E" % (self.x, self.y, self.z), file=fp)


class ModeShape(Point):

    def __init__(self, x, y, z):
        super(ModeShape, self).__init__(x, y, z)


if __name__ == "__main__":
    point = Point(1.0, 2.0, 3.0)
    point.write_data()
