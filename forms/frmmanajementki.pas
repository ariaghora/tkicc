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
  private
    { private declarations }
  public
    procedure renderListview;
  end;

var
  formManajemenTKI: TformManajemenTKI;

implementation

{$R *.lfm}

{ TformManajemenTKI }

procedure doRender;
begin
  // lalala
end;

procedure TformManajemenTKI.renderListview;
var
  thr:TRenderTkiThread;
begin
  thr:=TRenderTkiThread.Create(true);
  thr.lv:=ListView1;
  thr.Start;
end;


end.

