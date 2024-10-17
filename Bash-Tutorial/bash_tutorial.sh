#!/bin/bash

# 参考资料 https://linux.cn/article-16120-1.html

# 定义变量语法
# variable_name=value
# 注意：等号两边不能有空格

# 示例
# 不需要指定变量类型, Bash 会根据赋值的内容自动确定其类型
variable_str="Hello, World!"
variable_int=100

# 访问变量, 在变量前添加 $ 符号, 该符号的目的是告诉 Shell 访问变量的值而非变量名本身
# echo 是 Linux 终端命令, 主要将文本, 变量, 和特殊字符输出到标准输出 ( 通常是终端屏幕 )
echo $variable_str
echo $variable_int

# 实际上访问变量时需使用 "" 防止通配符扩展和单词拆分
# 通配符扩展:
#    访问没有双引号的变量时, Shell 会将其中的通配符 ( 如 '*' 和 '?' ) 视为匹配文件名的模式. 例如, 如果变量的值为 .txt, Shell 将扩展为
#    当前目录下所有以 '.txt' 结尾的文件名
variable_str="*.txt"   # 含有通配符 *
echo "$variable_str"   # output: *.txt
echo $variable_str     # output: 当前目录下 .txt 文件组成的列表
# 单词拆分:
#    访问没有双引号的变量时, Shell 会将其拆分为多个参数. Bash 则是通过内部字段分隔符 (IFS) 进行拆分.
#    IFS(Internal Field Separator) 默认空格, 制表符和换行符为分隔符
variable_split="apple banana cherry"
# 使用了双引号, "$variable_split" 仅有一个元素, 即为 apple banana cherry
for elem in "$variable_split";
do
  echo "$elem"
done
# 没使用双引号, Shell 会进行单词拆分, $variable_split 包含三个元素, 分别是 apple, banana, cherry
for elem in $variable_split;
do
  echo "$elem"
done

# <<brief_name your_content brief_name 是一种多行注释的方式
<<COMMENT
echo 用法
       -n	 不在输出后添加换行符.
       -e	 启用转义字符的解释 ( 如 \n, \t ).
       -E	 默认选项, 禁用转义字符的解释.
   --help	 显示帮助信息.
--version	 显示版本信息.
COMMENT
# echo 默认输出换行
echo "this is test1."
echo "this is test2."
# output: this is test1.
#         this is test2.

# 通过 -n 使得输出结果不换行
echo -n "this is test1."
echo -n "this is test2."
# output: this is test1.this is test2.

echo "test. \n test."
# output: test. \n test.
# 启用转义字符解释
echo -e "test. \n test."
# output: test.
#         test.


<<COMMENT
  单引号与双引号的区别
  单引号: 将内容原样输出, 不进行解析.
  双引号: 将内容解析后输出, 通常会解析某些特殊字符.
COMMENT
single_str='test: \\ \" '
double_str="test: \\ \" "  # 通过反斜杠 \ 进行转义, \ 之后跟的字符即为待转义的字符
echo $single_str    # output: test: \\ \" 不解析字符 \
echo $double_str    # output: test: \ "   解析字符 \ , \\ 将转义为 \
# 在不启用 echo 自带的转义字符解释 -e 的情况下, 无法转义特殊符号, 如 \n \t

# 当单引号的内容嵌套到双引号内时, 单引号的内容将被解释
test_str="hello, 'are you sure?\\' \\"
echo $test_str      # output: hello, 'are you sure?\' \

# 当在双引号内引用变量时, 输出的结果: 若引用的变量的内容是单引号的, 不解析
#                               若引用的变量的内容是双引号的, 解析
#                               echo 双引号内其余字符照常解析
echo "$single_str 1234\\"  # output: test: \\ \" 1234\
echo "$double_str 1234\\"  # output: test: \ " 1234\
echo "$test_str 1234\\"    # output: hello, 'are you sure?\' \ 1234 \
# 单引号不解析
echo '$single_str 1234\\'  # output: $single_str 1234\\
echo '$double_str 1234\\'  # output: $double_str 1234\\
echo '$test_str 1234\\'    # output: $test_str 1234\\


<<COMMENT
参数传递
bash 脚本调用的三种形式
1. bash bash_demo.sh                    # 无参调用
2. bash bash_demo.sh 1 10 yes           # 位置参数调用, 参数值按顺序传入
3. bash bash_demo.sh -g 1 -d 10 -s yes  # 选项参数调用, 参数值与选项对应

bash 特殊变量
$0	当前执行的脚本名称(包括路径).
$n	传递给脚本的参数(按位置顺序), 比如第二个参数为 $2, 当参数大于9个时, 之后的参数访问需添加花括号 ${n}, 比如 ${11}.
$#	传递给脚本的参数个数.
$@	所有传递给脚本的参数(作为独立字符串).
$*	所有传递给脚本的参数(作为一个整体字符串).
$?	上一个命令的退出状态（0 表示成功，非零表示失败）。
$$	当前 Shell 的进程 ID。
$!	最近一个后台命令的进程 ID。
$_	上一个命令的最后一个参数。
COMMENT

# 位置参数调用, 假设在终端输入 bash bash_tutorial.sh 1 2 3
echo "current script name: \$0 $0"                        # 当前脚本名称
echo "incoming parameters: \$1 $1 \$2 $2 \$3 $3"          # 访问传入的参数
echo "the number of parameters: \$# $#"                   # 传入的参数数量
echo "all parameters: \$@ $@"                             # 每个参数作为独立字符串
echo "all parameters: \$* $*"                             # 所有参数合在一个字符串中
pwd                                                       # linux 打印当前路径的命令
echo "exit status of the previous command: \$? $?"        # 上一个命令的退出状态
echo "current shell process ID: \$$ $$"                   # 执行当前 bash 脚本的进程ID
sleep 10 &                                                # & 符号的主要作用是将命令放入新的子进程执行, 主脚本会立即执行后续命令
echo "process ID of recent backend commands: \$! $!"      # 返回最近一个后台命令的进程 ID
sleep 1
echo "the last parameter of the previous command: \$_ $_" # 上一个命令的最后一个参数, 比如这里是1

<<COMMENT
选项参数调用
getopts 是一个用于解析命令行选项和参数的内置命令, 语法为 getopts optstring name
  optstring 是一个字符串, 定义脚本可以接收的选项, 如果每个字符后面跟着 ':', 则表示该选项需要一个参数.
            比如 getopts ":a:b:c:" opt   a: b: c: 分别表示脚本可接受三个字符选项 -a -b -c, 参数值将存入特殊变量 OPTARG.
            第一个 ':' 表示如果遇到无效选项或参数时, getopts 会将错误信息存入特殊变量 OPTARG (Option Argument).
       name 用于存储当前解析的选项
通常在循环中处理 getopts
COMMENT

# 假设在终端输入 bash bash_tutorial.sh -a 1 -b 2 -c yes
a=0; b=0; c="zero"            # 变量初始化, 一行定义多个变量, 通过 ';' 分割开

# 定义函数提示正确用法
usage() {
  echo "Usage: bash $0 -a <a_meaning> -b <b_meaning> [-c <c_meaning>]" # '[ ]' 表示参数可选
  exit 1
}

while getopts ":a:b:c:" opt;
do
  case $opt in                # case 类似于C语言中的 switch 语句, opt 存放当前解析的选项.
    a) a=$OPTARG ;;           # 若解析结果为 a , 则将 $OPTARG 的值赋给该脚本的变量 a
    b) b=$OPTARG ;;           # ;; 标记每个条件块的结束
    c) c=$OPTARG ;;
    \?) echo "Invalid option: -$OPTARG"; usage ;;             # 当传入未定义选项时, getopts会返回 ?, \? 为转义字符
    :) echo "Option -$OPTARG requires an argument."; usage ;; # 当需要参数的选项没有传入参数时, 会提示该错误
  esac
done
echo $a $b $c
# 比如 bash bash_tutorial.sh -a 1 -b 2 -c yes -d 1, 将输出: Invalid option: -d"
# bash bash_tutorial.sh -a 1 -b 2 -c, 将输出: Option -c requires an argument.

# 还可以进一步限制参数的必要性, 比如限制选项 a 必须传入
if [ -z "$a" ];  # -z 用于判断字符串是否为空, 若字符串长度为 0, 则返回 true.
then
  echo "Error: Options -a are required."; usage ;
fi
# 如果调用 bash bash_tutorial.sh -b 2 -c yes, 将提示错误: Error: Options -a are required.
# 当参数 a 没有值传入时, 有些 shell 版本会自动为参数 a 赋值, 比如 0.


<<COMMENT
算术运算  (( ... ))
支持的运算符   描述             示例           结果
    +     	加法	        echo $((3 + 2))	    5
    -	      减法	        echo $((5 - 2))	    3
    *	      乘法	        echo $((4 * 5))	    20
    /	     整数除法	    echo $((10 / 3))	  3
    %	    模除（取余数）	  echo $((10 % 3))	  1
    **	    求幂	        echo $((2 ** 3))	  8
注: 算术运算中的变量只能是整数, 在进行 / 运算时会自动向下取整
COMMENT
# 在 bash 中对变量直接相加是不起作用的, bash 只会将其当作字符串赋值
a=1;b=2;b=$a+1   # 建议换行清晰点, 这里为了篇幅不要太长
echo $b          # output: 1+1 此时 b 的值为 1+1 而不是2

# 也可以通过 declare -i 对变量进行声明, 表明该变量为整型变量, 此时便可以直接进行算术运算
declare -i a=1
declare -i b=2
b=$a+1
echo $b  # output: 2

# 更多情况下是通过算术运算符进行运算, 即通过双括号对变量进行算术运算.
# 在 $(( )) 中可直接引用变量, 不需要通过$
a=1;b=2; b=$(( a+1 ))
echo $b  # output: 2

# 可通过 bc 外部工具进行浮点运算
c=1.5
d=4.1
# 语法如下, scale 用来控制小数点后的位数
result=$(echo "scale=2; $c * $d" | bc)
echo $result                            # output: 6.15
echo "enter your explanation: $result"  # output: enter your explanation: 6.15


<<COMMENT
数组
Bash 支持一维数组, 通过 '( )' 定义数组, 元素之间用空格隔开
访问数组元素: ${arry_name[index]}
获取数组长度: ${#array_name[@]} 或 ${#array_name[*]}
my_array 表示数组的名称, [@]/[*] 表示获取数组中的所有元素, # 前缀用于获取数组的长度, 即元素的个数
遍历数组时需使用双引号, 否则 Shell 会对其进行通配符扩展和单词拆分
COMMENT
# 定义数组
my_array=("A" "B" "C" "D")
echo ${my_array[0]}                     # output: A

# 访问数组
echo "Length using @: ${#my_array[@]}"  # output: Length using @: 4
echo "Length using *: ${#my_array[*]}"  # output: Length using *: 4

# 遍历数组
# ${my_array[@]} 会将数组中的每个元素作为单独的参数传给 for 循环, 即 element 为 my_array 中的每个元素
# ${my_array[*]} 会将数组中的所有元素连接成一个单一的字符串, 元素间用空格分隔. 然后将这个字符串作为一个整体传递给 for 循环.
#                即 element 为 A B C D
# 因此, 通常使用 ${my_array[@]} 的方式遍历数组
for element in "${my_array[@]}";
do
  echo $element
done
# 单独输出每个元素
# output: A
#         B
#         C
#         D
for element in "${my_array[*]}";
do
  echo $element
done
# 单独输出每个元素
# output: A B C D

# 遍历多个数组
array_A=("A1" "A2" "A3")
array_B=("B1" "B2" "B3")
array_C=("C1" "C2" "C3")
for element in "${array_A[@]}" "${array_B[@]}" "${array_C[@]}";
do
  echo $element
done

# Bash 数组支持同时存放数字和字符
my_array=(1 2 "C" "D")
for element in "${my_array[@]}";
do
  echo $element
done

# Bash 不支持多维数组, 但可通过一些方法模拟多维数组
# 使用一维数组模拟二维数组
array=(0 1 2 3 4 5 6 7 8)   # 定义一个 3x3 的二维数组
# 获取元素
row=1
col=2
index=$((row * 3 + col))    # 假设每行有 3 列
echo "${array[$index]}"     # output: 5


<<COMMENT
字符串操作
1. 获取字符串长度: ${#string}
2. 连接两个字符串: str3=$str1$str2
3. 字符串截取子串: ${string:$pos:$len}, pos 为起始位置, len 为截取的长度
4. 替换子串: ${string/substr1/substr2} 将 string 中的 substr1 替换为 substr2, 不修改原字符串且仅替换匹配到的第一个
5. 删除子串: ${string/substring} 删除 string 中 substring 子串, 不修改原字符串且仅删除匹配到的第一个
COMMENT

string="test string"
echo "${#string}"         # output: 11
str1="test_str1"
str2="test_str2"
str3=$str1$str2
echo "$str3"              # output: test_str1test_str2
# 通过 {} 提高可读性
str4="${str1}_yes"
echo "$str4"              # output: test_str1_yes
pos=5
len=4
echo "${str4:$pos:$len}"  # output: str1 下标从 0 开始
string="test test hello world"
echo "${string/test/replace}"  # output: replace test hello world
string="text testhello world"
echo "${string/test/replace}"  # output: text replacehello world
string="test test hello world"
echo "${string/test}"          # output:  test hello world
# 通过变量删除
string="test test hello world"
substring="test"
echo "${string/$substring}"    # output:  test hello world


<<COMMENT
条件语句
用法:
if [ condition ];
then
  your code
elif [ condition ];
then
  your code
else
  your code
fi

'[' 后面必须有空格, ']' 前面必须有空格
操作符前后必须有空格

数值比较的测试条件操作符
  条件	             含义
$a -lt $b	  $a < $b  ($a 小于 $b)
$a -gt $b	  $a > $b  ($a 大于 $b)
$a -le $b  	$a <= $b ($a 小于或等于 $b)
$a -ge $b	  $a >= $b ($a 大于或等于 $b)
$a -eq $b	  $a == $b ($a 等于 $b)
$a -ne $b	  $a != $b ($a 不等于 $b)
也可使用算术运算 (( )) 对数值进行比较

字符串比较时的操作符
    条件	            含义
"$a" = "$b"	   $a 等同于 $b
"$a" == "$b"	 $a 等同于 $b
"$a" != "$b"	 $a 不同于 $b
  -z "$a"	     $a 为空

用于检查文件类型：
  条件	     含义
-f $a	  $a 是一个文件
-d $a	  $a 是一个目录
-L $a	  $a 是一个链接
文件/目录需在系统中存在, 否则判断结果为 false
COMMENT

num1=$1
num2=$2
str1=$3
str2=$4
# 假设调用 bash bash_tutorial.sh 1 2 yse yse
if [ $num1 -lt $num2 ];  # output: "num1 < num2"
then
  echo "num1 < num2"
else
  echo "num1 >= num2"
fi
# 使用算术运算
if (( num1 < num2 ));    # output: "num1 < num2"
then
  echo "num1 < num2"
else
  echo "num1 >= num2"
fi
# 字符串比较               # output: "str1 == str2"
if [ $str1 == $str2 ];
then
  echo "str1 == str2"
else
  echo "str1 != str2"
fi

dir="/usr/bin"       # 该目录在系统中存在
if [ -d $dir ];      # output: "/usr/bin is a directory"
then
  echo "$dir is a directory";
fi
dir="/usr/bin/test"  # 该目录不存在
# ! 表示取非
if [ ! -d $dir ];    # output: "/usr/bin/test is not a directory"
then
  echo "$dir is not a directory";
fi


<<COMMENT
循环语句
1. for 循环
for elem in 数组;
do
  echo $elem
done
2. while 循环
num=1
while [ $num -le 10 ]; do
    echo $num
    num=$(( num + 1 ))
done
3. until 循环
num=1
until [ $num -gt 10 ]; do
    echo $num
    num=$(( num + 1 ))
done
COMMENT

# for 循环
my_array=("A" "B" 1 2)
for elem in "${my_array[@]}";  # output: A B 1 2 (分行展示)
do
  echo "$elem"
done
# 可使用 {} 进行扩展
# {1..10} 会自动展开为 1 2 ... 10, 也可对字符进行扩展, 比如 {a..e} 自动生成 a b c d e
for elem in {1..10};           # output: 1 2 3 4 5 6 7 8 9 10 (分行展示)
do
  echo "$elem"
done

# while 循环
num=1
while (( num != 10 ));         # output: 1 2 3 4 5 6 7 8 9 10 (分行展示)
do
    echo $num
    num=$(( num + 1 ))
done

# until 循环
num=1
until (( num == 10 ));         # output: 1 2 3 4 5 6 7 8 9 (分行展示)
do
    echo $num
    num=$(( num + 1 ))
done


<<COMMENT
函数
函数定义：
function_name(){
  commands
}
COMMENT
print_Hello(){
  echo "Hello World"
}
print_Hello # 调用函数
# output: Hello World
param_function(){
  echo "parameter 1: $1"
  echo "parameter 2: $2"
  echo "parameters : $@"
  sum=$(($3+$4))
  echo "sum is $sum"
}
param_function A B 2 3 5
# output: Hello World
#         parameter 1: A
#         parameter 2: B
#         parameters : A B 2 3 5 7
#         sum is 5

# 可以看到, 即使函数内没使用参数也可以传递, 若使用了不存在的参数, 如 $4, 则默认为空 (不是空格)
print_Hello2(){
  echo "parameter is $4"
}
print_Hello2 1 2 3
# output: parameter is