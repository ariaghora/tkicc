unit frmMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, Controls, SysUtils, Graphics, Dialogs, LCLType, ExtCtrls,
  ComCtrls, StdCtrls, Grids, Buttons, fphttpclient, fpjson, jsonparser, helper,
  globals, json2lv, BGRASpriteAnimation, threadutils, process, Math;

type

  { TformMain }

  TformMain = class(TForm)
    imgAnimation: TBGRASpriteAnimation;
    Image1: TImage;
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
    pnlLeft: TPanel;
    pnlContent: TPanel;
    Panel8: TPanel;
    mainTimer: TTimer;
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
  public
    procedure clearControls;
  end;

var
  formMain: TformMain;
  mouseButtonDown: boolean = False;
  mouseX, mouseY: integer;

  // variabel untuk monitor hardware
  cekIMEI: boolean = False;


implementation

uses
  frmlogin, frmMonitoring, frmmessaging, frmpengaturan;

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

procedure TformMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Application.Terminate;
end;

procedure TformMain.FormCreate(Sender: TObject);
begin
  Top := 0;
  Left := 0;
  Width := 1024;
  Height := 500;
  //FormStyle := fsStayOnTop;
  //ListView1.OwnerDraw := True;

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

  TImage(Sender).Picture.LoadFromFile('data/assets/' + TImage(Sender).Name +
    '_pressed.png');
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
      formPengaturan.pnlContent.Parent:=pnlContent;
      //formTestSMS.ShowModal;
    end;
  end;

end;

procedure TformMain.Label1Click(Sender: TObject);
begin
  formLogin.Show;
end;

procedure TformMain.mainTimerTimer(Sender: TObject);
begin
  // monitor pesan on-demand baru

  // monitor imei modem
  if not cekIMEI then
  begin
    // jalankan thread cek imei
  end;
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


end.
