unit frmmasukkanpassword;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  process, globals;

type

  { TformMasukkanPassword }

  TformMasukkanPassword = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
  private
    { private declarations }
  public
    procedure toggleSMSD;
  end;

var
  formMasukkanPassword: TformMasukkanPassword;

implementation

{$R *.lfm}

{ TformMasukkanPassword }

procedure TformMasukkanPassword.toggleSMSD;
var
  s: string;
  hProcess: TProcess;
begin
  hProcess := TProcess.Create(nil);
  hProcess.Executable := '/bin/sh';
  hProcess.Parameters.Add('-c');
  //hProcess.Parameters.Add('echo "' + Edit1.Text +
  //  '" | sudo -kS service gammu-smsd start');
  if not SMSD_AKTIF then
    hProcess.Parameters.Add('echo "' + Edit1.Text +
      '" | sudo -kS service gammu-smsd start')
  else
  begin
    hProcess.Parameters.Add('echo "' + Edit1.Text +
      '" | sudo -kS service gammu-smsd stop');
  end;

  hProcess.Options := hProcess.Options + [poWaitOnExit, poUsePipes];
  hProcess.Execute;

  Edit1.Clear;
  self.Close;
end;


procedure TformMasukkanPassword.Button1Click(Sender: TObject);
begin
  toggleSMSD;
end;

procedure TformMasukkanPassword.Edit1KeyDown(Sender: TObject;
  var Key: word; Shift: TShiftState);
begin
  if key = 13 then
  begin
    toggleSMSD;
  end;
end;

end.
