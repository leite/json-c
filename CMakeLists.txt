cmake_minimum_required(VERSION 2.8)

project(json-c)
set(PROJECT_VERSION 0.10)

set(PACKAGE ${PROJECT_NAME})
set(PACKAGE_BUGREPORT michael@metaparadigm.com) # CACHE STRING "address to send bug reports")
set(PACKAGE_NAME ${PROJECT_NAME}) # CACHE STRING "full package name")
set(PACKAGE_STRING "${PROJECT_NAME} ${PROJECT_VERSION}") # CACHE STRING "full name and version")
set(VERSION ${PROJECT_VERSION}) # CACHE STRING "package version")
set(PACKAGE_VERSION ${PROJECT_VERSION}) # CACHE STRING "package version")
set(PACKAGE_TARNAME ${PROJECT_NAME}) # CACHE STRING "package tar name")

set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/CMakeModules)
add_definitions(-DHAVE_CONFIG_H)

include(BaseConfig)
include_directories(${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR})

include(CheckDefIncludeFiles)
check_def_include_files(dlfcn.h HAVE_DLFCN_H)
check_def_include_files(fcntl.h HAVE_FCNTL_H)
check_def_include_files(inttypes.h HAVE_INTTYPES_H)
check_def_include_files(limits.h HAVE_LIMITS_H)
check_def_include_files(memory.h HAVE_MEMORY_H)
check_def_include_files(strings.h HAVE_STRINGS_H)
check_def_include_files(syslog.h HAVE_SYSLOG_H)
check_def_include_files(unistd.h HAVE_UNISTD_H)
check_def_include_files(stdarg.h HAVE_STDARG_H)
check_def_include_files(sys/param.h HAVE_SYS_PARAM_H)
check_def_include_files(sys/stat.h HAVE_SYS_STAT_H)

# simulate autoconf STDC_HEADERS
check_def_include_files(stdlib.h HAVE_STDLIB_H)
check_def_include_files(string.h HAVE_STRING_H)
check_def_include_files(stdarg.h HAVE_STDARG_H)
check_def_include_files(float.h HAVE_FLOAT_H)
if(HAVE_FLOAT_H  AND
   HAVE_STRING_H AND
   HAVE_STDARG_H AND
   HAVE_STDLIB_H)
    set(STDC_HEADERS 1)
endif()

include(CheckDefFunctionExists)
check_def_function_exists(strndup HAVE_STRNDUP)
check_def_function_exists(strerror HAVE_STRERROR)
check_def_function_exists(vsnprintf HAVE_VSNPRINTF)
check_def_function_exists(vasprintf HAVE_VASPRINTF)
check_def_function_exists(open HAVE_OPEN)
check_def_function_exists(vsyslog HAVE_VSYSLOG)
check_def_function_exists(strncasecmp HAVE_STRNCASECMP)
check_def_function_exists(vprintf HAVE_VPRINTF)
check_def_function_exists(memcmp HAVE_MEMCMP)
check_def_function_exists(malloc HAVE_MALLOC)
check_def_function_exists(realloc HAVE_REALLOC)
check_def_function_exists(doprnt HAVE_DOPRNT)

if(HAVE_MALLOC)
    unset(malloc)
else(HAVE_MALLOC)
    set(malloc rpl_malloc)
endif(HAVE_MALLOC)

if(HAVE_REALLOC)
    unset(realloc)
else(HAVE_REALLOC)
    set(realloc rpl_realloc)
endif(HAVE_REALLOC)

include(CheckCSourceCompiles)
check_c_source_compiles("int main() { const int *foo = 1; }" CONST_KEYWORD)
if(NOT CONST_KEYWORD)
    set(const "")
else()
    unset(const)
endif()

include(CheckTypeSize)
set(CMAKE_EXTRA_INCLUDE_FILES sys/types.h)
check_type_size(size_t HAVE_SIZE_T)
set(CMAKE_EXTRA_INCLUDE_FILES)

if(HAVE_SIZE_T)
    unset(size_t)
else(HAVE_SIZE_T)
    set(size_t unsigned)
endif(HAVE_SIZE_T)

configure_file(config.h.cmake config.h)


# build config

set(JSON_HEADERS arraylist.h bits.h debug.h json.h json_inttypes.h
    json_object.h json_object_private.h json_tokener.h json_util.h linkhash.h
    printbuf.h)
set(JSON_SOURCES arraylist.c debug.c json_object.c json_tokener.c json_util.c
    linkhash.c printbuf.c)

add_library(json ${JSON_SOURCES} ${JSON_HEADERS})
set_target_properties(json PROPERTIES
    VERSION ${PROJECT_VERSION}
    SOVERSION 1.0.1)

add_executable(test1 EXCLUDE_FROM_ALL test1.c)
target_link_libraries(test1 json)

add_executable(test2 EXCLUDE_FROM_ALL test2.c)
target_link_libraries(test2 json)

add_executable(test4 EXCLUDE_FROM_ALL test4.c)
target_link_libraries(test4 json)

add_executable(test_parse_int64 EXCLUDE_FROM_ALL test_parse_int64.c)
target_link_libraries(test_parse_int64 json)

add_executable(test_null EXCLUDE_FROM_ALL test_null.c)
target_link_libraries(test_null json)

add_executable(test_cast EXCLUDE_FROM_ALL test_cast.c)
target_link_libraries(test_cast json)

add_custom_target(check
                   COMMAND test1
                   COMMAND test2
                   COMMAND test4
                   COMMAND test_parse_int64
                   COMMAND test_null
                   COMMAND test_cast
                   DEPENDS test1 test2 test4 test_parse_int64 test_null
                   test_cast)
