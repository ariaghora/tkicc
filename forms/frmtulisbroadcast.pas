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
    Memo1: TMemo;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
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

  //ShowMessage(TFPHTTPClient.SimpleGet(LINK_LIST_NOMOR_TELEPON + '/' + ID_SIMPUL_CABANG));

  //BeginThread(TThreadFunc(@listKontak));
end;

procedure TformTulisBroadcast.FormCreate(Sender: TObject);
begin
  kontak := TStringList.Create;

end;

procedure TformTulisBroadcast.SpeedButton1Click(Sender: TObject);
var
  pesan: string;
  jData: TJSONData;
  jParser: TJSONParser;
  i: integer;
begin
  pesan := EncodeURLElement(Memo1.Text);

  listKontak;

  if kontak.Count <= 0 then
    ShowMessage('Daftar nomor tujuan kosong.')
  else

  if TFPHTTPClient.SimpleGet(LINK_KIRIM_BROADCAST + '.php?pesan=' +
    pesan + '&id_stakeholder=' + USER_ID) = '1' then
  begin
    memo1.Clear;
    self.Close;

    { TODO 666 -oghora : bulk sms berdasarkan list kontak. Yang di bawah ini cuma sementara }
    for i := 0 to kontak.Count - 1 do
    begin

      if TFPHTTPClient.SimpleGet(LINK_TULIS_BROADCAST + '.php?nomor_tujuan=' +
        kontak[i] + '&pesan=' + pesan) = '1' then
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


    formMessaging.renderListView;
  end
  else
  begin
    ShowMessage('Sesi pengiriman broadcast gagal');
  end;
end;

end.
