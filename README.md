# node-pascal
Embed Node.js into Free Pascal

## linux
```
clang++ ../toby/toby.cpp -c -o toby.o --std=c++11 -fPIC -I../node/deps/v8/include/ -I../node/src/ -g \
&& fpc -g -Cg -Cn example.pas \
&& /usr/bin/ld.bfd -b elf64-x86-64 -m elf_x86_64  --dynamic-linker=/lib64/ld-linux-x86-64.so.2 --rpath=. -L. -o example link.res \
&& ./example
```

## mac - build node.js and toby for i386
```
# toby
clang++ toby.cpp -c -o toby.o --std=c++11 -fPIC -I../node/deps/v8/include/ -I../node/src/ -g -arch i386

# node.js
## fixme : a bug exists when compiling with ssl for x86
./configure --dest-cpu=x86 --shared --without-ssl
make -j4

# then, copy ./out/Release/libnode.51.dylib
```

## compile and run
### fixme : workaround build command in mac
```
fpc -g -Cg -Cn example.pas \
&& clang++ -o example example.o libnode.51.dylib  toby.o  -arch i386 \
/usr/local/lib/fpc/3.0.0/units/i386-darwin/rtl/system.o \
/usr/local/lib/fpc/3.0.0/units/i386-darwin/rtl/objpas.o \
/usr/local/lib/fpc/3.0.0/units/i386-darwin/rtl/sysutils.o \
/usr/local/lib/fpc/3.0.0/units/i386-darwin/rtl/math.o \
/usr/local/lib/fpc/3.0.0/units/i386-darwin/rtl/unix.o \
/usr/local/lib/fpc/3.0.0/units/i386-darwin/rtl/errors.o \
/usr/local/lib/fpc/3.0.0/units/i386-darwin/rtl/sysconst.o \
/usr/local/lib/fpc/3.0.0/units/i386-darwin/rtl/unixtype.o \
/usr/local/lib/fpc/3.0.0/units/i386-darwin/rtl/baseunix.o \
/usr/local/lib/fpc/3.0.0/units/i386-darwin/rtl/sysctl.o \
/usr/local/lib/fpc/3.0.0/units/i386-darwin/rtl/unixutil.o \
/usr/local/lib/fpc/3.0.0/units/i386-darwin/rtl/initc.o \
/usr/local/lib/fpc/3.0.0/units/i386-darwin/rtl/ctypes.o \
&& install_name_tool -change /usr/local/lib/libnode.51.dylib libnode.51.dylib example \
&&  ./example
```

## ref
http://wiki.freepascal.org/Using_Pascal_Libraries_with_.NET_and_Mono
