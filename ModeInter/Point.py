# -*-coding: utf-8-*-

class Point(object):

    def __init__(self, x, y, z):

        self.x = x
        self.y = y
        self.z = z


class ModeShape(Point):

    def __init__(self, x, y, z):
        super(ModeShape, self).__init__(x, y, z)