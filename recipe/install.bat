@echo on

cd build-cpp

cmake --install .
if %ERRORLEVEL% neq 0 exit 1

:: for libopentelemetry-cpp-headers, only package the headers
:: (i.e. remove everything else that's been installed into PREFIX)
if [%PKG_NAME%] == [libopentelemetry-cpp-headers] (
    del %LIBRARY_BIN%\opentelemetry*
    del %LIBRARY_LIB%\opentelemetry*
    rmdir /s /q %LIBRARY_LIB%\cmake\opentelemetry-cpp
)
