unit frmtestsms;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, fphttpclient, globals, synacode;

type

  { TformTestSMS }

  TformTestSMS = class(TForm)
    Edit1: TEdit;
    Memo1: TMemo;
    SpeedButton1: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  formTestSMS: TformTestSMS;

implementation

{$R *.lfm}

{ TformTestSMS }

procedure TformTestSMS.SpeedButton1Click(Sender: TObject);
var
  pesan: string;
begin
  pesan := EncodeURLElement(Memo1.Text);
  if TFPHTTPClient.SimpleGet(LINK_TULIS_BROADCAST + Edit1.Text + '/' +
    pesan) = '1' then
  begin
    ShowMessage('Pengiriman sedang berlangsung.');
    Edit1.Clear;
    Memo1.Clear;
  end;
end;

end.

