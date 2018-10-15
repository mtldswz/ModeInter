#!/usr/bin/env python
# -*-coding: utf-8-*-

import Point

class CFDMesh(object):

    def __init__(self, filename):

        self.filename = filename
        self.listpoint = []

    def read_input_data(self):

        with open(self.filename, "r") as fp:

            while True:
                line = fp.readline()
        pass


class Plot3dMesh(CFDMesh):

    def __init__(self, filename):
        super(Plot3dMesh, self).__init__(filename)
        self.block_dim = []

    def check(self, line):
        if len(line) != 3:
            return False
        for ic in line:
            try:
                float(ic)
            except:
                return False
        return True

    def add_point(self, x, y, z):
        point = Point.ModeShape(x, y, z)
        self.listpoint.append(point)

    def get_point_list(self):
        with open("wall.dat", "r") as fp:
            while True:
                line = fp.readline()
                if not line:
                    break
                line = line.strip("\n")
                line = line.strip(" ")
                line = line.split()
                if self.check(line):
                    self.add_point(line)

    def getwall(self):
        with open("wallinfo.dat", "r") as fp:
            lastnum = -1
            while True:
                line = fp.readline()
                line = line.strip("\n")
                line = line.strip(" ")

                if not line:
                    break
                line = line.split()
                dim = (int(line[4]) - int(line[3]) + 1) * (int(line[6]) - int(line[5]) + 1)
                if self.block_dim == [] or line[0] != lastnum:
                    self.block_dim.append(dim)
                else:
                    self.block_dim[-1] += dim
                lastnum = line[0]


class FluentMesh(CFDMesh):
    pass


if __name__ == "__main__":
    cfl3dmesh = Plot3dMesh("")
    cfl3dmesh.getwall()
    fd = open("dim.dat", "w")
    print(len(cfl3dmesh.block_dim))
    for i in cfl3dmesh.block_dim:
        print(i, file=fd)
