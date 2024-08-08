//
// Created on 2024/8/7.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#ifndef HARMONY11OSDEMO_DEVICEINFOCLASS_H
#define HARMONY11OSDEMO_DEVICEINFOCLASS_H
#include <stdio.h>
#include <sys/utsname.h>
#include <cstddef>
#include <cstring>
#include "utils/Logger.h"
class DeviceInfoClass {
public:
    static void kernelVersion();
};

#endif // HARMONY11OSDEMO_DEVICEINFOCLASS_H
