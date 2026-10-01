cmake_minimum_required(VERSION 3.20)

# OBJCXX 必须开启：imgui_impl_metal.mm 是 Objective-C++，
# 不开的话 CMake 不知道怎么编 .mm。
project(stzb_ios_native C CXX OBJCXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CIMGUI_DIR ${CMAKE_CURRENT_SOURCE_DIR}/cimgui)
set(IMGUI_DIR  ${CIMGUI_DIR}/imgui)

if(NOT EXISTS ${IMGUI_DIR}/imgui.cpp)
  message(FATAL_ERROR "imgui sources missing at ${IMGUI_DIR}")
endif()

# ------------------------------------------------------------------
# cimgui —— ImGui.NET 在运行期要绑的就是这个库的导出符号。
#
# 和安卓的差别只有一处：后端从 imgui_impl_opengl3.cpp 换成
# imgui_impl_metal.mm（iOS 是 Metal，不是 GLES3）。
# ------------------------------------------------------------------
add_library(cimgui SHARED
    ${CIMGUI_DIR}/cimgui.cpp
    ${IMGUI_DIR}/imgui.cpp
    ${IMGUI_DIR}/imgui_draw.cpp
    ${IMGUI_DIR}/imgui_tables.cpp
    ${IMGUI_DIR}/imgui_widgets.cpp
    ${IMGUI_DIR}/backends/imgui_impl_metal.mm
)

target_include_directories(cimgui PUBLIC
    ${CIMGUI_DIR}
    ${IMGUI_DIR}
    ${IMGUI_DIR}/backends
)

if(CMAKE_SYSTEM_NAME STREQUAL "iOS")
  target_link_libraries(cimgui PRIVATE
      "-framework Metal"
      "-framework MetalKit"
      "-framework QuartzCore"
      "-framework Foundation"
      "-framework UIKit"
  )
  target_link_options(cimgui PRIVATE "-Wl,-install_name,@rpath/libcimgui.dylib")
  message(STATUS "iOS cimgui: arch=${CMAKE_OSX_ARCHITECTURES} sysroot=${CMAKE_OSX_SYSROOT}")
endif()

# ------------------------------------------------------------------
# 工具链探针（保留）：一个最小 dylib，用来快速判断基础链路是否还通。
# ------------------------------------------------------------------
add_library(toolchain_probe SHARED src/toolchain_probe.c)
