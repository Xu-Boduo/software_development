#!/bin/bash
if [ "$#" -ne 1 ];
then
  echo "It should be called through \" bash $0 current_build_file_name \""
  exit 1
fi


file_dirs="./$1/CMakeFiles/CodeCoverage.dir"   # 替换成你的目录
# 获取 CodeCoverage.dir 目录下的源文件的文件夹名 (包含 gcno 文件)
mapfile -t file1_paths < <(ls -d "${file_dirs}"/*/)
# 添加 main.cpp.gcno 文件
mapfile -t file2_paths < <(ls -d "${file_dirs}"/)

# 添加行覆盖, 分支覆盖, 函数覆盖
lcov_command="lcov --rc branch_coverage=1 --filter branch --ignore-errors mismatch,gcov,empty --gcov-tool /usr/local/gcc/bin/gcov -c "
for path in "${file1_paths[@]}" "${file2_paths[@]}";
do
  lcov_command+="-d $path "
done
# 将结果存于 coverage.info
lcov_command+="-o coverage.info"
eval "$lcov_command"

# 当前目录
current_dir=$(pwd)
# 添加需要统计代码覆盖信息的源文件目录
src_paths=(
"demo1"
"demo2"
"branch_coverage"
)

# 提取指定目录的代码覆盖信息
lcov_command="lcov --rc branch_coverage=1 --filter branch --ignore-errors mismatch --gcov-tool /usr/local/gcc/bin/gcov "
for path in "${src_paths[@]}";
do
  lcov_command+="-e coverage.info $current_dir/$path*.cpp "
done
lcov_command+="-e coverage.info main.cpp "
lcov_command+="-o coverage.info"
eval "$lcov_command"

# 生成 html 代码覆盖报告
genhtml --rc branch_coverage=1  coverage.info --output-directory coverage_html