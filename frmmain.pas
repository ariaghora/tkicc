unit frmMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, Controls, SysUtils, Graphics, Dialogs, LCLType, ExtCtrls,
  ComCtrls, StdCtrls, Grids, Buttons, fphttpclient, fpjson, jsonparser, helper,
  globals, json2lv, BGRASpriteAnimation, BGRAShape, threadutils, process, Math, httpsend;

type

  { TformMain }

  TformMain = class(TForm)
    Label3: TLabel;
    Label4: TLabel;
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
    //procedure Button1Click(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgMonitorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure Label1Click(Sender: TObject);
    procedure mainTimerTimer(Sender: TObject);
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
  terkoneksiInternet: boolean = False;

  threadCount: integer = 0;


implementation

uses
  frmlogin, frmMonitoring, frmmessaging, frmpengaturan, frmmanajementki;

{$R *.lfm}

{ TformMain }
procedure TformMain.clearControls;
begin
  while pnlContent.ControlCount > 0 do
    pnlContent.Controls[pnlContent.ControlCount - 1].Parent := nil;
end;

procedure TformMain.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_STATICEDGE;
  Params.Style := Params.Style or WS_SIZEBOX;
end;

{
procedure TformMain.Button1Click(Sender: TObject);
var
  header: TStringList;
  httpsender: THTTPSend;
begin

  header := TStringList.Create;
  header.Add('Accept: text/html');

  httpsender := THTTPSend.Create;
  httpsender.Headers.AddStrings(header);
  httpsender.KeepAlive := False;

  if httpsender.HTTPMethod('GET', 'http://www.tkicc.16mb.com') then
    ShowMessage('YAY')
  else
    ShowMessage('NAY');
  {
  if TERKONEKSI_KE_SERVER then
    ShowMessage('OK')
  else
    ShowMessage('NGA OKE');
    }

end;
}


procedure TformMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  //Application.Terminate;
  //ShowMessage();
  if MessageDlg('Konfirmasi', 'Apakah anda akan keluar?', mtConfirmation,
    mbYesNo, '') = mrYes then
  begin
    formLogin.Show;
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

procedure TformMain.FormShow(Sender: TObject);
begin
  formMonitoring.pnlContent.Parent := pnlContent;
  formMonitoring.renderListview;
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
    end;
  end;

end;

procedure TformMain.Label1Click(Sender: TObject);
begin
  if MessageDlg('Konfirmasi', 'Apakah anda akan keluar?', mtConfirmation,
    mbYesNo, '') = mrYes then
  begin
    formLogin.Show;
  end;

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
  httpsender.Timeout := 5000;

  if httpsender.HTTPMethod('GET', 'http://www.tkicc.16mb.com') then
  begin
    if httpsender.ResultCode <= 302 then
      TERKONEKSI_KE_SERVER := True
    else
      TERKONEKSI_KE_SERVER := False;
  end
  else
    TERKONEKSI_KE_SERVER := False;
  //else


  cekInternet := False;
  httpsender.Free;
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

  // update status & indikator

  if TERKONEKSI_KE_SERVER then
  begin
    shapeIndicatorServer.FillColor := clLime;
    //formMain.Enabled := True;
    pnlLeft.Enabled := True;
    pnlContent.Enabled := True;
  end
  else
  begin
    shapeIndicatorServer.FillColor := clRed;
    //formMain.Enabled := False;
    pnlLeft.Enabled := False;
    pnlContent.Enabled := False;
  end;

  //button1.Caption := IntToStr(threadCount);

end;

procedure ResizeCol(AGrid: TStringGrid; const ACol: integer);
const
  MIN_COL_WIDTH = 15;
var
  M, T: integer;
  X: integer;
begin
  M := MIN_COL_WIDTH;
  AGrid.Canvas.Font.Assign(AGrid.Font);
  for X := 1 to AGrid.RowCount - 1 do
  begin
    T := AGrid.Canvas.TextWidth(AGrid.Cells[ACol, X]);
    if T > M then
      M := T;
  end;
  AGrid.ColWidths[ACol] := M + MIN_COL_WIDTH;
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
