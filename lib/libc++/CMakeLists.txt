SET(SRC_FILENAMES algorithm.cpp any.cpp bind.cpp condition_variable.cpp exception.cpp functional.cpp
                  future.cpp ios.cpp iostream.cpp locale.cpp memory.cpp mutex.cpp new.cpp optional.cpp
                  regex.cpp shared_mutex.cpp stdexcept.cpp string.cpp strstream.cpp system_error.cpp
                  thread.cpp typeinfo.cpp utility.cpp valarray.cpp variant.cpp vector.cpp)

#SET(SRC_FILENAMES exception.cpp)

SET(SRC_FILES "")
FOREACH(FN ${SRC_FILENAMES})
  LIST(APPEND SRC_FILES "upstream/src/${FN}")
ENDFOREACH(FN)

add_wast_library(TARGET libc++
  NOWARNINGS
  SOURCE_FILES "${SRC_FILES}"
  INCLUDE_FOLDERS "${STANDARD_INCLUDE_FOLDERS}"
    ${CMAKE_SOURCE_DIR}/lib/musl/upstream/arch/wasm32
    ${CMAKE_SOURCE_DIR}/lib/musl/upstream/arch/generic
    ${CMAKE_SOURCE_DIR}/lib/musl/upstream/obj/internal
    ${CMAKE_SOURCE_DIR}/lib/musl/upstream/src/internal
    ${CMAKE_SOURCE_DIR}/lib/musl/upstream/obj/include
    ${CMAKE_SOURCE_DIR}/lib/musl/upstream/include
  DESTINATION_FOLDER ${CMAKE_CURRENT_BINARY_DIR}
  EXTERN_FLAGS 
    -D_LIBCPP_HAS_NO_THREADS
    -D_LIBCPP_NO_EXCEPTION
    -D_LIBCPP_NO_RTTI
    -D_LIBCPP_DISABLE_VISIBILITY_ANNOTATIONS
    -D_LIBCPP_HAS_MUSL_LIBC
    -D__ELF__
    # -D_LIBCPP_BUILDING_LIBRARY
    # -D_LIBCPP_HAS_NO_THREADS 
    # -D_LIBCPP_NO_EXCEPTION 
    # -D_LIBCPP_NO_RTTI 
    # -D_LIBCPP_DISABLE_VISIBILITY_ANNOTATIONS 
    # -D_LIBCPP_HAS_MUSL_LIBC
)