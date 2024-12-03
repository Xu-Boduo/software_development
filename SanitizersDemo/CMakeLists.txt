cmake_minimum_required(VERSION 3.20)
project(Sanitizers_Project)
set(PROJECT_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -fsanitize=address -fno-omit-frame-pointer -fsanitize-recover=address ")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fsanitize-address-use-after-scope")

add_executable(Sanitizers_Demo asan.cpp)