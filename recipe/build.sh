#!/bin/bash

if [ `uname -m` == ppc64le ]; then
    B="--build=ppc64le-linux"
fi

#--disable-readline \

./configure $B --enable-threadsafe \
            --enable-tempstore \
            --enable-shared=yes \
            --disable-tcl \
            --prefix=$PREFIX
make
make check
make install

rm -rf  $PREFIX/share
