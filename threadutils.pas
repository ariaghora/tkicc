unit threadutils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, fpjson, jsonparser, fphttpclient, json2lv, helper, globals,
  process, FileUtil, Forms, Controls, Graphics, StdCtrls,
  ExtCtrls, Menus, inifiles, strutils, ComCtrls, httpsend;

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

  { TMuatDetailThread }

  TMuatDetailThread = class(TThread)
    idTKI: string;
    s: string;
  protected
    procedure Execute; override;
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
    searchString: string;
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


  { TRenderOndemandReportThread }

  TRenderOndemandReportThread = class(TThread)
    lv: TListView;
    s: string;
  protected
    procedure Execute; override;
    procedure doList;
  public
    constructor Create(CreateSuspended: boolean);
    procedure preRun;
    procedure postRun;
  end;

  { TRenderTkiThread }

  TRenderTkiThread = class(TThread)
    lv: TListView;
    s: string;
  protected
    procedure Execute; override;
    procedure doList;
  public
    constructor Create(CreateSuspended: boolean);
    procedure preRun;
    procedure postRun;
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

  { TCekKoneksiServerThread }

  TCekKoneksiServerThread = class(TThread)
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: boolean);
  end;


implementation

uses
  frmMain, frmlogin, frmondemand, frmeditdatatki, frmMonitoring, frmpengaturan,
  frmsmslokal;

{ TMuatDetailThread }

procedure TMuatDetailThread.Execute;
begin
  Synchronize(@preRun);
  try
    s := TFPHTTPClient.SimpleGet(LINK_DETAIL_TKI + '/' + idTKI);
    Synchronize(@onSucceed);
  except
    on Exception do
    begin
      Synchronize(@onFailed);
    end;
  end;
  Synchronize(@postRun);
end;

constructor TMuatDetailThread.Create(CreateSuspended: boolean);
begin
  freeOnTerminate := True;
  inherited Create(CreateSuspended);
end;

procedure TMuatDetailThread.preRun;
begin
  formMain.pnlContent.Enabled := False;
  formMain.imgAnimation.Show;
  catatLog('memuat detail TKI');
end;

procedure TMuatDetailThread.postRun;
begin
  formMain.imgAnimation.Hide;
  //if TERKONEKSI_KE_SERVER then
  begin
    formMain.pnlContent.Enabled := True;
    catatLog('detail TKI dimuat');
  end;
end;

procedure TMuatDetailThread.onSucceed;
var
  jParser: TJSONParser;
  jData: TJSONData;
  jObject: TJSONObject;
begin
  jParser := TJSONParser.Create(s);
  jData := jParser.Parse;
  with formEditDataTKI do
  begin
    jObject := TJSONObject(TJSONArray(jData).Items[0]);
    kodeTipe := jObject.Get('kode_tipe');
    nama := jObject.Get('nama');
    nomorTelepon := jObject.Get('nomor_telepon');
    lokasiKerja := jObject.Get('lokasi_kerja');
    kodeNegara := jObject.Get('kode_negara');
    kodeWilayah := jObject.Get('kode_wilayah');
    kodePeer := jObject.Get('peer');

    txtKodeTipe.Text := kodeTipe;
    txtNama.Text := nama;
    txtNomorTelepon.Text := nomorTelepon;
    txtLokasiKerja.Text := lokasiKerja;
    txtKodeNegara.Text := kodeNegara;
    txtKodeWilayah.Text := kodeWilayah;
    txtKodePeer.Text := kodePeer;
  end;
end;

procedure TMuatDetailThread.onFailed;
begin
  ShowMessage('gagal memuat detail');
  ShowMessage(s);

end;



{ TRenderTkiThread }

procedure TRenderTkiThread.Execute;
begin
  Synchronize(@preRun);
  s := TFPHTTPClient.SimpleGet(LINK_LIST_TKI + '/' + ID_SIMPUL_CABANG);
  Synchronize(@doList);
  Synchronize(@postRun);
end;

procedure TRenderTkiThread.doList;
begin
  renderJSON2ListView(s, lv);
end;

constructor TRenderTkiThread.Create(CreateSuspended: boolean);
begin
  freeOnTerminate := True;
  inherited Create(CreateSuspended);
end;

procedure TRenderTkiThread.preRun;
begin
  formMain.pnlContent.Enabled := False;
  formMain.imgAnimation.Show;
  catatLog('memuat daftar TKI pada simpul' + ID_SIMPUL_CABANG);
end;

procedure TRenderTkiThread.postRun;
begin
  formMain.imgAnimation.Hide;
  //if TERKONEKSI_KE_SERVER then
  begin
    formMain.pnlContent.Enabled := True;
    catatLog('daftar TKI pada simpul ' + ID_SIMPUL_CABANG + ' dimuat');
  end;
end;

{ TRenderOndemandReportThread }

procedure TRenderOndemandReportThread.Execute;
begin
  Synchronize(@preRun);
  s := TFPHTTPClient.SimpleGet(LINK_LIST_PESAN_ONDEMAND + '/' + ID_SIMPUL_CABANG);
  Synchronize(@doList);
  Synchronize(@postRun);
end;

procedure TRenderOndemandReportThread.doList;
begin
  renderJSON2ListView(s, lv);
end;

constructor TRenderOndemandReportThread.Create(CreateSuspended: boolean);
begin
  FreeOnTerminate := True;
  inherited Create(CreateSuspended);
end;

procedure TRenderOndemandReportThread.preRun;
begin
  formMain.pnlContent.Enabled := False;
  formMain.imgAnimation.Show;
  catatLog('memuat daftar pesan on-demand');

end;

procedure TRenderOndemandReportThread.postRun;
begin
  formMain.imgAnimation.Hide;
  //if TERKONEKSI_KE_SERVER then
  begin
    formMain.pnlContent.Enabled := True;
    catatLog('daftar pesan on-demand dimuat');
  end;

end;

{ TCekKoneksiServerThread }

procedure TCekKoneksiServerThread.Execute;
var
  header: TStringList;
  httpsender: THTTPSend;
begin

  header := TStringList.Create;
  header.Add('Accept: text/html');

  httpsender := THTTPSend.Create;
  httpsender.Headers.AddStrings(header);
  httpsender.KeepAlive := False;
  httpsender.Timeout := 1000;
  //httpsender.KeepAliveTimeout := 5;

  if httpsender.HTTPMethod('GET', 'http://www.tkicc.16mb.com') then
  begin
    //if httpsender.ResultCode < 400 then
    TERKONEKSI_KE_SERVER := True;
    //else

  end
  else
    TERKONEKSI_KE_SERVER := False;

  frmMain.cekInternet := False;
  httpsender.Free;
end;

constructor TCekKoneksiServerThread.Create(CreateSuspended: boolean);
begin
  FreeOnTerminate := True;
  inherited Create(CreateSuspended);
end;

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
  catatLog('memuat broadcast terkirim');
end;

procedure TRenderBroadcastMessage.postRun;
begin
  formMain.imgAnimation.Hide;
  //if TERKONEKSI_KE_SERVER then
  begin
    formMain.pnlContent.Enabled := True;
    catatLog('broadcast terkirim dimuat');
  end;
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

  try
    // lakukan HTTP request
    s := TFPHTTPClient.SimpleGet(LINK_LIST_LAPORAN + kodeWilayah + '/' + tipeLaporan);
  except
    on Exception do
    begin

    end;
  end;
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
  catatLog('memuat laporan rutin');
end;

procedure TRenderRegularReportThread.postRun;
var
  i, j: integer;
  bool: boolean;
begin
  if Length(searchString) > 0 then
  begin
    lv.Items.BeginUpdate;

    for i := lv.Items.Count - 1 downto 0 do
    begin
      bool := Pos(UpperCase(searchString), UpperCase(lv.Items[i].Caption)) > 0;
      if not (bool) then
      begin
        for j := 0 to lv.Items[i].SubItems.Count - 1 do
        begin
          if Pos(UpperCase(searchString), UpperCase(lv.Items[i].SubItems[j])) > 0 then
          begin
            bool := True;
            break;
          end;
        end;
      end;
      if not bool then
        lv.Items[i].Delete;
    end;
    lv.Items.EndUpdate;

  end;

  formMain.imgAnimation.Hide;
  //if TERKONEKSI_KE_SERVER then
  begin
    formMain.pnlContent.Enabled := True;
    catatLog('laporan rutin dimuat');
  end;
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
    on Exception do
      catatLog('Kesalahan jaringan');
  end;


  try
    jParser := TJSONParser.Create(s);
    jData := jParser.Parse;

    if jData is TJSONArray then
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
  except
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
  catatLog('Log in...');
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
  //formMain.imgMonitorMouseDown(formMain.imgMonitor, mbLeft, [], 0, 0);
  catatLog('login berhasil sebagai ' + USER_NAME);


  formOnDemand.init;
  formMonitoring.init;
  //ShowMessage(TFPHTTPClient.SimpleGet(LINK_JUMLAH_PESAN_ONDEMAND + '/' + ID_SIMPUL_CABANG));
  formOnDemand.Timer1.Enabled := True;
  formMonitoring.Timer1.Enabled := True;
  formPengaturan.Timer1.Enabled := True;

  if ID_SIMPUL_CABANG = '0' then
  begin
    formMain.Label3.Show;
    formMain.shapeIndicatorSMSD.Show;
    formSMSLokal.Timer1.Enabled := True;
  end
  else
  begin
    formMain.Label3.Hide;
    formMain.shapeIndicatorSMSD.Hide;
  end;

end;

procedure TLoginThread.onFailed;
begin
  ShowMessage('Login Failed');
  catatLog('login gagal');
end;

end.
