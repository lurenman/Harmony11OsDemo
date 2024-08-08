# the minimum version of CMake.
cmake_minimum_required(VERSION 3.4.1)
project(myNpmLib)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()
FILE(GLOB SRC_LIST_CPP ${PROJECT_SOURCE_DIR}  "*.cpp" "*/*.cpp")
FILE(GLOB SRC_LIST_C ${PROJECT_SOURCE_DIR} "*.c" "*/*.c")
include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)


find_library(
    # Sets the name of the path variable.
    hilog-lib
    # Specifies the name of the NDK library that
    # you want CMake to locate.
    hilog_ndk.z
)
add_library(staticlibrary SHARED ${SRC_LIST_CPP} ${SRC_LIST_C})
target_link_libraries(staticlibrary PUBLIC  libace_napi.z.so PUBLIC ${hilog-lib} libbundle_ndk.z.so)
