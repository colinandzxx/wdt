find_package(LLVM 6.0 REQUIRED CONFIG)
if (NOT LLVM_FOUND)
  message(FATAL_ERROR "LLVM Not Found!")
endif (NOT LLVM_FOUND)

find_package(Boost 1.67)
if (NOT Boost_FOUND)
  message(FATAL_ERROR "Boost Not Found!")
endif (NOT Boost_FOUND)

# SET(CMAKE_BUILD_TYPE "Debug")
# SET(CMAKE_CXX_FLAGS_DEBUG "$ENV{CXXFLAGS} -O0 -Wall -g2 -ggdb")

#project name
# project(abi-gen)

#source directory
aux_source_directory(src DIR_SRCS)

#add executable file
add_executable(abi-gen ${DIR_SRCS})

#head file path
target_include_directories(abi-gen PRIVATE
  "${CMAKE_CURRENT_SOURCE_DIR}/include"
  "${LLVM_INCLUDE_DIRS}"
  "${Boost_INCLUDE_DIRS}"
)

#add link library
target_link_libraries(abi-gen
  clangRewrite
  clangTooling
  clangToolingCore
  clangFrontend
  clangDriver
  clangSerialization
  clangParse
  clangSema
  clangAnalysis
  clangAST
  clangBasic
  clangEdit
  clangLex
)

target_link_libraries(abi-gen
  LLVMX86AsmParser # MC, MCParser, Support, X86CodeGen, X86Desc, X86Info
  LLVMX86CodeGen # Analysis, AsmPrinter, CodeGen, Core, MC, Support, Target, 
                 # X86AsmPrinter, X86Desc, X86Info, X86Utils
  LLVMX86Desc # MC, MCDisassembler, Object, Support, X86AsmPrinter, X86Info
  LLVMX86AsmPrinter # MC, Support, X86Utils
  LLVMX86Info # Support
  LLVMX86Utils # Core, Support
  LLVMCodeGen # Analysis, Core, MC, Scalar, Support, Target, TransformUtils
  LLVMipo
  LLVMScalarOpts
  LLVMInstCombine
  LLVMTransformUtils
  LLVMTarget # Analysis, MC, Core, Support
  LLVMAnalysis # Core, Support
  LLVMOption # Support
  LLVMMCDisassembler # MC, Support
  LLVMMCParser # MC, Support
  LLVMMC # Object, Support
  LLVMProfileData # Core, Support, Object
  LLVMObject # BitReader, Core, Support
  LLVMBitReader # Core, Support
  LLVMCore # BinaryFormat, Support
  #LLVMBinaryFormat # Support
  LLVMSupport # Demangle
  LLVMDemangle
)
