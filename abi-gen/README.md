# abi_gen

b chain smart contract abi file generation

## build

mkdir -p build

cd build

../cmake

make

## generate abi file

```shell
    ./abi_gen -extra-arg=-c -extra-arg=--std=c++14 -extra-arg=--target=wasm32 -extra-arg=-nostdinc -extra-arg=-nostdinc++ -extra-arg=-DABIGEN -destination-file=xx -verbose=0 -extra-arg=-fparse-all-comments -extra-arg=-I/home/zepple/wasm  -context=/home/zepple/wasm test.cpp
```



## external tool

### compile eos

1) check out eos v1.06

2) compile eos

### binaryen

check out branch asm2wasm-import-wasm-mem

### wasm gen

```shell
    ~/opt/wasm/bin/clang test.cpp -o test.bc -c -emit-llvm -Os --std=c++14 --target=wasm32 -nostdinc -nostdlib -nostdlibinc -ffreestanding -fno-threadsafe-statics -fno-rtti -fno-exceptions -I /usr/include/x86_64-linux-gnu/
    ~/opt/wasm/bin/llc -filetype=asm test.bc -o test.s --asm-verbose=false
    s2wasm test.s -s 16384 > test.wast
    wasm-as test.wast > test.wasm
```


