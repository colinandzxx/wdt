CPU_CORE=$( lscpu | grep "^CPU(s)" | tr -s ' ' | cut -d\  -f2 || cut -d' ' -f2 )
JOBS=$(( CPU_CORE ))
VER=release_40
ROOT_PATH=${PWD}

# get dependencies
DEP_ARRAY=(clang-6.0 lldb-6.0 libclang-6.0-dev cmake make automake build-essential \
autoconf libtool)
COUNT=1
DISPLAY=""
DEP=""

printf "\\n\\tChecking for installed dependencies.\\n\\n"

for (( i=0; i<${#DEP_ARRAY[@]}; i++ ));
do
    pkg=$( dpkg -s "${DEP_ARRAY[$i]}" 2>/dev/null | grep Status | tr -s ' ' | cut -d\  -f4 )
    if [ -z "$pkg" ]; then
        DEP=$DEP" ${DEP_ARRAY[$i]} "
        DISPLAY="${DISPLAY}${COUNT}. ${DEP_ARRAY[$i]}\\n\\t"
        printf "\\tPackage %s ${bldred} NOT ${txtrst} found.\\n" "${DEP_ARRAY[$i]}"
        (( COUNT++ ))
    else
        printf "\\tPackage %s found.\\n" "${DEP_ARRAY[$i]}"
        continue
    fi
done

if [ "${COUNT}" -gt 1 ]; then
    printf "\\n\\tThe following dependencies are required to install WDT.\\n"
    printf "\\n\\t${DISPLAY}\\n\\n" 
    printf "\\tDo you wish to install these packages?\\n"
    select yn in "Yes" "No"; do
        case $yn in
            [Yy]* ) 
                printf "\\n\\n\\tInstalling dependencies\\n\\n"
                sudo apt-get update
                if ! sudo apt-get -y install ${DEP}
                then
                    printf "\\n\\tDPKG dependency failed.\\n"
                    printf "\\n\\tExiting now.\\n"
                    exit 1
                else
                    printf "\\n\\tDPKG dependencies installed successfully.\\n"
                fi
            break;;
            [Nn]* ) echo "User aborting installation of required dependencies, Exiting now."; exit;;
            * ) echo "Please type 1 for yes or 2 for no.";;
        esac
    done
else 
    printf "\\n\\tNo required dpkg dependencies to install.\\n"
fi


printf "\\n\\tChecking for LLVM with WASM support.\\n"
if [ ! -d "${WASM_ROOT}/bin" ]; then
# Build LLVM and clang with WASM support:
printf "\\tInstalling LLVM with WASM\\n"
    if ! cd "${TEMP_DIR}"
    then
        printf "\\n\\tUnable to cd into directory %s.\\n" "${TEMP_DIR}"
        printf "\\n\\tExiting now.\\n"
        exit 1;
    fi
    if ! mkdir "${TEMP_DIR}/llvm-compiler"  2>/dev/null
    then
        printf "\\n\\tUnable to create directory %s/llvm-compiler.\\n" "${TEMP_DIR}"
        printf "\\n\\tExiting now.\\n"
        exit 1;
    fi
    if ! cd "${TEMP_DIR}/llvm-compiler"
    then
        printf "\\n\\tUnable to enter directory %s/llvm-compiler.\\n" "${TEMP_DIR}"
        printf "\\n\\tExiting now.\\n"
        exit 1;
    fi
    if ! git clone --depth 1 --single-branch --branch ${VER} https://github.com/llvm-mirror/llvm.git
    then
        printf "\\tUnable to clone llvm repo @ https://github.com/llvm-mirror/llvm.git.\\n"
        printf "\\n\\tExiting now.\\n"
        exit 1;
    fi
    if ! cd "${TEMP_DIR}/llvm-compiler/llvm/tools"
    then
        printf "\\tUnable to enter directory %s/llvm-compiler/llvm/tools.\\n" "${TEMP_DIR}"
        printf "\\n\\tExiting now.\\n"
        exit 1;
    fi
    if ! git clone --depth 1 --single-branch --branch ${VER} https://github.com/llvm-mirror/clang.git
    then
        printf "\\tUnable to clone clang repo @ https://github.com/llvm-mirror/clang.git.\\n"
        printf "\\n\\tExiting now.\\n"
        exit 1;
    fi
    if ! cd "${TEMP_DIR}/llvm-compiler/llvm"
    then
        printf "\\tUnable to enter directory %s/llvm-compiler/llvm.\\n" "${TEMP_DIR}"
        printf "\\n\\tExiting now.\\n"
        exit 1;
    fi
    if ! mkdir "${TEMP_DIR}/llvm-compiler/llvm/build"
    then
        printf "\\tUnable to create directory %s/llvm-compiler/llvm/build.\\n" "${TEMP_DIR}"
        printf "\\n\\tExiting now.\\n"
        exit 1;
    fi
    if ! cd "${TEMP_DIR}/llvm-compiler/llvm/build"
    then
        printf "\\tUnable to enter directory %s/llvm-compiler/llvm/build.\\n" "${TEMP_DIR}"
        printf "\\n\\tExiting now.\\n"
        exit 1;
    fi
    if ! cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${WASM_ROOT}" -DLLVM_TARGETS_TO_BUILD= \
    -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly -DCMAKE_BUILD_TYPE=Release ../
    # -DCMAKE_BUILD_TYPE=Release ../
    then
        printf "\\tError compiling LLVM and clang with EXPERIMENTAL WASM support.0\\n"
        printf "\\n\\tExiting now.\\n"
        exit 1;
    fi
    if ! make -j"${JOBS}" install
    then
        printf "\\tError compiling LLVM and clang with EXPERIMENTAL WASM support.1\\n"
        printf "\\n\\tExiting now.\\n"
        exit 1;
    fi
    if ! rm -rf "${TEMP_DIR}/llvm-compiler"
    then
        printf "\\tUnable to remove directory %s/llvm-compiler.\\n" "${TEMP_DIR}"
        printf "\\n\\tExiting now.\\n"
        exit 1;
    fi
    printf "\\n\\tWASM successffully installed @ %s/bin.\\n\\n" "${WASM_ROOT}"
else
    printf "\\tWASM found at %s/bin.\\n" "${WASM_ROOT}"
fi

MUSL_PATH=${ROOT_PATH}/lib/musl/upstream
printf "\\n\\tPrepare for MUSL lib with WASM support.\\n"
if [ -d "${MUSL_PATH}" ]; then
    if ! cd "${MUSL_PATH}"
    then
        printf "\\n\\tUnable to cd into directory %s.\\n" "${MUSL_PATH}"
        printf "\\n\\tExiting now.\\n"
        exit 1;
    fi
    if ! ./configure CC="${WASM_ROOT}/bin/clang --target=wasm32" --target=wasm
    then
        printf "\\n\\tUnable to configure %s.\\n" "./configure"
        printf "\\n\\tExiting now.\\n"
        exit 1;
    fi
    if ! make obj/include/bits/alltypes.h
    then
        printf "\\n\\tmake error: %s.\\n" "make obj/include/bits/alltypes.h"
        printf "\\n\\tExiting now.\\n"
        exit 1;
    fi
    if ! make obj/include/bits/syscall.h
    then
        printf "\\n\\tmake error: %s.\\n" "make obj/include/bits/syscall.h"
        printf "\\n\\tExiting now.\\n"
        exit 1;
    fi
    if ! make obj/src/internal/version.h
    then
        printf "\\n\\tmake error: %s.\\n" "make obj/src/internal/version.h"
        printf "\\n\\tExiting now.\\n"
        exit 1;
    fi
else
    printf "\\tMUSL lib not found. %s\\n" "${MUSL_PATH}"
    printf "\\n\\tExiting now.\\n"
    exit 1;
fi
