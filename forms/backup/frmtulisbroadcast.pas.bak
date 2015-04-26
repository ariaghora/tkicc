unit frmTulisBroadcast;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, globals, synacode, fphttpclient;

type

  { TformTulisBroadcast }

  TformTulisBroadcast = class(TForm)
    Label1: TLabel;
    Memo1: TMemo;
    SpeedButton1: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  formTulisBroadcast: TformTulisBroadcast;

implementation

uses
  frmmessaging;

{$R *.lfm}

{ TformTulisBroadcast }

procedure TformTulisBroadcast.FormShow(Sender: TObject);
begin
  Label1.Caption := 'Mengirim Sebagai: ' + USER_NAME;
end;

procedure TformTulisBroadcast.SpeedButton1Click(Sender: TObject);
var
  pesan: string;
begin
  pesan := EncodeURLElement(Memo1.Text);
  ShowMessage(LINK_KIRIM_BROADCAST + pesan + '/' + USER_ID);
  if TFPHTTPClient.SimpleGet(LINK_KIRIM_BROADCAST + pesan + '/' + USER_ID) = '1' then
  begin
    memo1.Clear;
    self.Close;
    // run smsBroadcast();

    formMessaging.renderListView;
  end
  else
  begin
    ShowMessage('Pengiriman broadcast gagal');
  end;
end;

end.
