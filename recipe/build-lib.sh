#!/bin/bash
set -ex

# Release tarballs do not contain the required Protobuf definitions.
cp -r $CONDA_PREFIX/share/opentelemetry/opentelemetry-proto/opentelemetry ./third_party/opentelemetry-proto/
# Stop CMake from trying to git clone the Protobuf definitions.
mkdir ./third_party/opentelemetry-proto/.git

mkdir -p build-cpp
cd build-cpp

PROTOC_EXECUTABLE=$PREFIX/bin/protoc
CMAKE_FIND_ROOT_PATH=""
if [[ "$CONDA_BUILD_CROSS_COMPILATION" == 1 ]]; then
    PROTOC_EXECUTABLE=$BUILD_PREFIX/bin/protoc
fi

cmake -GNinja \
    ${CMAKE_ARGS} \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_FLAGS="$CXXFLAGS" \
    -DCMAKE_CXX_STANDARD=17 \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DBUILD_SHARED_LIBS=ON \
    -DBUILD_TESTING=OFF \
    -DOPENTELEMETRY_INSTALL=ON \
    -DWITH_API_ONLY=OFF \
    -DWITH_BENCHMARK=OFF \
    -DWITH_EXAMPLES=OFF \
    -DWITH_LOGS_PREVIEW=ON \
    -DWITH_OTLP=ON \
    -DWITH_OTLP_GRPC=ON \
    -DWITH_OTLP_HTTP=ON \
    -DWITH_PROMETHEUS=ON \
    -DProtobuf_PROTOC_EXECUTABLE=$PROTOC_EXECUTABLE \
    -DWITH_ZIPKIN=ON \
    ..

ninja install
