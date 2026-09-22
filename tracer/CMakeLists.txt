cmake_minimum_required(VERSION 3.10)
project(Tracer)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

if(ANDROID)
    set(OpenCV_DIR "S:/Repertoire/_Global/SDK/opencv-android/sdk/native/jni" CACHE PATH "Path to OpenCV Android build")
    set(ONNXRUNTIME_DIR "S:/Repertoire/_Global/SDK/onnxruntime-android" CACHE PATH "Path to ONNX Runtime Android build")
    set(ONNXRUNTIME_LIB_DIR "${ONNXRUNTIME_DIR}/jni/${ANDROID_ABI}")
    set(ONNXRUNTIME_INCLUDE_DIR "${ONNXRUNTIME_DIR}/headers")

    add_library(onnxruntime SHARED IMPORTED)
    set_target_properties(onnxruntime PROPERTIES
        IMPORTED_LOCATION "${ONNXRUNTIME_LIB_DIR}/libonnxruntime.so"
    )
else()
    set(OpenCV_DIR "S:/Repertoire/_Global/SDK/opencv/build" CACHE PATH "Path to OpenCV Windows build")
    set(ONNXRUNTIME_DIR "S:/Repertoire/_Global/SDK/onnxruntime" CACHE PATH "Path to ONNX Runtime Windows build")
    set(ONNXRUNTIME_LIB_DIR "${ONNXRUNTIME_DIR}/lib")
    set(ONNXRUNTIME_INCLUDE_DIR "${ONNXRUNTIME_DIR}/include")

    add_library(onnxruntime SHARED IMPORTED)
    set_target_properties(onnxruntime PROPERTIES
        IMPORTED_IMPLIB "${ONNXRUNTIME_LIB_DIR}/onnxruntime.lib"
        IMPORTED_LOCATION "${ONNXRUNTIME_LIB_DIR}/onnxruntime.dll"
    )
endif()
find_package(OpenCV REQUIRED)

set(TRACER_SOURCES
    api/tracer_api.cpp
    detection/detection.cpp
    detection/detector.cpp
    extraction/rig.cpp
    extraction/extractor.cpp
    extraction/preprocess.cpp
    math/metrics.cpp
    tracer.cpp
)

if (NOT ANDROID)
    add_executable(Tracer main.cpp ${TRACER_SOURCES})
endif()

add_library(TracerLib SHARED ${TRACER_SOURCES})
set_target_properties(TracerLib PROPERTIES OUTPUT_NAME "tracer")

foreach(target Tracer TracerLib)
    if (TARGET ${target})
        target_include_directories(${target} PUBLIC
            ${CMAKE_CURRENT_SOURCE_DIR}
            ${CMAKE_CURRENT_SOURCE_DIR}/api
            ${CMAKE_CURRENT_SOURCE_DIR}/math
            ${CMAKE_CURRENT_SOURCE_DIR}/detection
            ${CMAKE_CURRENT_SOURCE_DIR}/extraction
        )
    endif()
endforeach()

set(TARGETS TracerLib)
if(NOT ANDROID)
    list(APPEND TARGETS Tracer)
endif()

foreach(target ${TARGETS})
    target_include_directories(${target} PRIVATE ${ONNXRUNTIME_INCLUDE_DIR} ${OpenCV_INCLUDE_DIRS})
    # target_link_directories(${target} PRIVATE ${ONNXRUNTIME_LIB_DIR})
    target_link_libraries(${target} PRIVATE onnxruntime ${OpenCV_LIBS})

    if (NOT ANDROID)
        add_custom_command(TARGET Tracer POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${ONNXRUNTIME_DIR}/lib/onnxruntime.dll"
            "$<TARGET_FILE_DIR:Tracer>"
        )

        add_custom_command(TARGET Tracer POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "S:/Repertoire/_Global/SDK/opencv/build/x64/vc16/bin/opencv_world500d.dll"
            "$<TARGET_FILE_DIR:Tracer>"
        )
    endif()
endforeach()