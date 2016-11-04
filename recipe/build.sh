#!/bin/bash

export PATH=${PREFIX}/bin:$PATH
export CFLAGS="-I${PREFIX}/include"

export LDFLAGS="-L${PREFIX}/lib"
export CPPFLAGS="-I${PREFIX}/include"

export DYLD_FALLBACK_LIBRARY_PATH="${PREFIX}/lib"
export DYLD_LIBRARY_PATH="${PREFIX}/lib"

if [ `uname -m` == ppc64le ]; then
    B="--build=ppc64le-linux"
fi

./configure $B --enable-threadsafe \
            --enable-tempstore \
            --enable-readline \
            --enable-shared=yes \
            --disable-tcl \
            --prefix=$PREFIX


cp ${RECIPE_DIR}/Makefile.patch ./Makefile.patch

patch < Makefile.patch

make
make check
make install

rm -rf  $PREFIX/share
