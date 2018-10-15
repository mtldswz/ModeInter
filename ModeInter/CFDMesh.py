#
# -*-coding: utf-8-*-

import Point
import CSDMesh


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

        res = []

        with open("wall.dat", "r") as fp:

            last = False

            while True:
                line = fp.readline()

                # print(line)

                if not line:
                    break

                # os.system("pause")

                line = line.strip("\n")
                line = line.strip(" ")

                line = line.split(" ")

                # print(line)

                flag = self.check(line)

                if flag:
                    # print("yes")
                    self.add_point(line)
                    if not last:
                        res.append(1)
                    else:
                        # print(len(res))
                        res[-1] += 1
                last = flag

        return res

    def getwall(self):

        res = []
        lastnum = -1
        with open("wallinfo.dat", "r") as fp:

            while True:

                line = fp.readline()

                line = line.strip("\n")
                line = line.strip(" ")

                line = line.split()

                print(line)

                if not line:
                    break
                if res == [] or  line[0] != lastnum:
                    res.append(1)
                else:
                    res[-1] += 1

                lastnum = line[0]


        print(len(res))

        return res

    def read_input_data(self):

        listb = self.get_point_list()
        list = self.getwall()

        st = 0
        for i in list:
            tmp = sum(listb[st:st + int(i)])
            self.block_dim.append(tmp)
            st += int(i)


class FluentMesh(CFDMesh):

    pass



if __name__ == "__main__":
    cfl3dmesh = Plot3dMesh("")
    cfl3dmesh.getwall()
123
