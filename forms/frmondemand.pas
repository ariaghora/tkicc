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
  try
    jumlahPesanOnDemandSekarang :=
      StrToInt(TFPHTTPClient.SimpleGet(LINK_JUMLAH_PESAN_ONDEMAND));
  except
    on Exception do ;
  end;

end;

procedure setJumlahPesanOndemand;
begin
  try
    jumlahPesanOnDemandRemote :=
      StrToInt(trim(TFPHTTPClient.SimpleGet(LINK_JUMLAH_PESAN_ONDEMAND)));
    cekJumlah := False;
  except
    on Exception do
    begin
    end;
  end;
end;

procedure TformOnDemand.Timer1Timer(Sender: TObject);
begin

  if not cekJumlah then
  begin
    cekJumlah := True;
    BeginThread(TThreadFunc(@setJumlahPesanOndemand));
  end;

  if jumlahPesanOnDemandRemote > jumlahPesanOnDemandSekarang then
  begin
    renderListview;
  end;

end;

procedure doRender;
begin
  try
    renderJSON2ListView(TFPHTTPClient.SimpleGet(LINK_LIST_PESAN_ONDEMAND),
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

end.
