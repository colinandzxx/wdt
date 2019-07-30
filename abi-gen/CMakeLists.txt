#cmake_minimum_required( VERSION 3.5 )

#SET (CMAKE_C_COMPILER             "/usr/bin/clang-4.0")
SET (CMAKE_C_FLAGS                "-Wall -std=c99")
# SET (CMAKE_C_FLAGS_DEBUG          "-g")
# SET (CMAKE_C_FLAGS_MINSIZEREL     "-Os -DNDEBUG")
# SET (CMAKE_C_FLAGS_RELEASE        "-O4 -DNDEBUG")
# SET (CMAKE_C_FLAGS_RELWITHDEBINFO "-O2 -g")

#SET (CMAKE_CXX_COMPILER             "/usr/bin/clang++-4.0")


#project name
PROJECT(abi_gen)

#head file path
INCLUDE_DIRECTORIES(
include
~/opt/boost/include
# ~/opt/wasm/include
)
set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++14" )
#source directory
AUX_SOURCE_DIRECTORY(src DIR_SRCS)

#set extern libraries
SET(LIBRARIES
	libpthread.so
	libz.so
	libffi.so
	libdl.so
	libm.so
	librt.so
	libtinfo.so
)
#add executable file
ADD_EXECUTABLE(abi_gen ${DIR_SRCS})
#add link library
TARGET_LINK_LIBRARIES(abi_gen ${LIBRARIES})

target_link_libraries(abi_gen
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

target_link_libraries(abi_gen
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
