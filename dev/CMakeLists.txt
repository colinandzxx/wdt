# will be implictly used for any compilation unit if not overrided by SYSTEM_INCLUDE_FOLDERS parameter
# these directories go as -isystem <dir> to avoid warnings from code of third-party libraries
set(DEFAULT_SYSTEM_INCLUDE_FOLDERS 
    ${CMAKE_SOURCE_DIR}/lib/libc++/upstream/include
    ${CMAKE_SOURCE_DIR}/lib/musl/upstream/include
    ${CMAKE_SOURCE_DIR}/lib/musl/upstream/arch/wasm32
    ${CMAKE_SOURCE_DIR}/lib/musl/upstream/arch/generic
    ${CMAKE_SOURCE_DIR}/lib/musl/upstream/obj/internal
    ${CMAKE_SOURCE_DIR}/lib/musl/upstream/src/internal
    ${CMAKE_SOURCE_DIR}/lib/musl/upstream/obj/include)

set(STANDARD_INCLUDE_FOLDERS ${CMAKE_SOURCE_DIR}/lib)

add_subdirectory(hello)

# install(DIRECTORY libc++ DESTINATION ${CMAKE_INSTALL_FULL_INCLUDEDIR})