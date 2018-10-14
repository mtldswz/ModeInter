# -*-coding: utf-8-*-

import CSDMesh
import CFDMesh


class InterWork(object):
    def __init__(self, csdmesh, cfdmesh):
        self.csdmesh = csdmesh
        self.cfdmesh = cfdmesh
        self.list_modeshape = []

    def run(self):

        for point in self.cfdmesh.listpoint:
            modeshape = self._run_one_point(point)
            self.list_modeshape.append(modeshape)

    def _run_one_point(self, point):

        list_modeshape = []

        for imode in range(self.csdmesh.n_mode):
            self.list_modeshape.append()

        return list_modeshape

    def output_inter_res(self):
        pass