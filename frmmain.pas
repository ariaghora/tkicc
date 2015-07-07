unit frmMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, Controls, SysUtils, Graphics, Dialogs, LCLType, ExtCtrls,
  ComCtrls, StdCtrls, Grids, Buttons, PairSplitter, Menus, fphttpclient, fpjson,
  jsonparser, helper, globals, json2lv, BGRASpriteAnimation, BGRAShape,
  threadutils, process, Math, httpsend;

type

  { TformMain }

  TformMain = class(TForm)
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    memoLog: TMemo;
    MenuItem1: TMenuItem;
    pnlLog: TPanel;
    PopupMenu1: TPopupMenu;
    shapeIndicatorSMSD: TBGRAShape;
    imgAnimation: TBGRASpriteAnimation;
    Image1: TImage;
    imgManajemenTKI: TImage;
    imgMessaging: TImage;
    imgSettings: TImage;
    imgMonitor: TImage;
    imgShade: TImage;
    imgOndemand: TImage;
    Label1: TLabel;
    lblInfo: TLabel;
    lblWelcome: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    pnlLeft: TPanel;
    pnlContent: TPanel;
    Panel8: TPanel;
    mainTimer: TTimer;
    shapeIndicatorServer: TBGRAShape;
    Splitter1: TSplitter;
    guiTimer: TTimer;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure guiTimerTimer(Sender: TObject);
    procedure imgMonitorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure Label1Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure mainTimerTimer(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure Panel1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure Panel1Resize(Sender: TObject);
    procedure pnlLeftResize(Sender: TObject);
    procedure StringGrid1PrepareCanvas(Sender: TObject; aCol, aRow: integer;
      aState: TGridDrawState);
  private
    procedure doLogout;
  public
    procedure clearControls;
  end;

var
  formMain: TformMain;
  mouseButtonDown: boolean = False;
  mouseX, mouseY: integer;

  // variabel untuk monitor hardware dan koneksi jaringan
  cekIMEI: boolean = False;
  cekInternet: boolean = False;
  cekBroadcastPool: boolean = False;
  cekPesanOndemandUnconfirmed: boolean = False;
  cekSMSPool: boolean = False;
  terkoneksiInternet: boolean = False;

  threadCount: integer = 0;
  retryCount: integer = 1;

  pnlEnabled: boolean = True;

  kontak: TStringList;
  kontakStakeholder: TStringList;



implementation

uses
  frmlogin, frmMonitoring, frmmessaging, frmpengaturan, frmmanajementki,
  frmondemand, frmsmslokal;

{$R *.lfm}

{ TformMain }
procedure TformMain.clearControls;
begin
  while pnlContent.ControlCount > 0 do
    pnlContent.Controls[pnlContent.ControlCount - 1].Parent := nil;
end;



procedure TformMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  //Application.Terminate;
  //ShowMessage();
  if MessageDlg('Konfirmasi', 'Apakah anda akan keluar?', mtConfirmation,
    mbYesNo, '') = mrYes then
  begin
    formLogin.Show;
    catatLog('pengguna keluar');
  end
  else
    Abort;

end;


procedure TformMain.FormCreate(Sender: TObject);
begin
  Top := 0;
  Left := 0;
  Width := 1024;
  Height := 600;

  //WindowState := wsMaximized;

end;

procedure grow;
var
  i: byte;
begin
  with formMain.pnlLeft do
    if Width < 70 then
      Width := formMain.pnlLeft.Width + 2
    else
      formMain.guiTimer.Enabled := False;

end;

procedure TformMain.FormShow(Sender: TObject);
begin
  //formMonitoring.pnlContent.Parent := pnlContent;
  //formMonitoring.renderListview;

  pnlLeft.Width := 0;
  guiTimer.Enabled := True;
end;

procedure TformMain.guiTimerTimer(Sender: TObject);
begin
  grow;
end;

procedure TformMain.imgMonitorMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  i: integer;
begin
  for i := 0 to pnlLeft.ControlCount - 1 do
    if TImage(pnlLeft.Controls[i]).Tag = 1 then
      TImage(pnlLeft.Controls[i]).Picture.LoadFromFile(
        'data/assets/' + TImage(pnlLeft.Controls[i]).Name + '.png');

  TImage(Sender).Picture.LoadFromFile(ExtractFilePath(Application.ExeName) +
    'data/assets/' + TImage(Sender).Name + '_pressed.png');
  //ShowMessage(TImage(Sender).Name);

  clearControls;

  case TImage(Sender).Name of
    'imgMonitor':
    begin
      formMonitoring.pnlContent.Parent := pnlContent;
      formMonitoring.renderListview;
    end;
    'imgOndemand':
    begin
      formOnDemand.pnlContent.Parent := pnlContent;
      formOnDemand.renderListview;
    end;
    'imgMessaging':
    begin
      formMessaging.pnlContent.Parent := pnlContent;
      formMessaging.renderListView;
    end;
    'imgSettings':
    begin
      formPengaturan.pnlContent.Parent := pnlContent;
      //formTestSMS.ShowModal;
    end;
    'imgManajemenTKI':
    begin
      formManajemenTKI.pnlContent.Parent := pnlContent;
      formManajemenTKI.pnlContent.Show;
      formManajemenTKI.renderListview;
    end;
  end;

end;

procedure TformMain.Label1Click(Sender: TObject);
begin
  if MessageDlg('Konfirmasi', 'Apakah anda akan keluar?', mtConfirmation,
    mbYesNo, '') = mrYes then
  begin
    formLogin.Show;
    catatLog('pengguna keluar');

    // disable seluruh timer
    formOnDemand.Timer1.Enabled := False;
    formMonitoring.Timer1.Enabled := False;
    formPengaturan.Timer1.Enabled := False;
    formSMSLokal.Timer1.Enabled := False;
  end;

end;

procedure TformMain.Label5Click(Sender: TObject);
begin
  pnlLog.Visible := not pnlLog.Visible;
  Splitter1.Visible := pnlLog.Visible;
end;

procedure procCekInternet;
var
  header: TStringList;
  httpsender: THTTPSend;
begin

  header := TStringList.Create;
  header.Add('Accept: text/html');

  httpsender := THTTPSend.Create;
  httpsender.Headers.AddStrings(header);
  //httpsender.KeepAlive := False;
  httpsender.Timeout := 8000;

  try
    if trim(TFPHTTPClient.SimpleGet(LINK_TEST_KONEKSI_KE_SERVER)) =
      'Koneksi berhasil' then
    begin
      TERKONEKSI_KE_SERVER := True;
    end
    else
      TERKONEKSI_KE_SERVER := False;

  except
    on Exception do
      TERKONEKSI_KE_SERVER := False;
  end;

  cekInternet := False;
  httpsender.Free;
end;

procedure listKontak(idSimpulCabang: string);
var
  jData: TJSONData;
  jParser: TJSONParser;
  jString: string;
  jmlData: integer;
  i: integer;
begin

  try
    jString := TFPHTTPClient.SimpleGet(LINK_LIST_NOMOR_TELEPON + '/' + idSimpulCabang);

    try
      jParser := TJSONParser.Create(jString);
      jData := jParser.Parse;

      jmlData := TJSONArray(jData).Count;

      kontak := TStringList.Create;

      for i := 0 to jmlData - 1 do
      begin
        kontak.Add(TJSONObject(TJSONArray(jData).Items[i]).Get('nomor_telepon'));
      end;
    except
      on Exception do
      begin
        // json parsing error
      end;
    end;

  except
    on Exception do
    begin
      // http request failed
    end;
  end;
end;

procedure procCekBroadcastPool;
var
  jParser: TJSONParser;
  jData: TJSONData;
  idSimpulCabang, pesan: string;
  i: integer;
begin
  try
    if StrToInt(trim(TFPHTTPClient.SimpleGet(LINK_JUMLAH_BROADCAST_POOL))) > 0 then
    begin
      jParser := TJSONParser.Create(TFPHTTPClient.SimpleGet(LINK_POP_BROADCAST_POOL));
      jData := jParser.Parse;
      idSimpulCabang := trim(TJSONObject(jData).Get('id_simpul_cabang', '-1'));
      pesan := trim(TJSONObject(jData).Get('pesan', ''));
      listKontak(idSimpulCabang);
      for i := 0 to kontak.Count - 1 do
        gammusendsms(kontak[i], pesan);

      cekBroadcastPool := False;
    end;
  except
    on Exception do
    begin
      cekBroadcastPool := False;
    end;
  end;

  cekBroadcastPool := False;
end;

procedure listKontakStakeholder(idSimpulCabang: string);
var
  jData: TJSONData;
  jParser: TJSONParser;
  jString: string;
  jmlData: integer;
  i: integer;
begin

  try
    jString := TFPHTTPClient.SimpleGet(LINK_LIST_NOMOR_TELEPON_STAKEHOLDER +
      '/' + idSimpulCabang);

    try
      jParser := TJSONParser.Create(jString);
      jData := jParser.Parse;

      jmlData := TJSONArray(jData).Count;

      kontakStakeholder := TStringList.Create;

      for i := 0 to jmlData - 1 do
      begin
        kontakStakeholder.Add(TJSONObject(TJSONArray(jData).Items[i]).Get('nomor_telepon') + ':' + TJSONObject(TJSONArray(jData).Items[i]).Get('username'));
      end;
    except
      on Exception do
      begin
        // json parsing error
      end;
    end;

  except
    on Exception do
    begin
      // http request failed
    end;
  end;

end;

procedure procCekPesanOndemandUnconfirmed;
var
  jParser: TJSONParser;
  jData: TJSONData;
  kodeWilayah, namaWilayah, pesan, nama, usernameStakeholder,
  nomorStakeholder, teksSMS: string;
  i: integer;
begin
  try
    if StrToInt(trim(TFPHTTPClient.SimpleGet(LINK_JUMLAH_PESAN_ONDEMAND_UNCONFIRMED))) >
      0 then
    begin
      // dapatkan informasi wilayah tiap-tiap pengirim
      // pesan ondemand
      jParser := TJSONParser.Create(TFPHTTPClient.SimpleGet(
        LINK_POP_PESAN_ONDEMAND_UNCONFIRMED));
      jData := jParser.Parse;
      namaWilayah := TJSONObject(jData).Get('nama_wilayah');
      kodeWilayah := TJSONObject(jData).Get('kode_wilayah');

      // dapatkan pesan
      pesan := TJSONObject(jData).Get('pesan');
      nama := TJSONObject(jData).Get('nama');

      // list nomor tujuan stakeholder
      // berdasarkan kode wilayah pengirim pesan ondemand
      listKontakStakeholder(kodeWilayah);

      // teruskan SMS ondemand pada stakeholder
      // penanggungjawab
      for i := 0 to kontakStakeholder.Count - 1 do
      begin
        // dapatkan informasi tujuan SMS
        usernameStakeholder :=
          Copy(kontakStakeholder[i], pos(':', kontakStakeholder[i]) +
          1, Length(kontakStakeholder[i]) - pos(':', kontakStakeholder[i]) + 1);
        nomorStakeholder := copy(kontakStakeholder[i], 1,
          pos(':', kontakStakeholder[i]) - 1);

        teksSMS := 'Dear ' + usernameStakeholder + ', ada pesan on-demand dari ' +
          nama + ', wilayah ' + namaWilayah + ': ' + chr(13) + pesan;

        // kirim SMS
        gammusendsms(nomorStakeholder, teksSMS);
      end;

      cekPesanOndemandUnconfirmed := False;
    end;
  except
    on Exception do
    begin
      cekPesanOndemandUnconfirmed := False;
    end;
  end;
  cekPesanOndemandUnconfirmed := False;
end;

procedure procCekSMSPool;
var
  jmlSMSPool: integer;
  jData: TJSONData;
  jParser: TJSONParser;
  pesan, nomorTujuan: ansistring;
begin
  try
    jmlSMSPool := StrToInt(trim(TFPHTTPClient.SimpleGet(LINK_JUMLAH_SMS_POOL)));
    if jmlSMSPool > 0 then
    begin
      jParser := TJSONParser.Create(TFPHTTPClient.SimpleGet(LINK_POP_SMS_POOL));
      jData := jParser.Parse;
      pesan := TJSONObject(jData).Get('pesan');
      nomorTujuan := TJSONObject(jData).Get('nomor_tujuan');

      // kemudian kirim SMS
      gammusendsms(nomorTujuan, pesan);
    end;
    cekSMSPool := False;
  except
    on Exception do
    begin
      cekSMSPool := False;
    end;
  end;
  cekSMSPool := False;
end;

procedure TformMain.mainTimerTimer(Sender: TObject);
var
  thrConn: TCekKoneksiServerThread;
begin

  // monitor pesan on-demand baru

  // monitor internet
  if not cekInternet then
  begin
    cekInternet := True;
    // thread cek internet
    BeginThread(TThreadFunc(@procCekInternet));
    //thrConn := TCekKoneksiServerThread.Create(True);
    //thrConn.Start;
    threadCount := threadCount + 1;
  end;
  // monitor imei modem
  if not cekIMEI then
  begin
    cekIMEI := True;
    // jalankan thread cek imei
  end;

  //*** update status & indikator

  if TERKONEKSI_KE_SERVER then
  begin
    //pnlContent.Enabled := True;
    if not pnlEnabled then
    begin
      pnlEnabled := True;
      pnlContent.Enabled := True;
      shapeIndicatorServer.FillColor := clLime;
    end;
    pnlLeft.Enabled := True;
    formLogin.Enabled := True;

    retryCount := 1; // reset kembali retry count
  end
  else
  begin
    shapeIndicatorServer.FillColor := clRed;
    pnlEnabled := False;
    pnlLeft.Enabled := False;
    pnlContent.Enabled := False;
    formLogin.Enabled := False;

    catatLog('Terputus dari internet. Mencoba kembali koneksi... (' +
      IntToStr(retryCount) + ')');
    retryCount := retryCount + 1;

  end;

  // cek broadcast pool.
  // berikut aksi yang hanya bisa dilakukan oleh eksekutif
  if ID_SIMPUL_CABANG = '0' then
  begin
    // update pool broadcast
    if not cekBroadcastPool then
    begin
      BeginThread(TThreadFunc(@procCekBroadcastPool));
      cekBroadcastPool := True;
    end;

    // update pesan ondemand yang belum terkonfirmasi
    // setelah itu teruskan pesan pada stakeholder
    if not cekPesanOndemandUnconfirmed then
    begin
      BeginThread(TThreadFunc(@procCekPesanOndemandUnconfirmed));
      cekPesanOndemandUnconfirmed := True;
    end;

    // cek SMS pool
    if not cekSMSPool then
    begin
      BeginThread(TThreadFunc(@procCekSMSPool));
      cekSMSPool := True;
    end;
  end;
end;


procedure TformMain.MenuItem1Click(Sender: TObject);
begin
  memoLog.Clear;
end;


procedure TformMain.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if button = mbLeft then
  begin
    mouseButtonDown := True;
    mouseX := X;
    mouseY := Y;
  end;
end;

procedure TformMain.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
begin
  if mouseButtonDown then
  begin
    self.Left := self.Left + X - mouseX;
    self.Top := self.Top + Y - mouseY;
  end;
end;

procedure TformMain.Panel1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  mouseButtonDown := False;
end;

procedure TformMain.Panel1Resize(Sender: TObject);
begin
  imgAnimation.Left := (formMain.Width div 2) - (imgAnimation.Width div 2);
end;

procedure TformMain.pnlLeftResize(Sender: TObject);
begin
  imgShade.Height := pnlLeft.Height;
end;

procedure TformMain.StringGrid1PrepareCanvas(Sender: TObject;
  aCol, aRow: integer; aState: TGridDrawState);
begin
  //if odd(arow) then
  //  StringGrid1.Canvas.Brush.Color := clRed;
end;

procedure TformMain.doLogout;
begin
  if MessageDlg('Konfirmasi', 'Apakah anda akan keluar?', mtConfirmation,
    mbYesNo, '') = mrYes then
  begin
    //if Self.Showing;
  end;
end;


end.
