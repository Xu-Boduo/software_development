#include <iostream>
#include <vector>
#include "branch_coverage.h"
#include "demo1.h"
#include "demo2_1.h"
#include "demo2_2.h"


int main()
{
    std::vector test_case = {0, 1, 2, 3};
    for (int &i : test_case)
    {
       i = i + 1;
    }
    // test_case = {1, 2, 3, 4}
    for (const int &i : test_case)
    {
        if (i < 3)
            std::cout << i << std::endl;
        else if (i > 8)
            std::cout << "no" << i <<  std::endl;
    }

    demo1();
    demo2_1();
    demo2_2();
    BranchCoverage();
    return 0;
}

