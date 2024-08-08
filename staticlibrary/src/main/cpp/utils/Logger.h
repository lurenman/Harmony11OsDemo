//
// Created on 2024/8/7.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#ifndef HARMONY11OSDEMO_LOGGER_H
#define HARMONY11OSDEMO_LOGGER_H

class Logger {

};

#endif //HARMONY11OSDEMO_LOGGER_H

#include <napi/native_api.h>
#include <hilog/log.h>
#include <stdio.h>
#include <stdlib.h>

#define TAG "TEST_NDK"
/**
 * Parameter count.
 */
const int PARAMETER_COUNT = 2;

/**
 * Log print domain.
 */
const unsigned int LOG_PRINT_DOMAIN = 0xFF00;
 
#define OPEN_LOG
//// 是否开启频繁输出的日志（吵闹的日志）
#define OPEN_NLOG

// 注意：这里的LOGE是一定会输出的，不管环境。所以，请谨慎使用。
#define LOGE(...) OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, TAG, __VA_ARGS__)


#ifdef OPEN_NLOG
#ifdef OPEN_LOG
#define NLOGD(...) OH_LOG_Print(LOG_APP, LOG_DEBUG, LOG_PRINT_DOMAIN, TAG, __VA_ARGS__)
#else
#define NLOGD(...)
#endif
#else
#define NLOGD(...)
#endif


#ifdef OPEN_LOG
#define LOGI(...) OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, TAG, __VA_ARGS__)
#define LOGD(...) OH_LOG_Print(LOG_APP, LOG_DEBUG, LOG_PRINT_DOMAIN, TAG, __VA_ARGS__)
#define LOGW(...) OH_LOG_Print(LOG_APP, LOG_WARN, LOG_PRINT_DOMAIN, TAG, __VA_ARGS__)
#else
#define LOGI(...)
#define LOGD(...)
#define LOGW(...)
#endif