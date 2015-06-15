unit frmTulisBroadcast;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, globals, synacode, fphttpclient, fpjson, jsonparser, process, helper;

type

  { TformTulisBroadcast }

  TformTulisBroadcast = class(TForm)
    Label1: TLabel;
    lblCounter: TLabel;
    Memo1: TMemo;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  formTulisBroadcast: TformTulisBroadcast;
  kontak: TStringList;
  jString: string = '';

implementation

uses
  frmmessaging;

{$R *.lfm}

{ TformTulisBroadcast }

procedure listKontak;
var
  jData: TJSONData;
  jParser: TJSONParser;
  jmlData: integer;
  i: integer;
begin

  try
    jString := TFPHTTPClient.SimpleGet(LINK_LIST_NOMOR_TELEPON + '/' + ID_SIMPUL_CABANG);

    try
      jParser := TJSONParser.Create(jString);
      jData := jParser.Parse;

      jmlData := TJSONArray(jData).Count;

      kontak := TStringList.Create;

      for i := 0 to jmlData - 1 do
      begin
        kontak.Add(TJSONObject(TJSONArray(jData).Items[i]).Get('nomor_telepon'));
        //kontak.Add(IntToStr(jmlData));
      end;


    except
      on Exception do
      begin
        // json parsing error
      end;
    end;


  except
    on Exception do
    begin
      // http request failed
      ShowMessage('Gagal memuat daftar nomor tujuan.');
    end;
  end;

end;

procedure TformTulisBroadcast.FormShow(Sender: TObject);
begin
  Label1.Caption := 'Mengirim Sebagai: ' + USER_NAME;
end;

procedure TformTulisBroadcast.Memo1Change(Sender: TObject);
begin
  lblCounter.Caption := IntToStr(Length(Memo1.Text));
end;

procedure TformTulisBroadcast.FormCreate(Sender: TObject);
begin
  kontak := TStringList.Create;

end;

procedure TformTulisBroadcast.SpeedButton1Click(Sender: TObject);
var
  pesan, pesanEncoded: string;
  jData: TJSONData;
  jParser: TJSONParser;
  i: integer;
begin
  pesan := Memo1.Text;
  pesanEncoded := EncodeURLElement(pesan);

  // mengisi daftar nomor tujuan
  // dengan HTTP request
  listKontak;

  if kontak.Count <= 0 then
    ShowMessage('Daftar nomor tujuan kosong.')
  else

  // jika berhasil
  if TFPHTTPClient.SimpleGet(LINK_KIRIM_BROADCAST + '.php?pesan=' +
    pesanEncoded + '&id_stakeholder=' + USER_ID) = '1' then
  begin
    memo1.Clear;
    self.Close;

    for i := 0 to kontak.Count - 1 do
    begin
      if gammusendsms(kontak[i], pesan) = '1' then
      begin
        // success message
        catatLog('pesan dikirimkan ke nomor ' + kontak[i]);
      end
      else
      begin
        // failure warning
        ShowMessage('Terdapat kesalahan dalam sesi pengiriman broadcast.');
      end;
    end;

    // refresh tabel pesan broadcast
    formMessaging.renderListView;
  end
  else
  begin
    ShowMessage('Sesi pengiriman broadcast gagal');
  end;
end;

end.
