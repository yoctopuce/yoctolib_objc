#!/bin/bash
echo "Build Objective Examples"
echo "=================="
for d in Examples/*
do
echo "Build "$d
cd $d
make $1 || exit 1
cd ../../
done
echo -e "All examples successfully built"