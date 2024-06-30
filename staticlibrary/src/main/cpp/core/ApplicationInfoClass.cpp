//
// Created on 2024/6/28.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#include "ApplicationInfoClass.h"

napi_value ApplicationInfoClass::getCurrentApplicationInfo(napi_env env, napi_callback_info info) {
    // 调用Native接口获取应用信息
    OH_NativeBundle_ApplicationInfo nativeApplicationInfo = OH_NativeBundle_GetCurrentApplicationInfo();
    napi_value result = nullptr;
    napi_create_object(env, &result);
    // Native接口获取的应用包名转为js对象里的bundleName属性
    napi_value bundleName;
    napi_create_string_utf8(env, nativeApplicationInfo.bundleName, NAPI_AUTO_LENGTH, &bundleName);
    napi_set_named_property(env, result, "bundleName", bundleName);
    // Native接口获取的指纹信息转为js对象里的fingerprint属性
    napi_value fingerprint;
    napi_create_string_utf8(env, nativeApplicationInfo.fingerprint, NAPI_AUTO_LENGTH, &fingerprint);
    napi_set_named_property(env, result, "fingerprint", fingerprint);

    char *appId = OH_NativeBundle_GetAppId();
    // Native接口获取的appId转为js对象里的appId属性
    napi_value napi_appId;
    napi_create_string_utf8(env, appId, NAPI_AUTO_LENGTH, &napi_appId);
    napi_set_named_property(env, result, "appId", napi_appId);

    char *appIdentifier = OH_NativeBundle_GetAppIdentifier();
    // Native接口获取的appIdentifier转为js对象里的appIdentifier属性
    napi_value napi_appIdentifier;
    napi_create_string_utf8(env, appIdentifier, NAPI_AUTO_LENGTH, &napi_appIdentifier);
    napi_set_named_property(env, result, "appIdentifier", napi_appIdentifier);
    // 最后为了防止内存泄漏，手动释放
    free(nativeApplicationInfo.bundleName);
    free(nativeApplicationInfo.fingerprint);
    free(appId);
    free(appIdentifier);
    return result;
}
 