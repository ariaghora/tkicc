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

  // pastikan pengirim adalah eksekutif
  if ID_SIMPUL_CABANG = '0' then
  begin
    if gammusendsms(edit1.Text, memo1.Text) = '1' then
    begin
      ShowMessage('Pengiriman sedang berlangsung.');
      Edit1.Clear;
      Memo1.Clear;
      Close;
    end;
  end

  else
  begin
    try
      if trim(TFPHTTPClient.SimpleGet(LINK_POOL_SMS + '?pesan=' +
        EncodeURLElement(Memo1.Text) + '&nomor_tujuan=' +
        EncodeURLElement(Edit1.Text))) = '0' then
      begin
        ShowMessage('Pengiriman gagal. Cek koneksi internet');
      end
      else
      begin
        ShowMessage('Pengiriman sedang berlangsung');
        Close;
      end;
    except
      on Exception do
      begin
      end;
    end;
  end;

  //gammusendsms('085785437367', memo1.Text);


end;

procedure TformTestSMS.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Edit1.Enabled := True;
end;

end.
