unit Unit1;

{$mode objfpc}{$H+}
{$ifdef linux}
{$link ../toby.o}
{$Link ../libnode.so.48}
{$linklib c}
{$linklib stdc++}
{$LinkLib gcc_s}
{$LinkLib pthread}
{$LinkLib dl}
{$endif}


interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  math;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

  TobyOnloadCB = procedure (isolate: Pointer); cdecl;
  TobyHostcallCB = function (name, value: PChar):PChar; cdecl;

{$ifdef linux}
procedure _tobyRegister(); cdecl; external;
{$endif}
procedure tobyInit(processName, userScript: PChar; tobyOnLoad:TobyOnloadCB; tobyHostCall:TobyHostcallCB); cdecl; external;
function tobyJSCompile(source: PChar):PChar; cdecl; external;
function tobyJSCall(name, value: PChar):PChar; cdecl; external;
function tobyJSEmit(name, value: PChar):PChar; cdecl; external;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }


procedure tobyOnLoad(isolate: Pointer); cdecl;
begin
  writeln(':: tobyOnLoad called');
end;
function tobyHostCall(key,value: PChar):PChar; cdecl;
begin
  writeln(':: tobyHostCall called. ', key, ' : ',value);
  exit('from tobyHostCall');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  {$ifdef linux}
    // disable the floating point exceptions
    // otherwise, 'SIGFPE: invalid floating point operation' raises
    SetExceptionMask([exInvalidOp, exPrecision, exZeroDivide]); // exDenormalized, exOverflow, exUnderflow,
    _tobyRegister;
  {$endif}
  tobyInit(PChar(ParamStr(0)), Memo1.Lines.GetText , @tobyOnLoad, @tobyHostCall);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  tobyJSEmit(PChar(Edit1.Text), PChar(Edit2.Text));
end;

end.


