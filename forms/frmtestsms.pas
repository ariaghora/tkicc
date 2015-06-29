unit frmtestsms;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, fphttpclient, globals, synacode, helper;

type

  { TformTestSMS }

  TformTestSMS = class(TForm)
    Edit1: TEdit;
    Memo1: TMemo;
    SpeedButton1: TSpeedButton;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
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

  //pesan := EncodeURLElement(Memo1.Text);
  //if TFPHTTPClient.SimpleGet(LINK_TULIS_BROADCAST + Edit1.Text + '/' +
  //  pesan) = '1' then
  if gammusendsms(edit1.Text, memo1.Text) = '1' then
  begin
    ShowMessage('Pengiriman sedang berlangsung.');
    Edit1.Clear;
    Memo1.Clear;
    Close;
  end;

  //gammusendsms('085785437367', memo1.Text);

end;

procedure TformTestSMS.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Edit1.Enabled := True;
end;

end.


