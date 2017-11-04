#!/bin/bash

export LDFLAGS="-L${PREFIX}/lib $LDFLAGS"
export CPPFLAGS="-I${PREFIX}/include -I$PREFIX/include/readline $CPPFLAGS"
export CFLAGS="-I${PREFIX}/include -I$PREFIX/include/readline $CFLAGS"

if [ $(uname -m) == ppc64le ]; then
    export B="--build=ppc64le-linux"
fi

./configure SQLITE_ENABLE_RTREE=1 \
            $B --enable-threadsafe \
            --enable-json1 \
            --enable-tempstore \
            --enable-shared=yes \
            --enable-readline \
            --disable-tcl \
            --prefix=$PREFIX

make
make check
make install
