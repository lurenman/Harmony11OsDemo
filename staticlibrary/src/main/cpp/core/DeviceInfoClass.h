//
// Created on 2024/8/7.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#ifndef HARMONY11OSDEMO_DEVICEINFOCLASS_H
#define HARMONY11OSDEMO_DEVICEINFOCLASS_H
#include "utils/Logger.h"
#include <cstddef>
#include <cstring>
#include <stdio.h>
#include <unistd.h>
#include <sys/utsname.h>
#include <dirent.h>
#include <ctype.h>
class DeviceInfoClass {
public:
    static void kernelVersion();
    static int list_threads(char *result,size_t max_len);
};

#endif // HARMONY11OSDEMO_DEVICEINFOCLASS_H
