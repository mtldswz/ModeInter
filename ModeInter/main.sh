#!/bin/bash

dirName=`dirname $0`
cd $dirName
curPath=`pwd`

python main.py

retcode=$?


# -*- coding:utf-8 -*-

import CFDMesh
import InterWorkr
import Get3DModeShape
import Point

if __name__ == "__main__":
    cfl3dmesh = CFDMesh.Plot3DMesh()
    cfl3dmesh.run()
    rbfworker = InterWorkr.MockRBFMethod()
    n_mode = rbfworker.run()
    get3d = Get3DModeShape(n_mode)
    get3d.run()
