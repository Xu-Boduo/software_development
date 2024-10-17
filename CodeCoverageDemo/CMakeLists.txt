# 指定 CMake 的最低版本要求
cmake_minimum_required(VERSION 3.10)

# 设置项目名称
project(CodeCoverageProject)
# 设置根路径
set(PROJECT_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})
# 启用代码覆盖
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --coverage")

aux_source_directory(${PROJECT_ROOT_PATH}/demo1 DIR_SRCS)

# 添加源文件
aux_source_directory(${PROJECT_ROOT_PATH}/demo1 demo1_SRCS)
aux_source_directory(${PROJECT_ROOT_PATH}/demo2 demo2_SRCS)
aux_source_directory(${PROJECT_ROOT_PATH}/branch_coverage branch_coverage_SRCS)

# 添加可执行文件，指定源文件
add_executable(CodeCoverage main.cpp
    ${demo1_SRCS}
    ${demo2_SRCS}
    ${branch_coverage_SRCS}
)
# 添加头文件搜索路径
target_include_directories(CodeCoverage PUBLIC
    ${PROJECT_ROOT_PATH}/demo1
    ${PROJECT_ROOT_PATH}/demo2
    ${PROJECT_ROOT_PATH}/branch_coverage
)


