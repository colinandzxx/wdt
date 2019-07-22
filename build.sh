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
            CXX_COMPILER=clang++-4.0
            C_COMPILER=clang-4.0
            MONGOD_CONF=${HOME}/opt/mongodb/mongod.conf
            export PATH=${HOME}/opt/mongodb/bin:$PATH
        ;;
        *)
            printf "\\n\\tUnsupported Linux Distribution. Exiting now.\\n\\n"
            exit 1
    esac

    WASM_ROOT="${HOME}/opt/wdt/wasm"
    
    . "$FILE"
fi
