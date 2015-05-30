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
    procedure ComboBox1Change(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: char);
    procedure ListView1CustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: boolean);
    procedure ListView1DblClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { private declarations }
  public
    procedure renderListview;
    procedure cariTKI(searchString: string);
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
  renderThread.searchString := trim(edtSearch.Text);
  renderThread.Start;
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
  DefaultDraw := False;
  rct := Item.DisplayRect(drLabel);

  Sender.Canvas.Brush.Color := clNone;
  Sender.Canvas.Font.Color := clBlack;
  Sender.Canvas.Font.Style := [];

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
begin
  if ListView1.SelCount > 0 then
  begin
    formDetailTKI.pnlContent.Parent := pnlContent;
    panel3.Hide;
    ListView1.Hide;
  end;
end;

end.
