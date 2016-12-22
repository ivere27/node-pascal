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

{
  WriteLn(GetProcessID, ' Program: ', ParamStr(0));
  for j := 1 to ParamCount do
    WriteLn(GetProcessID, ' Param ', j, ': ', ParamStr(j));
  for j := 0 to GetEnvironmentVariableCount - 1 do
      WriteLn(GetProcessID, ' ', GetEnvironmentString(j));
}

  // start Toby
  toby := TToby.Create;
  toby.onLoad := @tobyOnLoad;
  toby.onHostCall := @tobyHostCall;
  toby.start(PChar(ParamStr(0)), 'require("./app.js");');

  while true do
  begin
    i:= i+1;
    toby.emit('test', PChar(IntToStr(i)));
    Sleep(1000);
  end;
end.