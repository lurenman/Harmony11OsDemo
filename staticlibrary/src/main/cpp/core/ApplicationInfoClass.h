//
// Created on 2024/6/28.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#ifndef HARMONY11OSDEMO_APPLICATIONINFOCLASS_H
#define HARMONY11OSDEMO_APPLICATIONINFOCLASS_H

#include <bundle/native_interface_bundle.h>
#include <cstdlib>
#include "napi/native_api.h"

class ApplicationInfoClass {
public:
    static napi_value getCurrentApplicationInfo(napi_env env, napi_callback_info info);
};

#endif // HARMONY11OSDEMO_APPLICATIONINFOCLASS_H
