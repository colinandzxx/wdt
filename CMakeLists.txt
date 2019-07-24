cmake_minimum_required( VERSION 3.5 )
project( wdt )

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/CMakeModules")

include( GNUInstallDirs )
include( VersionMacros )
include( SetupTargetMacros )
include( InstallDirectoryPermissions )
include( MASSigning )

add_subdirectory( externals )

include( wasm )

add_subdirectory( lib )
