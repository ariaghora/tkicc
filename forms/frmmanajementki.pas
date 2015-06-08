unit frmmanajementki;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, StdCtrls, Buttons, threadutils, json2lv;

type

  { TformManajemenTKI }

  TformManajemenTKI = class(TForm)
    ListView1: TListView;
    Panel3: TPanel;
    pnlContent: TPanel;
    SpeedButton1: TSpeedButton;
    procedure ListView1DblClick(Sender: TObject);
  private
    { private declarations }
  public
    procedure renderListview;
  end;

var
  formManajemenTKI: TformManajemenTKI;

implementation

uses
  frmeditdatatki, frmMain;

{$R *.lfm}

{ TformManajemenTKI }

procedure doRender;
begin
  // lalala
end;

procedure TformManajemenTKI.ListView1DblClick(Sender: TObject);
begin
  if ListView1.SelCount > 0 then
  begin
    formEditDataTKI.pnlContent.Show;
    formEditDataTKI.pnlContent.Parent := formMain.pnlContent;
    formEditDataTKI.idTKI := ListView1.Selected.Caption;
    formEditDataTKI.muatInformasi;
    pnlContent.Hide;
  end;
end;

procedure TformManajemenTKI.renderListview;
var
  thr: TRenderTkiThread;
begin
  thr := TRenderTkiThread.Create(True);
  thr.lv := ListView1;
  thr.Start;
end;


end.

