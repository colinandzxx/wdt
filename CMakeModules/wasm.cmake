find_package(Wasm)

if(WASM_FOUND)
    message(STATUS "Using WASM clang => " ${WASM_CLANG})
    message(STATUS "Using WASM llc => " ${WASM_LLC})
    message(STATUS "Using WASM llvm-link => " ${WASM_LLVM_LINK})
else()
    message( FATAL_ERROR "No WASM compiler cound be found (make sure WASM_ROOT is set)" )
    return()
endif()

