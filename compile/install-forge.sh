#!/bin/bash

git clone https://github.com/jeanbez/forwarding-explorer forge
cd forge
mkdir build
cd build
cmake ..
make
