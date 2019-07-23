# will be implictly used for any compilation unit if not overrided by SYSTEM_INCLUDE_FOLDERS parameter
# these directories go as -isystem <dir> to avoid warnings from code of third-party libraries
set(DEFAULT_SYSTEM_INCLUDE_FOLDERS ${CMAKE_SOURCE_DIR}/lib/libc++/upstream/include ${CMAKE_SOURCE_DIR}/contracts/musl/upstream/include)

set(STANDARD_INCLUDE_FOLDERS ${CMAKE_SOURCE_DIR}/lib)

add_subdirectory(musl)
add_subdirectory(libc++)

# install(DIRECTORY libc++ DESTINATION ${CMAKE_INSTALL_FULL_INCLUDEDIR})