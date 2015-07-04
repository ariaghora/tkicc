unit frmMonitoring;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, StdCtrls, Buttons, json2lv, fphttpclient, globals, helper, threadutils;

type

  { TformMonitoring }

  TformMonitoring = class(TForm)
    ComboBox1: TComboBox;
    edtSearch: TEdit;
    Image1: TImage;
    ListView1: TListView;
    pnlContent: TPanel;
    Panel3: TPanel;
    SpeedButton1: TSpeedButton;
    Timer1: TTimer;
    procedure ComboBox1Change(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: char);
    procedure ListView1CustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: boolean);
    procedure ListView1DblClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    procedure renderListview;
    procedure init;
    procedure cariTKI(searchString: string);
  end;

  { TMuatInformasiTKIThread }

  TMuatInformasiTKIThread = class(TThread)
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: boolean);
    procedure preRun;
    procedure postRun;
    procedure onFailed;
    procedure onSucceed;
  end;

var
  formMonitoring: TformMonitoring;
  renderThread: TRenderRegularReportThread;
  jumlahSMSMonitor: integer = 0;
  jumlahSMSMonitorServer: integer = 0;
  cekSMSMonitor: boolean = False;

implementation

uses
  frmMain, frmDetailTKI;

{$R *.lfm}

{ TMuatInformasiTKIThread }

procedure TMuatInformasiTKIThread.Execute;
begin
  Synchronize(@preRun);
  //s := TFPHTTPClient.SimpleGet(LINK_LIST_TKI + '/' + ID_SIMPUL_CABANG);

  try
    with formDetailTKI do
    begin
      namaTKI := formMonitoring.ListView1.Selected.Caption;
      idTKI := formMonitoring.ListView1.Selected.SubItems[0];
      nomorTelepon := formMonitoring.ListView1.Selected.SubItems[2];

      nil1 := TFPHTTPClient.SimpleGet(LINK_NILAI_TERBARU + '/' + idTKI + '/1');
      nil2 := TFPHTTPClient.SimpleGet(LINK_NILAI_TERBARU + '/' + idTKI + '/2');
      nil3 := TFPHTTPClient.SimpleGet(LINK_NILAI_TERBARU + '/' + idTKI + '/3');
      nil4 := TFPHTTPClient.SimpleGet(LINK_NILAI_TERBARU + '/' + idTKI + '/4');
      nil5 := TFPHTTPClient.SimpleGet(LINK_NILAI_TERBARU + '/' + idTKI + '/5');
      dataSMS := TFPHTTPClient.SimpleGet(LINK_LIST_SMS_BY_PENGIRIM + '/' + idTKI);


      Synchronize(@onSucceed);
    end;

    Synchronize(@postRun);

  except
    on Exception do
    begin
      Synchronize(@onFailed);
      Synchronize(@postRun);
    end;
  end;
end;

constructor TMuatInformasiTKIThread.Create(CreateSuspended: boolean);
begin
  freeOnTerminate := True;
  inherited Create(CreateSuspended);
end;

procedure TMuatInformasiTKIThread.preRun;
begin
  formMain.pnlContent.Enabled := False;
  formMain.imgAnimation.Show;
  catatLog('memuat detail TKI' + ID_SIMPUL_CABANG);
end;

procedure TMuatInformasiTKIThread.postRun;
begin
  formMain.imgAnimation.Hide;
  //if TERKONEKSI_KE_SERVER then
  begin
    formMain.pnlContent.Enabled := True;
    catatLog('detail TKI dimuat');
  end;

end;

procedure TMuatInformasiTKIThread.onFailed;
begin
  ShowMessage('Gagal memuat detail TKI.');
end;

function charInttoterbilang(i: string): string;
begin
  case i of
    '1': Result := 'Sangat Buruk';
    '2': Result := 'Buruk';
    '3': Result := 'Cukup Baik';
    '4': Result := 'Baik';
    '5': Result := 'Sangat Baik';
  end;
end;

procedure TMuatInformasiTKIThread.onSucceed;
begin
  with formDetailTKI do
  begin
    pnlContent.Parent := formMonitoring.pnlContent;

    lblNama.Caption := namaTKI;
    bar1.Value := StrToInt(Trim(nil1));
    bar2.Value := StrToInt(Trim(nil2));
    bar3.Value := StrToInt(Trim(nil3));
    bar4.Value := StrToInt(Trim(nil4));
    bar5.Value := StrToInt(Trim(nil5));

    lblHakPRT.Caption := charInttoterbilang(nil1);
    lblHakJamKerja.Caption := charInttoterbilang(nil2);
    lblHakInfo.Caption := charInttoterbilang(nil3);
    lblHakUpah.Caption := charInttoterbilang(nil4);
    lblHakKeselamatan.Caption := charInttoterbilang(nil5);

    refreshLogSMS;

    formMonitoring.panel3.Hide;
    formMonitoring.ListView1.Hide;

  end;
end;

{ TformMonitoring }


procedure TformMonitoring.renderListview;
begin
  renderThread := TRenderRegularReportThread.Create(True);
  renderThread.kodeWilayah := ID_SIMPUL_CABANG;
  renderThread.tipeLaporan := IntToStr(ComboBox1.ItemIndex + 1);
  renderThread.lv := ListView1;
  renderThread.searchString := trim(edtSearch.Text);
  renderThread.Start;
end;

procedure TformMonitoring.init;
begin
  try
    jumlahSMSMonitor := StrToInt(TFPHTTPClient.SimpleGet(LINK_JUMLAH_SMS_MONITOR));
  except
    on Exception do
    begin
    end;
  end;
end;

procedure TformMonitoring.cariTKI(searchString: string);
var
  i, j: integer;
  bool: boolean;
begin
  renderListview;
end;

procedure TformMonitoring.SpeedButton1Click(Sender: TObject);
begin
  renderListview;
end;

procedure procCekSMSMonitor;
begin
  try
    jumlahSMSMonitorServer := StrToInt(
      trim(TFPHTTPClient.SimpleGet(LINK_JUMLAH_SMS_MONITOR)));
  except
    on Exception do
    begin
      cekSMSMonitor := False;
    end;
  end;
  cekSMSMonitor := False;
end;


procedure TformMonitoring.Timer1Timer(Sender: TObject);
begin
  // monitor sms monitor
  if not cekSMSMonitor then
  begin
    cekSMSMonitor := True;
    BeginThread(TThreadFunc(@procCekSMSMonitor));
    if jumlahSMSMonitorServer > jumlahSMSMonitor then
    begin
      // refresh tabel
      renderListview;
      jumlahSMSMonitor := jumlahSMSMonitorServer;
    end;
  end;
end;

procedure TformMonitoring.ComboBox1Change(Sender: TObject);
begin
  renderListview;
end;

procedure TformMonitoring.edtSearchKeyPress(Sender: TObject; var Key: char);
begin
  if key = char(13) then
    cariTKI(edtSearch.Text);
end;

procedure TformMonitoring.ListView1CustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: boolean);
var
  rct: TRect;
begin
  {$IFDEF LINUX}
  DefaultDraw := False;
  {$ENDIF}
  rct := Item.DisplayRect(drLabel);

  Sender.Canvas.Brush.Color := clNone;
  Sender.Canvas.Font.Color := clBlack;
  Sender.Canvas.Font.Style := [];

  if item.SubItems.Count > 1 then
    case Item.SubItems[1] of
      '1':
      begin
        Sender.Canvas.Brush.Color := RGBToColor(183, 13, 67);
        Sender.Canvas.Font.Color := clWhite;
        Sender.Canvas.Font.Style := [fsBold];
      end;
      '2':
      begin
        Sender.Canvas.Brush.Color := RGBToColor(218, 74, 120);
        Sender.Canvas.Font.Color := clWhite;
      end;
      '3':
        Sender.Canvas.Brush.Color := RGBToColor(247, 164, 191);
      '4':
        Sender.Canvas.Brush.Color := RGBToColor(255, 208, 223);
    end;

  Sender.Canvas.FillRect(rct.Left - 2, rct.Top - 2, rct.Right, rct.Bottom);
  Sender.Canvas.TextOut(rct.Left + 2, rct.Top + 2, Item.Caption);

end;

procedure TformMonitoring.ListView1DblClick(Sender: TObject);
var
  t: TMuatInformasiTKIThread;
begin
  if ListView1.SelCount > 0 then
  begin
    t := TMuatInformasiTKIThread.Create(True);
    t.Start;
  end;
end;

end.
