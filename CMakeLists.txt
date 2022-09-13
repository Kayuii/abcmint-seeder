cmake_minimum_required (VERSION 3.14)
project (dnsseed)

option (BUILD_DEBUG_MODE "ON for debug or OFF for release"  OFF)

IF(BUILD_DEBUG_MODE)
    SET(CMAKE_BUILD_TYPE Debug CACHE STRING "One of None Debug Release" FORCE)
ELSE()
    SET(CMAKE_BUILD_TYPE Release CACHE STRING "One of None Debug Release" FORCE)
ENDIF()

if(CMAKE_COMPILER_IS_GNUCXX)
    set(CMAKE_CXX_FLAGS "-std=c++11 ${CMAKE_CXX_FLAGS}")
    message(STATUS "optional:-std=c++11")
endif(CMAKE_COMPILER_IS_GNUCXX)

if(CMAKE_COMPILER_IS_GNUCC)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall")
endif()
if(MSVC)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} / W4")
endif()

set(CMAKE_CXX_FLAGS_DEBUG "-O0 -g " )
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG -g0 -static" )

AUX_SOURCE_DIRECTORY(./src SRC_LIST)
ADD_EXECUTABLE(dnsseed ${SRC_LIST})

IF(CMAKE_BUILD_TYPE MATCHES "Release")
    set(Boost_USE_STATIC_LIBS ON)
    set(Boost_USE_STATIC_RUNTIME ON)
    set(THREADS_PREFER_PTHREAD_FLAG ON)
    set(OPENSSL_USE_STATIC_LIBS TRUE)
ENDIF()

find_package(Boost REQUIRED )
FIND_PACKAGE(OpenSSL REQUIRED COMPONENTS SSL Crypto)
FIND_PACKAGE(Threads REQUIRED)

target_link_libraries(dnsseed PRIVATE OpenSSL::Crypto)
target_link_libraries(dnsseed PRIVATE Threads::Threads)
target_link_libraries(dnsseed PRIVATE dl)
# target_include_directories(dnsseed PRIVATE ${THREADS_INCLUDE_DIR})
