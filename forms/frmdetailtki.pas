unit frmDetailTKI;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls, PairSplitter,
  BGRAFlashProgressBar, json2lv, types, TACustomSeries, TALegendPanel,
  fpjson, jsonparser, fphttpclient, globals;

type

  { TformDetailTKI }

  TformDetailTKI = class(TForm)
    bar1: TBGRAFlashProgressBar;
    bar2: TBGRAFlashProgressBar;
    bar3: TBGRAFlashProgressBar;
    bar4: TBGRAFlashProgressBar;
    bar5: TBGRAFlashProgressBar;
    Button1: TButton;
    Chart1: TChart;
    cb1: TCheckBox;
    cb2: TCheckBox;
    cb3: TCheckBox;
    cb4: TCheckBox;
    cb5: TCheckBox;
    seriesJK: TLineSeries;
    seriesPIP: TLineSeries;
    seriesUpah: TLineSeries;
    seriesKK: TLineSeries;
    seriesPRT: TLineSeries;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lbl: TLabel;
    Label6: TLabel;
    lblHakInfo: TLabel;
    lblHakJamKerja: TLabel;
    lblHakKeselamatan: TLabel;
    lblHakPRT: TLabel;
    lblHakUpah: TLabel;
    lblNama: TLabel;
    ListView1: TListView;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    pnlContent: TPanel;
    ScrollBox1: TScrollBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Splitter1: TSplitter;
    procedure Button1Click(Sender: TObject);
    procedure cb1Change(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { private declarations }
  public
    jString: string;
    namaTKI: string;
    idTKI, nomorTelepon: string;
    nil1, nil2, nil3, nil4, nil5: string;
    dataSMS: ansistring;
    procedure refreshLogSMS;
    procedure gambarSeries(arr: TJSONArray; series: TLineSeries);
    procedure refreshGrafik;
  end;

var
  formDetailTKI: TformDetailTKI;



implementation

uses
  frmMonitoring, frmtestsms;

{$R *.lfm}

{ TformDetailTKI }

procedure TformDetailTKI.SpeedButton1Click(Sender: TObject);
begin
  //ShowMessage(pnlContent.Parent.Name);
  pnlContent.Parent := nil;
  //pnlContent.Hide;
  formMonitoring.Panel3.Show;
  formMonitoring.ListView1.Show;

end;

procedure TformDetailTKI.Button1Click(Sender: TObject);
begin
  formTestSMS.Edit1.Enabled := False;
  formTestSMS.Edit1.Text := nomorTelepon;
  formTestSMS.ShowModal;
end;

procedure TformDetailTKI.cb1Change(Sender: TObject);
begin
  refreshGrafik;
end;

function getJSONArrayByKodeLaporan(kodeLaporan: string): TJSONArray;
var
  jParser: TJSONParser;
  jData: TJSONData;
begin
  jParser := TJSONParser.Create(TFPHTTPClient.SimpleGet(
    LINK_DATA_GRAFIK + '?id_tki=' + formDetailTKI.idTKI + '&kode_laporan=' +
    kodeLaporan));
  jData := jParser.Parse;
  Result := TJSONArray(jData);
end;

procedure TformDetailTKI.SpeedButton2Click(Sender: TObject);
begin
  refreshLogSMS;
end;

procedure TformDetailTKI.refreshLogSMS;
begin
  renderJSON2ListView(dataSMS, ListView1);
end;

procedure TformDetailTKI.gambarSeries(arr: TJSONArray; series: TLineSeries);
var
  i: integer;
begin
  for i := 0 to arr.Count - 1 do
  begin
    series.AddXY(TJSONObject(arr[i]).Get('hari'),
      TJSONObject(arr[i]).Get('nilai'));
  end;
end;

procedure TformDetailTKI.refreshGrafik;
const
  N = 366;
  MIN = 0;
  MAX = 30;
var
  i: integer;
  x: double;
  y: double;
  jPRT, jJK, jPIP, jUpah, jKK: TJSONArray;
begin

  // bersihkan series
  seriesPRT.Clear;
  seriesJK.Clear;
  seriesPIP.Clear;
  seriesUpah.Clear;
  seriesKK.Clear;


  // dapatkan masing-masing
  try
    jPRT := getJSONArrayByKodeLaporan('1');
    jJK := getJSONArrayByKodeLaporan('2');
    jPIP := getJSONArrayByKodeLaporan('3');
    jUpah := getJSONArrayByKodeLaporan('4');
    jKK := getJSONArrayByKodeLaporan('5');
  except
    on Exception do
    begin
      // asdasd
      ShowMessage('Gagal muat data grafik.');
    end;
  end;

  if cb1.Checked then
    gambarSeries(jPRT, seriesPRT);
  if cb2.Checked then
    gambarSeries(jJK, seriesJK);
  if cb3.Checked then
    gambarSeries(jPIP, seriesPIP);
  if cb4.Checked then
    gambarSeries(jUpah, seriesUpah);
  if cb5.Checked then
    gambarSeries(jKK, seriesKK);

end;

end.
