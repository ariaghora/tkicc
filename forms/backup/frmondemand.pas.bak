unit frmondemand;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, StdCtrls, Buttons, fphttpclient, fpjson, jsonparser,
  globals, json2lv, threadutils;

type

  { TformOnDemand }

  TformOnDemand = class(TForm)
    ListView1: TListView;
    pnlContent: TPanel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    procedure renderListview;
    procedure init;
  end;

var
  formOnDemand: TformOnDemand;
  jumlahPesanOnDemandSekarang: integer = 0;
  jumlahPesanOnDemandRemote: integer = 0;

  cekJumlah: boolean = False;

implementation

{$R *.lfm}

{ TformOnDemand }

procedure TformOnDemand.FormCreate(Sender: TObject);
begin
  //init;

end;

procedure setJumlahPesanOndemand;
begin
  try
    jumlahPesanOnDemandRemote :=
      StrToInt(trim(TFPHTTPClient.SimpleGet(LINK_JUMLAH_PESAN_ONDEMAND +
      '/' + ID_SIMPUL_CABANG)));
    cekJumlah := False;
  except
    on Exception do
    begin
      cekJumlah := False;

    end;
  end;
end;

procedure TformOnDemand.Timer1Timer(Sender: TObject);
begin
  // tunggu thread sebelumnya selesai untuk efisiensi memori
  if not cekJumlah then
  begin
    cekJumlah := True;
    BeginThread(TThreadFunc(@setJumlahPesanOndemand));
  end;

  // jika terdapat pesan on-demand baru di server, tampilkan pesan
  if jumlahPesanOnDemandRemote > jumlahPesanOnDemandSekarang then
  begin
    MessageDlg('Pesan Darurat', 'Mohon cek halaman Pesan On-Demand', mtWarning, [mbOK], '');
    renderListview;
  end;
end;

procedure doRender;
begin
  try
    renderJSON2ListView(TFPHTTPClient.SimpleGet(
      LINK_LIST_PESAN_ONDEMAND + '/' + ID_SIMPUL_CABANG),
      formOndemand.ListView1);
  except
    on Exception do
    begin
    end;
  end;
end;

procedure TformOnDemand.renderListview;
var
  thr: TRenderOndemandReportThread;
begin
  //BeginThread(TThreadFunc(@doRender));
  jumlahPesanOnDemandSekarang := jumlahPesanOnDemandRemote;
  thr := TRenderOndemandReportThread.Create(True);
  thr.lv := ListView1;
  thr.Start;
end;

procedure TformOnDemand.init;
begin
  jumlahPesanOnDemandSekarang := 0;
  jumlahPesanOnDemandRemote := 0;

  try
    jumlahPesanOnDemandSekarang :=
      StrToInt(trim(TFPHTTPClient.SimpleGet(LINK_JUMLAH_PESAN_ONDEMAND +
      '/' + ID_SIMPUL_CABANG)));

    // ShowMessage(TFPHTTPClient.SimpleGet(LINK_JUMLAH_PESAN_ONDEMAND +
    //  '/' + ID_SIMPUL_CABANG));
  except
    on Exception do
    begin
      ShowMessage('Error init');
    end;
  end;

  jumlahPesanOnDemandRemote := jumlahPesanOnDemandSekarang;

  //ShowMessage(IntToStr(jumlahPesanOnDemandSekarang));
  //ShowMessage(IntToStr(jumlahPesanOnDemandRemote));
end;

end.
