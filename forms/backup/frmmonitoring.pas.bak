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
    ListView1: TListView;
    pnlContent: TPanel;
    Panel3: TPanel;
    SpeedButton1: TSpeedButton;
    procedure ComboBox1Change(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { private declarations }
  public
    procedure renderListview;
  end;

var
  formMonitoring: TformMonitoring;
  renderThread: TRenderRegularReportThread;

implementation

uses
  frmMain, frmDetailTKI;

{$R *.lfm}

{ TformMonitoring }

procedure TformMonitoring.renderListview;
begin
  renderThread := TRenderRegularReportThread.Create(True);
  renderThread.kodeWilayah := ID_SIMPUL_CABANG;
  renderThread.tipeLaporan := IntToStr(ComboBox1.ItemIndex + 1);
  renderThread.lv := ListView1;
  renderThread.Start;
end;

procedure TformMonitoring.SpeedButton1Click(Sender: TObject);
begin
  renderListview;
end;

procedure TformMonitoring.ComboBox1Change(Sender: TObject);
begin
  renderListview;
end;

procedure TformMonitoring.ListView1DblClick(Sender: TObject);
begin
  if ListView1.SelCount > 0 then
  begin
    formDetailTKI.pnlContent.Parent := pnlContent;
    panel3.Hide;
    ListView1.Hide;
  end;
end;

end.

