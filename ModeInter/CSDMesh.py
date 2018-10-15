# -*-coding: utf-8-*-
import Point


def clear_str(string):
    string = string.strip("\n")
    string = string.strip(" ")
    return string


class CSDMesh(object):

    def __init__(self, filename):

        self.filename = filename
        self.n_mode = 0
        self.n_point = 0
        self.list_point = []
        self.list_modeshape = []
        pass

    def read_input_data(self):

        with open(self.filename, "r") as fp:

            try:

                line = fp.readline()
                line = clear_str(line)
                line = line.split(" ")

                self.n_point = int(line[0])
                self.n_mode = int(line[1])

                for mode in range(self.n_mode):
                    if mode != 0:
                        fp.readline()
                        self.list_modeshape.append([])
                    for index_p in range(self.n_point):
                        line = fp.readline()
                        line = clear_str(line)
                        line = line.split(" ")
                        point = Point.Point(line[0], line[1], line[2])
                        if mode == 0:
                            self.list_point.append(point)
                        else:
                            self.list_modeshape[mode - 1].append(point)
            except:
                print("IO error")

# -*- coding:utf-8 -*-

import Point

class Bolck():
    def __init__(self, n_mode, blockdim):
        self.n_mode = n_mode
        self.blockdim = blockdim
        self.pointlist = []
        self.modeshapelist = []

        for index in range(int(self.n_mode)):
            self.modeshapelist.append([])

    def get_data(self, pointlist):
        self.pointlist.append(pointlist[0])
        for index in range(self.n_mode):
            self.modeshapelist[index].append(pointlist[index + 1])

    def write_data(self, fp):
        print(self.n_mode, self.blockdim)
        for mode in range(self.n_mode):
            for index in range(self.blockdim):
                self.modeshapelist[mode][index].write_data(fp)


class Get3DModeShape():

    def __init__(self, n_mode, filedim="dim.dat", filemodeshape="mode_in.dat"):
        super(Get3DModeShape, self).__init__()
        self.n_mode = n_mode
        self.filedim = filedim
        self.filemodeshape = filemodeshape
        self.dimlist = []
        self.blocklist = []

    def read_data(self):

        with open(self.filedim, "r") as fp:
            while True:
                line = fp.readline()
                if not line:
                    break
                line = line.strip("\n")
                line = line.strip(" ")
                self.dimlist.append(int(line))

        # self.n_block = len(self.dimlist)

        with open(self.filemodeshape, "r") as fp:

            for blockdim in self.dimlist:
                self.blocklist.append(Bolck(self.n_mode, blockdim))

            for block in self.blocklist:
                for blockdim in range(int(block.blockdim)):
                    line = fp.readline()
                    line = line.split()
                    # print(type(line))
                    listlenth = len(line)
                    # print(listlenth)
                    if listlenth % 3 != 0 or listlenth / 3 <= 1:
                        raise Exception("File '%s''s format is wrong" % (self.filemodeshape))
                    else:
                        pointlist = []
                        for index in range(listlenth // 3):
                            pointlist.append(Point.Point(line[3 * index], line[3 * index + 1], line[3 * index + 2]))
                        block.get_data(pointlist)

    def write_data(self):
        with open("aesurf.dat", "w") as fp:
            for block in self.blocklist:
                block.write_data(fp)

    def run(self):
        self.read_data()
        self.write_data()


if __name__ == "__main__":
    nmode = 5
    get3d = Get3DModeShape(nmode)
    get3d.run()
