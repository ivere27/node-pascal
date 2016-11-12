program example;

{$mode objfpc}
{$H+}

// {$link toby.o}
// {$Link libnode.51.dylib}
// {$linklib c}
// {$linklib stdc++}
// {$LinkLib gcc_s.1}
// {$LinkLib pthread}

uses
  SysUtils;

{
extern "C" void toby(const char* nodePath, const char* processName, const char* userScript);
extern "C" char* tobyJSCompile(void* isolate, const char* source);
extern "C" char* tobyJSCall(void* isolate, const char* name, const char* value);
extern "C" bool tobyJSEmit(const char* name, const char* value);
}

procedure toby(nodePath, processName, userScript: PChar); cdecl; external;
function tobyJSCompile(isolate: Pointer; source: PChar):PChar; cdecl; external;
function tobyJSCall(isolate: Pointer; name,value: PChar):PChar; cdecl; external;
function tobyJSEmit(name, value: PChar):PChar; cdecl; external;


procedure tobyOnLoad(isolate: Pointer); cdecl; export;
begin
  writeln(':: tobyOnLoad called');
end;
function tobyHostCall(isolate: Pointer; key,value: PChar):PChar; cdecl; export;
begin
  writeln(':: tobyHostCall called');
  exit('from tobyHostCall');
end;

var
i : integer = 0;
begin
  writeln(':: example.pas main');
  toby('./libnode.51.dylib', 'example', 'require("./app.js");');

  while true do
  begin
    i:= i+1;
    tobyJSEmit('test', PChar(IntToStr(i)));
    Sleep(1000);
  end;
end.