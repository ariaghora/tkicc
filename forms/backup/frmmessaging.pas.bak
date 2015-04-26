unit frmmessaging;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, ComCtrls, threadutils, globals;

type

  { TformMessaging }

  TformMessaging = class(TForm)
    ListView1: TListView;
    Panel3: TPanel;
    pnlContent: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { private declarations }
  public
    procedure renderListView;
  end;

var
  formMessaging: TformMessaging;

implementation

uses
  frmTulisBroadcast;

{$R *.lfm}

{ TformMessaging }

procedure TformMessaging.SpeedButton2Click(Sender: TObject);
begin
  renderListView;
end;

procedure TformMessaging.SpeedButton1Click(Sender: TObject);
begin
  formTulisBroadcast.ShowModal;
end;

procedure TformMessaging.renderListView;
var
  thread: TRenderBroadcastMessage;
begin
  thread := TRenderBroadcastMessage.Create(True);
  thread.kodeWilayah := ID_SIMPUL_CABANG;
  thread.lv := ListView1;
  thread.Start;

end;

end.
