unit Unit1;

{$mode objfpc}{$H+}



interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  TobyPascal;

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

var
  toby : TToby;
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }


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

procedure TForm1.FormCreate(Sender: TObject);
begin
  // start Toby
  toby := TToby.Create;
  toby.onLoad := @tobyOnLoad;
  toby.onHostCall := @tobyHostCall;
  toby.start(PChar(ParamStr(0)), Memo1.Lines.GetText);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  toby.emit(PChar(Edit1.Text), PChar(Edit2.Text));
end;

end.


