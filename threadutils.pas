unit threadutils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, fpjson, jsonparser, fphttpclient, json2lv, helper, globals,
  process, FileUtil, Forms, Controls, Graphics, StdCtrls,
  ExtCtrls, Menus, inifiles, baseunix, strutils, ComCtrls, httpsend;

type
  TLoginThread = class(TThread)
    username: string;
    password: string;
    resp: string;
    resp2: string;
  protected
    procedure Execute; override;
    procedure doLogin;
  public
    constructor Create(CreateSuspended: boolean);
    procedure preRun;
    procedure postRun;
    procedure onSucceed;
    procedure onFailed;
  end;

  { TRenderRegularReportThread }

  TRenderRegularReportThread = class(TThread)
    kodeWilayah: string;
    tipeLaporan: string;
    lv: TListView;
    s: string;
  protected
    procedure Execute; override;
    procedure doList;
  public
    constructor Create(CreateSuspended: boolean);
    procedure preRun;
    procedure postRun;
    procedure onSucceed;
    procedure onFailed;
  end;

  { TRenderBroadcastMessage }

  TRenderBroadcastMessage = class(TThread)
    kodeWilayah: string;
    lv: TListView;
    s: string;
  protected
    procedure Execute; override;
    procedure doList;
  public
    constructor Create(CreateSuspended: boolean);
    procedure preRun;
    procedure postRun;
    procedure onSucceed;
    procedure onFailed;
  end;

  { TCekIMEIThread }

  TCekIMEIThread = class(TThread)
    s: string;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: boolean);
    procedure preRun;
    procedure postRun;
  end;


implementation

uses
  frmMain, frmlogin;

{ TCekIMEIThread }

procedure TCekIMEIThread.Execute;
var
  aProcess: TProcess;
  sl: TStringList;
  ROOT_PASS: string = 'kurakura';
begin
  Synchronize(@preRun);

  sl := TStringList.Create;

  //showNotification(messageTitle, messageContet, icon);
  aProcess := TProcess.Create(nil);
  aProcess.Executable := '/bin/sh';
  aProcess.Parameters.Add('-c');
  aProcess.Parameters.Add('echo ' + ROOT_PASS +
    ' | sudo -S gammu-smsd-monitor --delay 1 --loops 1');
  aProcess.Execute;

  //sl.LoadFromStream(aProcess.Output.read`);

  s := aProcess.Output.ReadAnsiString;

  aProcess.Free;
  sl.Free;
  Synchronize(@postRun);
end;

constructor TCekIMEIThread.Create(CreateSuspended: boolean);
begin
  FreeOnTerminate := True;
  inherited Create(CreateSuspended);
end;

procedure TCekIMEIThread.preRun;
begin
  formMain.mainTimer.Enabled := False;
end;

procedure TCekIMEIThread.postRun;
begin
  formMain.mainTimer.Enabled := True;
  ShowMessage(s);
end;

{ TRenderBroadcastMessage }

procedure TRenderBroadcastMessage.Execute;
begin
  Synchronize(@preRun);
  s := TFPHTTPClient.SimpleGet(LINK_LIST_BROADCAST + kodeWilayah);
  Synchronize(@doList);
  Synchronize(@postRun);
end;

procedure TRenderBroadcastMessage.doList;
begin
  renderJSON2ListView(s, lv);
end;

constructor TRenderBroadcastMessage.Create(CreateSuspended: boolean);
begin
  FreeOnTerminate := True;
  inherited Create(CreateSuspended);
end;

procedure TRenderBroadcastMessage.preRun;
begin
  formMain.pnlContent.Enabled := False;
  formMain.imgAnimation.Show;
end;

procedure TRenderBroadcastMessage.postRun;
begin
  formMain.pnlContent.Enabled := True;
  formMain.imgAnimation.Hide;
end;

procedure TRenderBroadcastMessage.onSucceed;
begin

end;

procedure TRenderBroadcastMessage.onFailed;
begin

end;

{ TRenderRegularReportThread }

procedure TRenderRegularReportThread.Execute;
begin
  Synchronize(@preRun);

  s := TFPHTTPClient.SimpleGet(LINK_LIST_LAPORAN + kodeWilayah + '/' + tipeLaporan);
  Synchronize(@doList);

  Synchronize(@postRun);
end;

procedure TRenderRegularReportThread.doList;
begin
  renderJSON2ListView(s, lv);
end;

constructor TRenderRegularReportThread.Create(CreateSuspended: boolean);
begin
  FreeOnTerminate := True;
  inherited Create(CreateSuspended);
end;

procedure TRenderRegularReportThread.preRun;
begin
  formMain.pnlContent.Enabled := False;
  formMain.imgAnimation.Show;
end;

procedure TRenderRegularReportThread.postRun;
begin
  formMain.pnlContent.Enabled := True;
  formMain.imgAnimation.Hide;
end;

procedure TRenderRegularReportThread.onSucceed;
begin

end;

procedure TRenderRegularReportThread.onFailed;
begin

end;

constructor TLoginThread.Create(CreateSuspended: boolean);
begin
  FreeOnTerminate := True;
  inherited Create(CreateSuspended);
end;

function HttpGetTextTimeout(const URL: string; const Response: TStrings;
  const Timeout: integer): boolean;
var
  HTTP: THTTPSend;
begin
  HTTP := THTTPSend.Create;
  try
    HTTP.Timeout := Timeout;
    Result := HTTP.HTTPMethod('GET', URL);
    if Result then
      Response.LoadFromStream(HTTP.Document);
  finally
    HTTP.Free;
  end;
end;

function DownloadHTTP(URL: string; const response: TStrings): boolean;
var
  HTTPGetResult: boolean;
  HTTPSender: THTTPSend;
  res: TMemoryStream;
begin
  //res := TMemoryStream.Create;
  try
    //HttpPostURL(URL, '', res);
    HttpGetText(url, response);
    //response.LoadFromStream(res);
  finally
  end;
end;

procedure TLoginThread.doLogin;
var
  arr: array[0..1] of string;
  s: string;
  jData: TJSONData;
  jParser: TJSONParser;

  sl: TStringList;
begin

  arr[0] := username;
  arr[1] := password;

  sl := TStringList.Create;

  try
    s := TFPHTTPClient.SimpleGet(serializeFromArr(LINK_LOGIN_STAKEHOLDER, arr));

  except
    // ShowMessage('login failed');
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

      Synchronize(@onSucceed);

    end;
  end
  else
  begin
    Synchronize(@onFailed);
  end;

end;

procedure TLoginThread.Execute;
begin

  Synchronize(@preRun);
  doLogin;
  Synchronize(@postRun);

end;

procedure TLoginThread.preRun;
begin
  formLogin.imgAnimation.Show;
  formLogin.Button1.Enabled := False;
  formLogin.Button1.Width := 120;
  formLogin.edtPassword.Enabled := False;
  formLogin.edtUsername.Enabled := False;

end;

procedure TLoginThread.postRun;
begin
  formLogin.imgAnimation.Hide;
  formLogin.edtPassword.Clear;
  formLogin.edtUsername.Clear;
  formLogin.Button1.Enabled := True;
  formLogin.Button1.Width := 147;
  formLogin.edtPassword.Enabled := True;
  formLogin.edtUsername.Enabled := True;


end;

procedure TLoginThread.onSucceed;
begin
  formLogin.Hide;
  formMain.lblWelcome.Caption := 'Hello, ' + USER_NAME + '!';
  formMain.lblInfo.Caption :=
    'User ID ' + USER_ID + ', simpul cabang ' +
    IfThen(ID_SIMPUL_CABANG = '0', 'Eksekutif', NAMA_WILAYAH);
  formMain.Show;
  formMain.imgMonitorMouseDown(formMain.imgMonitor, mbLeft, [], 0, 0);
end;

procedure TLoginThread.onFailed;
begin
  ShowMessage('Login Failed');
end;

end.
