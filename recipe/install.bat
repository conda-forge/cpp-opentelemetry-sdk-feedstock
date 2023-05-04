@echo on

cd build-cpp

cmake --install .
if %ERRORLEVEL% neq 0 exit 1
