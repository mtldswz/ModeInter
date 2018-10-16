#!/bin/bash

dirName=`dirname $0`
cd $dirName
curPath=`pwd`

python main.py

retcode=$?
