#!/bin/bash

# Prevent running ldconfig when cross-compiling.
if [[ "${BUILD}" != "${HOST}" ]]; then
  echo "#!/usr/bin/env bash" > ldconfig
  chmod +x ldconfig
  export PATH=${PWD}:$PATH
fi

export CPPFLAGS="${CPPFLAGS} -DSQLITE_ENABLE_COLUMN_METADATA=1 \
                             -DSQLITE_ENABLE_UNLOCK_NOTIFY \
                             -DSQLITE_ENABLE_DBSTAT_VTAB=1 \
                             -DSQLITE_ENABLE_FTS3_TOKENIZER=1 \
                             -DSQLITE_SECURE_DELETE \
                             -DSQLITE_MAX_VARIABLE_NUMBER=250000 \
                             -DSQLITE_MAX_EXPR_DEPTH=10000 \
                             -DSQLITE_ENABLE_GEOPOLY \
                             -DSQLITE_ENABLE_FTS5 \
                             -DSQLITE_ENABLE_RTREE=1"

if [[ $target_platform =~ linux.* ]]; then
    export CFLAGS="${CFLAGS} -DHAVE_PREAD64 -DHAVE_PWRITE64"
fi

./configure --prefix=${PREFIX} \
            --build=${BUILD} \
            --host=${HOST} \
            --enable-threadsafe \
            --enable-readline \
            --disable-editline \
            --disable-static \
            CFLAGS="${CFLAGS} -I${PREFIX}/include" \
            LDFLAGS="${LDFLAGS} -L${PREFIX}/lib"

make -j${CPU_COUNT} ${VERBOSE_AT}
make install

# We can remove this when we start using the new conda-build.
find $PREFIX -name '*.la' -delete
