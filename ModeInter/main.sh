#!/bin/bash

dirName=`dirname $0`
cd $dirName
curPath=`pwd`

python main.py

retcode=$?


# -*- coding:utf-8 -*-

import CFDMesh
import InterWorker
import Get3DModeShape

if __name__ == "__main__":
    cfl3dmesh = CFDMesh.Plot3dMesh()
    cfl3dmesh.run()
    rbfworker = InterWorker.MockRBFMethod()
    n_mode = rbfworker.run()
    get3d = Get3DModeShape.Get3DModeShape(n_mode)
    get3d.run()
