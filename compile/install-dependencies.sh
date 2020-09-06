#!/bin/bash

sudo apt install -y \
	libconfig-dev \
	libgsl-dev \
	libgsl-dev

git clone https://github.com/jeanbez/forwarding-explorer-agios agios

cd agios
make library
make library_install
