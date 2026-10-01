cmake_minimum_required(VERSION 3.20)
project(stzb_ios_native C)

# ★★★ 第一步：工具链探针。
#   只编一个最小的 dylib，用来验证「macOS runner + iOS SDK + CMake」这条链通不通。
#   通了再往上加：imgui 核心 → imgui_impl_metal → cimgui → ao_overlay。

add_library(toolchain_probe SHARED src/toolchain_probe.c)

# iOS 上 dylib 默认不导出符号，必须显式声明要导出的入口
target_compile_definitions(toolchain_probe PRIVATE STZB_IOS=1)

if(CMAKE_SYSTEM_NAME STREQUAL "iOS")
  # 关键：让所有符号默认可见，否则 dlopen 之后 dlsym 找不到
  target_link_options(toolchain_probe PRIVATE
    "-Wl,-install_name,@rpath/libtoolchain_probe.dylib")
  message(STATUS "iOS build: arch=${CMAKE_OSX_ARCHITECTURES} sysroot=${CMAKE_OSX_SYSROOT}")
endif()
