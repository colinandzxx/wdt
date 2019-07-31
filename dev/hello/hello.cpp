#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <vector>

extern "C" {

char* hello(int oh) {
    int i32 = 0;
    uint32_t u32 = 0;
    i32 = 10;
    u32 = 20;
    float f1 = 0.0;
    float f2 = i32 + u32 + f1 + oh;
    char* str = "hello world";
    char str1[2] = {};
    memcpy(str1, str, strlen(str));
    //printf("hello world!\n");     // not support at current !!

    // std::vector<int> vec1;       // not support at current !!
    // for (int i = 1; i < 10; i ++) {
    //     vec1.push_back(i);
    // }

    return str;
}

}
