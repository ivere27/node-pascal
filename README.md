# node-pascal
Embed Node.js into Free Pascal

## Example
```pascal
program example;

{$mode objfpc} {$H+}

uses
  SysUtils, math, Classes, TobyPascal;

var
  toby : TToby;

procedure tobyOnLoad(isolate: Pointer); cdecl;
begin
  writeln('host :: tobyOnLoad called');

  toby.run('console.log("node :: hi~");');
end;
procedure tobyOnUnload(isolate: Pointer; exitCode: Integer); cdecl;
begin
  writeln('host :: tobyOnUnload called. ', exitCode);
end;
function tobyHostCall(key,value: PChar):PChar; cdecl;
begin
  writeln('host :: tobyHostCall called. ', key, ' : ',value);
  exit('from tobyHostCall');
end;

var
i : integer = 0;
j : integer;
begin
  writeln('host :: example.pas main');

  // start Toby
  toby := TToby.Create;
  toby.onLoad := @tobyOnLoad;
  toby.onUnload := @tobyOnUnload;
  toby.onHostCall := @tobyHostCall;
  toby.start(PChar(ParamStr(0)), 'require("./app.js");');

  while true do
  begin
    i:= i+1;
    toby.emit('test', PChar(IntToStr(i)));
    Sleep(1000);
  end;
end.
```
#### app.js
```javascript
'use strict'

// print toby.version
console.log(`node :: toby.version = ${toby.version}`);

var num = 42;
var foo = 'foo';

toby.on('test', function(x){
  console.log(`node :: toby.on(test) = ${x}`);
});

var result = toby.hostCall('dory', {num, foo});
console.log(`node :: toby.hostCall() = ${result}`);

// exit after 2 secs
(function(){setTimeout(function(){
  process.exitCode = 42;
},2000)})();
```
#### output
```
host :: example.pas main
host :: tobyOnLoad called
node :: hi~
node :: toby.version = 0.1.3
host :: tobyHostCall called. dory : {"num":42,"foo":"foo"}
node :: toby.hostCall() = from tobyHostCall
node :: toby.on(test) = 2
node :: toby.on(test) = 3
node :: toby.on(test) = 4
host :: tobyOnUnload called. 42
```

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
fpc -g -Cg -Cn example.pas \
&& clang++ -o example  libnode.48.dylib toby.o TobyPascal.o example.o  -arch i386 \
/usr/local/lib/fpc/3.0.0/units/i386-darwin/rtl/system.o \
/usr/local/lib/fpc/3.0.0/units/i386-darwin/rtl/objpas.o \
/usr/local/lib/fpc/3.0.0/units/i386-darwin/rtl/sysutils.o \
/usr/local/lib/fpc/3.0.0/units/i386-darwin/rtl/math.o \
/usr/local/lib/fpc/3.0.0/units/i386-darwin/rtl/classes.o \
/usr/local/lib/fpc/3.0.0/units/i386-darwin/rtl/unix.o \
/usr/local/lib/fpc/3.0.0/units/i386-darwin/rtl/errors.o \
/usr/local/lib/fpc/3.0.0/units/i386-darwin/rtl/sysconst.o \
/usr/local/lib/fpc/3.0.0/units/i386-darwin/rtl/unixtype.o \
/usr/local/lib/fpc/3.0.0/units/i386-darwin/rtl/baseunix.o \
/usr/local/lib/fpc/3.0.0/units/i386-darwin/rtl/sysctl.o \
/usr/local/lib/fpc/3.0.0/units/i386-darwin/rtl/unixutil.o \
/usr/local/lib/fpc/3.0.0/units/i386-darwin/rtl/initc.o \
/usr/local/lib/fpc/3.0.0/units/i386-darwin/rtl/ctypes.o \
/usr/local/lib/fpc/3.0.0/units/i386-darwin/rtl/types.o \
/usr/local/lib/fpc/3.0.0/units/i386-darwin/rtl/typinfo.o \
/usr/local/lib/fpc/3.0.0/units/i386-darwin/rtl/rtlconsts.o \
-lc -ldl \
&& install_name_tool -change /usr/local/lib/libnode.48.dylib libnode.48.dylib example \
&&  ./example
```

## win
```
# build 'toby' as OMF object using C++ Builder or BCC32C C++ compiler(https://www.embarcadero.com/free-tools/ccompiler)
# (not COFF by VC++)
```

## ref
http://wiki.freepascal.org/Using_Pascal_Libraries_with_.NET_and_Mono
