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

