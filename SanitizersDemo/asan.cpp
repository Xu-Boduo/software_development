#include <cstdio>
#include <cstdlib>
#include <cstring>

namespace AddressSanitizer
{
// 需设置 C_FLAGS 为 -fsanitize=address

/**
 * @brief 堆和栈的区别
 * 栈(Stack):
 *    ·由操作系统自动分配和释放内存
 *    ·用于存放函数的局部变量、参数和返回地址
 *    ·内存分配遵循后进先出(LIFO)原则
 * 堆(Heap):
 *    ·由程序员手动分配和释放内存, 使用 'malloc'、'calloc'、'free‘、等函数
 *    ·用于动态分配内存，适合需要在运行时确定内存大小的情况
 */

// 堆内存中的数据写入超出分配的大小, 导致覆盖相邻内存.
void HeapBufferOverflow()
{
    const int heap_size = 10;
    auto *heap = static_cast<char*>(malloc(heap_size));
    strcpy(heap, "heap buffer overflow example");  // 写入超过分配内存大小的数据, 发生堆溢出
    free(heap);
}

// 栈内存中的数据超出栈的最大容量, 导致程序崩溃.
void StackBufferOverflow(const int count)
{
    StackBufferOverflow(count + 1);
}

// 程序尝试使用已释放的内存
void UseAfterFree()
{
    const auto ptr = static_cast<int*>(malloc(sizeof(int)));
    *ptr = 42;
    printf("Value before free: %d\n", *ptr);  // 访问 ptr 指向的内存
    free(ptr); // 释放内存
    printf("Value after free: %d\n", *ptr);   // 使用已经释放的内存
}

// 尝试访问超出作用域的变量
void UseAfterScope()
{
    // 需设置 C_FLAGS 为 -fsanitize=address -fsanitize-address-use-after-scope
    int *p;
    {
        int x = 0;
        p = &x;
    }
    *p = 5;
    printf("%d\n", *p);
}

int* returnFun()
{
    int x = 10;
    return &x;
}

// 函数返回后仍试图访问函数内部定义的局部变量
void UseAfterReturn()
{
    // 需设置 ASAN_OPTIONS detect_stack_use_after_return=1
    // 官网这个错误大概就是这种形式, 然而运行结果的报错并非 UseAfterReturn
    int *ptr = returnFun();
    printf("%d\n", *ptr);
}


// 重复释放
void DoubleFree()
{
    const auto p = static_cast<int*>(malloc(sizeof(int)));
    *p = 2;
    free(p);
    free(p);
}
}

int global_buffer[5];

namespace LeakSanitizer
{
// LeakSanitizer 可单独使用也可以和 AddressSanitizer 一起使用
// 单独使用 LeakSanitizer 时需将 C_FLAGS 设置为 -fsanitize=leak (不使用 -fsanitize=address)
// 若要在 AddressSanitizer 中使用 LeakSanitizer, 则设置 ASAN_OPTIONS detect_leaks=1
void MemoryLeak()
{
    int *x = static_cast<int*>(malloc(sizeof(int)));
}
}

void AsanFailureExample()
{
    char buffer[] = "Hello";
    printf("%c\n", buffer[4]);
    printf("%c\n", buffer[10]);  // 栈溢出
    printf("%c\n", buffer[42]);  // 栈溢出
}

void AsanFailureExample2()
{
    int arrA[5] = {1, 2, 3, 4, 5};
    int arrB[5] = {1, 2, 3, 4, 5};

    // 打印数组起始地址
    printf("Array A address: %p\n", (void*)arrA);

    // 打印每个元素的地址
    for (int i = 0; i < 5; ++i) {
        printf("Array A address of arr[%d]: %p\n", i, (void*)&arrA[i]);
    }
    printf("The [%d]-th element of array A: %d\n", 5, arrA[5]);
    printf("The value of the [%d]-th element in array A is %d, and the address is %p\n", 16, arrA[16], (void*)&arrA[16]);
    printf("The value of the [%d]-th element in array A is %d, and the address is %p\n", 17, arrA[17], (void*)&arrA[17]);
    printf("The value of the [%d]-th element in array A is %d, and the address is %p\n", 18, arrA[18], (void*)&arrA[18]);

    // 打印数组的起始地址
    printf("Array B address: %p\n", (void*)arrB);
    for (int i = 0; i < 5; ++i) {
        printf("Array B address of arr[%d]: %p\n", i, (void*)&arrB[i]);
    }
}

/**
 * @brief 程序入口
 * @param argc Argument Count  传入的参数数量, 包括程序名称
 * @param argv Argument Vector 存储所有参数的指针
 * 传入参数形式为: ./Sanitizers_Demo arg1 arg2 arg3 ...
 * 每个 arg 均为字符串 (即多个字符组成的数组), 需要 *argv 进行指引
 * 所有的 arg1 arg2 arg3 .. 组成一个新的数组, 需要 **argv 进行指引
 * @return 0
 */
int main(const int argc, const char *argv) {

    // heap buffer overflow
    // AddressSanitizer::HeapBufferOverflow();

    // stack buffer overflow
    // AddressSanitizer::StackBufferOverflow(0);  // 程序会奔溃

    // global buffer overflow
    // global_buffer[6] = 50;

    // use after free
    // AddressSanitizer::UseAfterFree();

    // use after scope
    // AddressSanitizer::UseAfterScope();

    // use after return
    // AddressSanitizer::UseAfterReturn();

    // double free
    // AddressSanitizer::DoubleFree();

    // memory leak
    // LeakSanitizer::MemoryLeak();

    // asan failure example
    // AsanFailureExample();
    AsanFailureExample2();
    return 0;
}
