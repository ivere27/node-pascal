program example;

{$mode objfpc}
{$H+}

{$ifdef linux}
{$link toby.o}
{$Link libnode.so.48}
{$linklib c}
{$linklib stdc++}
{$LinkLib gcc_s}
{$LinkLib pthread}
{$LinkLib dl}
{$endif}

uses
  SysUtils, math;

{
typedef void  (*TobyOnloadCB)(void* isolate);
typedef char* (*TobyHostcallCB)(const char* name, const char* value);

extern "C" void  tobyInit(const char* processName,
                          const char* userScript,
                          TobyOnloadCB,
                          TobyHostcallCB);
extern "C" char* tobyJSCompile(const char* source);
extern "C" char* tobyJSCall(const char* name, const char* value);
extern "C" bool  tobyJSEmit(const char* name, const char* value);
}

type
  TobyOnloadCB = procedure (isolate: Pointer); cdecl;
  TobyHostcallCB = function (name, value: PChar):PChar; cdecl;

procedure _tobyRegister(); cdecl; external;
procedure tobyInit(processName, userScript: PChar; tobyOnLoad:TobyOnloadCB; tobyHostCall:TobyHostcallCB); cdecl; external;
function tobyJSCompile(source: PChar):PChar; cdecl; external;
function tobyJSCall(name, value: PChar):PChar; cdecl; external;
function tobyJSEmit(name, value: PChar):PChar; cdecl; external;

procedure tobyOnLoad(isolate: Pointer); cdecl;
begin
  writeln(':: tobyOnLoad called');
end;
function tobyHostCall(key,value: PChar):PChar; cdecl;
begin
  writeln(':: tobyHostCall called');
  exit('from tobyHostCall');
end;

var
i : integer = 0;
j : integer;
begin
  writeln(':: example.pas main');

  WriteLn(GetProcessID, ' Program: ', ParamStr(0));
  for j := 1 to ParamCount do
    WriteLn(GetProcessID, ' Param ', j, ': ', ParamStr(j));

// for j := 0 to GetEnvironmentVariableCount - 1 do
//     WriteLn(GetProcessID, ' ', GetEnvironmentString(j));

{$ifdef darwin}
  tobyInit(PChar(ParamStr(0)), 'require("./app.js");', @tobyOnLoad, @tobyHostCall);
{$else}
  // disable the floating point exceptions
  // otherwise, 'SIGFPE: invalid floating point operation' raises
  SetExceptionMask([exInvalidOp, exPrecision, exZeroDivide]); // exDenormalized, exOverflow, exUnderflow,
  _tobyRegister;
  tobyInit(PChar(ParamStr(0)), 'require("./app.js");', @tobyOnLoad, @tobyHostCall);
{$endif}

  while true do
  begin
    i:= i+1;
    tobyJSEmit('test', PChar(IntToStr(i)));
    Sleep(1000);
  end;
end.