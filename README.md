# node-pascal
Embed Node.js into Free Pascal

## linux
```
clang++ ../toby/toby.cpp -c -o toby.o --std=c++11 -fPIC -I../node/deps/v8/include/ -I../node/src/ -g \
&& fpc -g -Cg -k--rpath=. example.pas \
&& ./example
```

## lazarus - gui
```
# cd gui && rm -rf lib && \
lazbuild project1.lpi && ./project1
```

## mac - build node.js and toby for i386
```
# toby
clang++ ../toby/toby.cpp -c -o toby.o --std=c++11 -fPIC -I../node/deps/v8/include/ -I../node/src/ -I../node/deps/uv/include -g -arch i386

# node.js
./configure --dest-cpu=x86 --shared --openssl-no-asm
make -j4

# then, copy ./out/Release/libnode.48.dylib
```

## compile and run
### fixme : workaround build command in mac
```
fpc -g -Cg -Cn TobyPascal.pas \
&& fpc -g -Cg example.pas \
&& install_name_tool -change /usr/local/lib/libnode.48.dylib libnode.48.dylib example \
&&  ./example
```

## lazarus in mac - gui
```bash
# cd gui && rm -rf lib && \
lazbuild project1.lpi \
&& install_name_tool -change /usr/local/lib/libnode.48.dylib libnode.48.dylib project1 \
&& ./project1
```


## win
```
# build 'toby' as OMF object using C++ Builder or BCC32C C++ compiler(https://www.embarcadero.com/free-tools/ccompiler)
# (not COFF by VC++)
```

## ref
http://wiki.freepascal.org/Using_Pascal_Libraries_with_.NET_and_Mono
