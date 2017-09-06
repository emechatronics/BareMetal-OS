#!/bin/sh

set -o errexit
set -u

mkdir -p src
mkdir -p bin

if [ ! -e src/BMFS ]; then
  git clone https://github.com/fragomr/BMFS.git src/BMFS
else
  git --git-dir=src/BMFS/.git pull origin master
fi

if [ ! -e src/Pure64 ]; then
  git clone https://github.com/fragomr/Pure64.git src/Pure64
else
  git --git-dir=src/Pure64/.git pull origin master
fi

if [ ! -e src/BareMetal-kernel ]; then
  git clone https://github.com/fragomr/BareMetal-kernel.git src/BareMetal-kernel
else
  git --git-dir=src/BareMetal-kernel/.git pull origin master
fi

make -C src/BMFS NO_FUSE=1 NO_UTIX_UTILS=1

if [ src/BMFS/src/bmfs ]; then
  cp src/BMFS/src/bmfs bin/bmfs 
fi

bin/bmfs bin/bmfs.image initialize 128M

./build.sh
./format.sh
./install.sh
