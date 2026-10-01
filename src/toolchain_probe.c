// 工具链探针：证明这套编译链能产出 iOS arm64 dylib，并且符号可导出。
// 它不做任何事，只提供一个能被 dlsym 找到的入口。

#include <stddef.h>

#if defined(_WIN32)
#  define EXPORT __declspec(dllexport)
#else
#  define EXPORT __attribute__((visibility("default")))
#endif

EXPORT int StzbToolchainProbe(void) {
    return 20261001;
}

EXPORT const char* StzbToolchainProbeInfo(void) {
#if defined(__aarch64__)
    return "ios-arm64 / aarch64";
#elif defined(__arm__)
    return "ios-armv7";
#else
    return "other-arch";
#endif
}
