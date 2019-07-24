ARCH=$( uname )
BUILD_DIR="${PWD}/build"
CMAKE_BUILD_TYPE=Release
DOXYGEN=false
TIME_BEGIN=$( date -u +%s )
TEMP_DIR="/tmp"
VERSION=0.0.1

if [ "$ARCH" == "Linux" ]; then

    if [ ! -e /etc/os-release ]; then
        printf "\\n\\tNot support this linux version."
        printf "\\tExiting now.\\n"
        exit 1
    fi

    OS_NAME=$( cat /etc/os-release | grep ^NAME | cut -d'=' -f2 | sed 's/\"//gI' )

    case "$OS_NAME" in
        "Ubuntu")
            FILE="${PWD}/scripts/build_ubuntu.sh"
            CXX_COMPILER=clang++
            C_COMPILER=clang
            MONGOD_CONF=${HOME}/opt/mongodb/mongod.conf
            export PATH=${HOME}/opt/mongodb/bin:$PATH
        ;;
        *)
            printf "\\n\\tUnsupported Linux Distribution. Exiting now.\\n\\n"
            exit 1
    esac

    WASM_ROOT="${HOME}/opt/wdt/wasm"
    
    . "$FILE"

    printf "\\n\\n>>>>>>>> ALL dependencies sucessfully.\\n\\n"
    printf ">>>>>>>> CMAKE_BUILD_TYPE=%s\\n" "${CMAKE_BUILD_TYPE}"

    if [ ! -d "${BUILD_DIR}" ]; then
        if ! mkdir -p "${BUILD_DIR}"
        then
            printf "Unable to create build directory %s.\\n Exiting now.\\n" "${BUILD_DIR}"
            exit 1;
        fi
    fi

    if ! cd "${BUILD_DIR}"
    then
        printf "Unable to enter build directory %s.\\n Exiting now.\\n" "${BUILD_DIR}"
        exit 1;
    fi

    if [ -z "$CMAKE" ]; then
        CMAKE=$( command -v cmake )
    fi

    if ! "${CMAKE}" -DCMAKE_BUILD_TYPE="${CMAKE_BUILD_TYPE}" -DCMAKE_CXX_COMPILER="${WASM_ROOT}/bin/${CXX_COMPILER}" \
        -DCMAKE_C_COMPILER="${WASM_ROOT}/bin/${C_COMPILER}" -DWASM_ROOT="${WASM_ROOT}" -DBUILD_DOXYGEN="${DOXYGEN}" ..
    then
        printf "\\n\\t>>>>>>>>>>>>>>>>>>>> CMAKE building wdt has exited with the above error.\\n\\n"
        exit -1
    fi

    if ! make -j"${CPU_CORE}"
    then
        printf "\\n\\t>>>>>>>>>>>>>>>>>>>> MAKE building wdt has exited with the above error.\\n\\n"
        exit -1
    fi

    TIME_END=$(( $(date -u +%s) - ${TIME_BEGIN} ))

fi
