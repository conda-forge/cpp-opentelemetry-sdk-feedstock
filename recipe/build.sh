#!/bin/bash
set -ex

# Release tarballs do not contain the required Protobuf definitions.
cp -r $BUILD_PREFIX/share/opentelemetry/opentelemetry-proto/opentelemetry ./third_party/opentelemetry-proto/
# Stop CMake from trying to git clone the Protobuf definitions.
mkdir ./third_party/opentelemetry-proto/.git

mkdir -p build-cpp
cd build-cpp

PROTOC_EXECUTABLE=$PREFIX/bin/protoc
CMAKE_FIND_ROOT_PATH=""
if [[ "$CONDA_BUILD_CROSS_COMPILATION" == 1 ]]; then
    PROTOC_EXECUTABLE=$BUILD_PREFIX/bin/protoc
fi

if [[ "${target_platform}" == osx-* ]]; then
  # See https://conda-forge.org/docs/maintainer/knowledge_base.html#newer-c-features-with-old-sdk
  CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
  # protobuf switches definitions based on presence of this symbol, for details see
  # https://github.com/protocolbuffers/protobuf/issues/12746#issuecomment-1546736962
  CXXFLAGS="${CXXFLAGS} -DPROTOBUF_USE_DLLS"
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
    -DWITH_ABSEIL=ON \
    -DWITH_API_ONLY=OFF \
    -DWITH_BENCHMARK=OFF \
    -DWITH_EXAMPLES=OFF \
    -DWITH_OTLP_GRPC=ON \
    -DWITH_OTLP_HTTP=ON \
    -DWITH_PROMETHEUS=ON \
    -DWITH_ZIPKIN=ON \
    -DProtobuf_PROTOC_EXECUTABLE=$PROTOC_EXECUTABLE \
    ..

cmake --build .
