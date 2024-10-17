#include <iostream>
#include <vector>

int BranchCoverage()
{
    /*
     * + 表示条件为真有测试用例经过, - 表示条件为假有测试用例经过
     * 比如 if (a>3)  为 [+ -] 表示有测试用例经过 a>3 时为true, 不存在测试用例使得 a>3 为false
     * 比如 if (a> 3 || a<1) [+ - + -]
     * 前面两个+ -表示第一个条件 ( a > 3 ) 为真/为假时是否有测试用例经过
     * 后面两个+ - 表示第二个条件 ( a < 1 ) 为真/为假时是否有测试用例经过
     */
    // 定义全部测试用例, 每个元素表示一个测试用例
    std::vector A = {1, 2, 3, 4, 5, 6 ,7 ,8, 9};
    for(const int i : A) {
        if (i > 6)                  // 存在大于0且小于6的测试用例, [+ +]
            std::cout << i << std::endl;
        if (i > 0)                  // 不存在测试用例经过 i <= 0 的分支 [+ -]
            std::cout << i << std::endl;
        if (i > 2 && i <4)          // 存在测试用例经过: i>2 的分支, i<=2 的分支, i<4 的分支, i>=4 的分支  [+ + + +]
            std::cout << i << std::endl;
        if (i > 3 || i == -1 )      // 存在测试用例经过: i>3 的分支, i<=3 的分支, 不存在测试用例经过i==-1的分支. 存在测试用例经过i!=-1的分支. [+ + - +]
            std::cout << i << std::endl;
        if (i > 7)                  // 存在测试用例经过: i>7 的分支, i <= 7 的分支, [+ +]
            std::cout << i << std::endl;
        else if (i >4)              // 存在测试用例经过: i>4 的分支, i <= 4 的分支, [+ +]
            std::cout << i << std::endl;
        else if (i < -1)            // 不存在测试用例经过: i<-1 的分支, 存在测试用例经过 i >= -1 的分支, [- +]
            std::cout << i << std::endl;
    }
    return 0;
}
