unit frmlogoutput;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TformLogOutput }

  TformLogOutput = class(TForm)
    Button1: TButton;
    memoLog: TMemo;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  formLogOutput: TformLogOutput;

implementation

{$R *.lfm}

{ TformLogOutput }

procedure TformLogOutput.Button1Click(Sender: TObject);
begin
  memoLog.Clear;
end;

end.

