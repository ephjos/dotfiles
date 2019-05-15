cmake_minimum_required(VERSION 3.10)

set(FLAGS "-p -g -Wall")

set(EXEC "main")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${FLAGS}")
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${FLAGS}")

project(${EXEC})

set(SOURCES
    src/Machine.cpp
    src/main.cpp
)

add_executable(${EXEC} ${SOURCES})

target_include_directories(${EXEC}
    PRIVATE
        ${PROJECT_SOURCE_DIR}/include
)

install(TARGETS ${EXEC} DESTINATION bin)

