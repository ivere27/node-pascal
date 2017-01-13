unit TobyPascal;

{$mode objfpc}
{$H+}

{$ifdef darwin}
{$link toby.o}
{$link libnode.48.dylib}
{$link /usr/lib/libgcc_s.10.5.dylib}

{$linklib c}
{$linklib dl}
{$linklib c++}
{$endif}

{$ifdef linux}
{$link toby.o}
{$Link libnode.so.48}
{$linklib c}
{$linklib stdc++}
{$LinkLib gcc_s}
{$LinkLib pthread}
{$LinkLib dl}
{$endif}

interface

uses
  Classes, SysUtils, math;


type
  TobyOnloadCB = procedure (isolate: Pointer); cdecl;
  TobyOnunloadCB = procedure (isolate: Pointer; exitCode: integer); cdecl;
  TobyHostcallCB = function (name, value: PChar):PChar; cdecl;

  TToby = class
    private
      started : boolean;
      constructor Init;
    public
      onLoad : TobyOnloadCB;
      onUnload : TobyOnunloadCB;
      onHostCall : TobyHostcallCB;

      function start(processName, userScript: PChar) : boolean;
      function run(source: PChar) : PChar;
      procedure emit(name, value: PChar);
      class function Create: TToby;
  end;

{
typedef void  (*TobyOnloadCB)(void* isolate);
typedef void  (*TobyOnunloadCB)(void* isolate, int exitCode);
typedef char* (*TobyHostcallCB)(const char* name, const char* value);

extern "C" void  tobyInit(const char* processName,
                          const char* userScript,
                          TobyOnloadCB,
                          TobyOnunloadCB,
                          TobyHostcallCB);
extern "C" char* tobyJSCompile(const char* source);
extern "C" char* tobyJSCall(const char* name, const char* value);
extern "C" bool  tobyJSEmit(const char* name, const char* value);
}

procedure tobyInit(processName, userScript: PChar;
                   tobyOnLoad: TobyOnloadCB;
                   tobyOnUnload: TobyOnunloadCB;
                   tobyHostCall: TobyHostcallCB); cdecl; external;
function tobyJSCompile(source: PChar):PChar; cdecl; external;
function tobyJSCall(name, value: PChar):PChar; cdecl; external;
function tobyJSEmit(name, value: PChar):PChar; cdecl; external;

implementation
var
  Singleton : TToby = nil;


procedure _OnLoad(isolate: Pointer); cdecl;
begin
  //writeln(':: default tobyOnLoad called');
end;
procedure _OnUnload(isolate: Pointer; exitCode: integer); cdecl;
begin
  //writeln(':: default _OnUnload called');
end;
function _OnHostCall(key,value: PChar):PChar; cdecl;
begin
  //writeln(':: default tobyHostCall called. ', key, ' : ',value);
  exit('');
end;

constructor TToby.Init;
begin
  started := false;

  // set default.
  onLoad := @_OnLoad;
  onUnload := @_OnUnload;
  onHostCall := @_OnHostCall;

{$ifdef linux}
  // disable the floating point exceptions
  // otherwise, 'SIGFPE: invalid floating point operation' raises
  SetExceptionMask([exInvalidOp, exPrecision, exZeroDivide]); // exDenormalized, exOverflow, exUnderflow,
{$endif}

  inherited Create;
end;

class function TToby.Create: TToby;
begin
  if Singleton = nil then
    Singleton := TToby.Init;
  Result := Singleton;
end;

function TToby.start(processName, userScript: PChar) : boolean;
begin
  if started = false then
  begin
    started := true;
    tobyInit(processName, userScript, onLoad, onUnload, onHostCall);
    exit(true);
  end;
  exit(false);
end;


procedure TToby.emit(name, value: PChar);
begin
  tobyJSEmit(name, value);
end;

function TToby.run(source: PChar) : PChar;
begin
  exit(tobyJSCompile(source));
end;

end.