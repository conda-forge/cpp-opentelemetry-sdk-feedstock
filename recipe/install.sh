#!/bin/bash
set -ex

cd build-cpp

cmake --install .

# for libopentelemetry-cpp-headers, only package the headers
# (i.e. remove everything else that's been installed into PREFIX)
if [[ "$PKG_NAME" == "libopentelemetry-cpp-headers" ]]; then
    rm $PREFIX/lib/libopentelemetry*
    rm -rf $PREFIX/lib/cmake/opentelemetry-cpp
fi
