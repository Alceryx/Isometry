cmake_minimum_required(VERSION 3.10)
project(Tracer)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

set(OpenCV_DIR "S:/Repertoire/_Global/SDK/opencv/build/" CACHE PATH "Path to OpenCV build")
set(ONNXRUNTIME_DIR "S:/Repertoire/_Global/SDK/onnxruntime" CACHE PATH "Path to ONNX Runtime SDK")
find_package(OpenCV REQUIRED)

add_executable(Tracer main.cpp detection.cpp tracer_api.cpp)
add_library(TracerLib SHARED detection.cpp tracer_api.cpp)
set_target_properties(TracerLib PROPERTIES OUTPUT_NAME "tracer")

foreach(target Tracer TracerLib)
    target_include_directories(${target} PRIVATE ${ONNXRUNTIME_DIR}/include ${OpenCV_INCLUDE_DIRS})
    target_link_directories(${target} PRIVATE ${ONNXRUNTIME_DIR}/lib)
    target_link_libraries(${target} PRIVATE onnxruntime ${OpenCV_LIBS})

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
endforeach()
