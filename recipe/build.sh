#!/bin/bash

export CPPFLAGS="$CPPFLAGS -I$PREFIX/include/readline"
export CFLAGS="$CFLAGS -I$PREFIX/include/readline"

if [ $(uname -m) == ppc64le ]; then
    export B="--build=ppc64le-linux"
fi

./configure SQLITE_ENABLE_RTREE=1 \
            $B --enable-threadsafe \
            --enable-json1 \
            --enable-tempstore \
            --enable-shared=yes \
            --enable-readline \
            --disable-editline \
            --disable-tcl \
            --prefix="${PREFIX}"

make
make check
make install
