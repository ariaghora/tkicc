unit frmlogin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  fphttpclient, fpjson, jsonparser, globals, helper, strutils, threadutils,
  BGRASpriteAnimation, httpsend, process;

type

  { TformLogin }

  TformLogin = class(TForm)
    Button1: TButton;
    edtUsername: TEdit;
    edtPassword: TEdit;
    imgAnimation: TBGRASpriteAnimation;
    procedure Button1Click(Sender: TObject);
    procedure edtPasswordKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    procedure doLogin(username, password: string);
  public
    procedure renderListView;
  end;

var
  formLogin: TformLogin;

implementation

uses
  frmMain, frmlogoutput;

{$R *.lfm}

{ TformLogin }

procedure TformLogin.FormShow(Sender: TObject);
begin
  formMain.Hide;

  //formLogOutput.Show;
end;

procedure TformLogin.Button1Click(Sender: TObject);
var
  thread: TLoginThread;
begin
  if (trim(edtPassword.Text) <> '') and (trim(edtUsername.Text) <> '') then
  begin
    //doLogin(edtUsername.Text, edtPassword.Text);
    thread := TLoginThread.Create(True);
    thread.username := edtUsername.Text;
    thread.password := edtPassword.Text;
    thread.Start;
  end;
end;

procedure TformLogin.edtPasswordKeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  if key = 13 then
    Button1.Click;

end;

procedure TformLogin.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Application.Terminate;
end;

procedure TformLogin.doLogin(username, password: string);
var
  arr: array[0..1] of string;
  s: string;
  jData: TJSONData;
  jParser: TJSONParser;
begin
  arr[0] := username;
  arr[1] := password;

  try
    s := TFPHTTPClient.SimpleGet(serializeFromArr(LINK_LOGIN_STAKEHOLDER, arr));
  except
    ShowMessage('login failed');
  end;

  jParser := TJSONParser.Create(s);
  jData := jParser.Parse;


  if jData.Count = 1 then
  begin
    with TJSONObject(TJSONArray(jData).Items[0]) do
    begin
      Get('username');
      setupSession(Get('id_stakeholder'), Get('username'), Get('pass'),
        Get('id_simpul_cabang'), Get('nama_wilayah'));

      self.Hide;
      formMain.lblWelcome.Caption := 'Hello, ' + USER_NAME + '!';
      formMain.lblInfo.Caption :=
        'User ID ' + USER_ID + ', simpul cabang ' +
        IfThen(ID_SIMPUL_CABANG = '0', 'Eksekutif', NAMA_WILAYAH);

      formMain.Show;
    end;
  end
  else
  begin
    ShowMessage('Login Failed');
  end;

end;

procedure TformLogin.renderListView;
begin

end;

end.
