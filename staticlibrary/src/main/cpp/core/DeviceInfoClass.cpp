//
// Created on 2024/8/7.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#include "DeviceInfoClass.h"
#ifndef NELEM
#define NELEM(x) ((int)(sizeof(x) / sizeof((x)[0])))
#endif

void DeviceInfoClass::kernelVersion() {
    char kernelVer[256] = {0};
    size_t max_len = sizeof(kernelVer);
    struct utsname uts;

    if (uname(&uts) == -1) {
        return;
    }
    //    sysname = Linux
    //    nodename = localhost
    //    release = 4.4.302-lineage-g5e6be5cee15e
    //    version = #1 SMP PREEMPT Tue Jul 19 04:34:21 UTC 2022
    //    machine = aarch64
    //    domainname = localdomain

    // proc/version
    // Linux version 4.4.302-lineage-g5e6be5cee15e (root@043de4bc645e) (Android (7485623, based on r416183b1) clang
    // version 12.0.7 (https://android.googlesource.com/toolchain/llvm-project
    // c935d99d7cf2016289302412d708641d52d2f7ee)) #1 SMP PREEMPT Tue Jul 19 04:34:21 UTC 2022

    const char *items[] = {uts.sysname, uts.release, uts.machine, uts.nodename, uts.domainname, uts.version};

    size_t available = max_len;
    size_t len = (sizeof(items) / sizeof((items)[0]));
    for (size_t i = 0; i < len; i++) {
        const char *item = items[i];
        size_t item_len = strnlen(item, 128);
        if (available > (item_len + 1)) {
            strcat(kernelVer, item);
            strcat(kernelVer, " ");
            available -= (item_len + 1);
        }
    }
    LOGD("kernelVersion: %{public}s", kernelVer);
}
int DeviceInfoClass::list_threads(char *result, size_t max_len) {
    const int max_count = 30;
    char task_path[128] = {0};
    pid_t pid = getpid();
    snprintf(task_path, 128, "/proc/%d/task", pid);
    DIR *task_dir;
    if ((task_dir = opendir(task_path)) == NULL) {
        return -1;
    }

    struct dirent *de;
    size_t remaining = max_len;
    int count = 0;
    while ((de = readdir(task_dir)) != NULL) {
        if (isdigit(de->d_name[0])) {
            int tid = atoi(de->d_name);
            if (tid == pid) {
                LOGW("list thread: %d", pid);
                continue;
            }
            if (++count > max_count) {
                break;
            }
            char stat_path[256] = {0};
            snprintf(stat_path, 256, "%s/%d/%s", task_path, tid, "stat");
            FILE *fp = fopen(stat_path, "r");
            char buf[256] = {0};
            if (fp) {
                fgets(buf, 256, fp);
                char *t_name = NULL;
                for (size_t i = 0; i < strnlen(buf, 256); i++) {
                    if (buf[i] == '(') {
                        t_name = &buf[i + 1];
                    }

                    if (buf[i] == ')') {
                        buf[i] = '\0';
                        break;
                    }
                }
                if (t_name == NULL) {
                    continue;
                }
                LOGD("list thread: %s", t_name);
                size_t t_name_len = strnlen(t_name, max_len);
                if (remaining > (t_name_len + 1)) {
                    strcat(result, t_name);
                    strcat(result, ",");
                    remaining -= (t_name_len + 1);
                }
                fclose(fp);
            }
        }
    }
    size_t real_size = strlen(result);
    if (real_size > 0) {
        result[real_size - 1] = '\0';
    }

    if (task_dir) {
        closedir(task_dir);
    }
    return 0;
}