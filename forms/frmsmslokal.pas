unit frmsmslokal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, StdCtrls, json2lv, fphttpclient, globals, fpjson, jsonparser, process;

type

  { TformSMSLokal }

  TformSMSLokal = class(TForm)
    Label1: TLabel;
    ListView1: TListView;
    Panel1: TPanel;
    Timer1: TTimer;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    procedure refreshList;
    procedure poolSMSBaru;
    procedure pushSMSLokal;
  public
    procedure init;
  end;

var
  formSMSLokal: TformSMSLokal;
  isNewSMS: boolean = False;
  isPushing: boolean = False;

  isThreadRunning: boolean = False;
  strJSON: string;
  jmlItem: integer;
  jmlItemTerupdate: integer;

implementation

{$R *.lfm}

{ TformSMSLokal }

procedure TformSMSLokal.FormShow(Sender: TObject);
begin
  //Timer1.Enabled := True;
end;

procedure notifikasi;
var
  s: string;
begin
  RunCommand('notify-send "TKICC" "SMS Baru" -i mail-unread', s);
end;

procedure TformSMSLokal.Timer1Timer(Sender: TObject);
begin
  // update dan push sms lokal
  if not isPushing then
  begin
    isPushing := True;
    pushSMSLokal;
  end;

  // pool sms remote baru
  poolSMSBaru;

  if isNewSMS then
  begin
    // notifikasi
    // notifikasi;

    // refresh list
    refreshList;

    // tak ada sms baru lagi
    isNewSMS := False;
  end;

  // update status
  //Label1.Caption := 'item sekarang: ' + IntToStr(jmlItem) + ', item terbaru: ' +
  //  IntToStr(jmlItemTerupdate);
end;

procedure TformSMSLokal.refreshList;
var
  jParser: TJSONParser;
  jData: TJSONData;
begin
  try
    strJSON := TFPHTTPClient.SimpleGet(LINK_LIST_SMS_REMOTE);
    jParser := TJSONParser.Create(strJSON);
    jData := jParser.Parse;

    jmlItem := TJSONArray(jData).Count;

    renderJSON2ListView(strJSON, ListView1);

    jParser.Free;

  except
    on Exception do
    begin
      // do nothing, cuk
    end;
  end;

end;

procedure setJmlItemSekarang;
var
  jParser: TJSONParser;
  jData: TJSONData;
begin

  // jmlItemTerupdate := StrToInt(TFPHTTPClient.SimpleGet(LINK_JUMLAH_SMS_REMOTE));
  try
    jmlItemTerupdate := StrToInt(TFPCustomHTTPClient.SimpleGet(LINK_JUMLAH_SMS_REMOTE));
  except
    on Exception do
    begin

    end;
  end;
  isThreadRunning := False;

end;

procedure TformSMSLokal.poolSMSBaru;
begin
  if not isThreadRunning then
  begin
    isThreadRunning := True;
    // panggil thread untuk perbaharui jmlItemSekarang
    BeginThread(TThreadFunc(@setJmlItemSekarang));

    // kemudian bandingkan list
    if jmlItemTerupdate > jmlItem then
    begin
      isNewSMS := True;
      jmlItem := jmlItemTerupdate;
    end;
  end;

end;

procedure TformSMSLokal.pushSMSLokal;
var
  totalSMSLokal: integer;
  tmpRow: string;
  id: string;
  nomorPengirim: string;
  pesan: string;
  jData: TJSONData;
  jParser: TJSONParser;
  s: string;

begin
  totalSMSLokal := StrToInt(trim(TFPHTTPClient.SimpleGet(LINK_JUMLAH_SMS_LOKAL)));

  if totalSMSLokal > 0 then
  begin

    jParser := TJSONParser.Create(TFPHTTPClient.SimpleGet(LINK_POP_SMS_LOKAL));
    jData := jParser.Parse;

    id := TJSONObject(jData).Get('ID');
    nomorPengirim := TJSONObject(jData).Get('SenderNumber');
    nomorPengirim := StringReplace(nomorPengirim, '+62', '0',
      [rfReplaceAll, rfIgnoreCase]);
    pesan := TJSONObject(jData).Get('TextDecoded');

    try
      // jika berhasil push ke server, hapus sms tersebut dari database lokal
      if Trim(TFPHTTPClient.SimpleGet(LINK_COMMIT_SMS_LOKAL +
        '?nomor_pengirim=' + EncodeURLElement(nomorPengirim) +
        '&pesan=' + EncodeURLElement(pesan))) = '1' then
      begin
        TFPHTTPClient.SimpleGet(LINK_DELETE_SMS_LOKAL + '/' + id);
        RunCommand('notify-send "SMS Dari ' + nomorPengirim + ':" "' +
          pesan + '" -i mail-unread', s);
      end;

    except
      on Exception do
      begin

      end;
    end;

    jParser.Free;
  end;

  // selesai melakukan pushing
  isPushing := False;
end;

procedure TformSMSLokal.init;
begin
  refreshList();
  jmlItemTerupdate := jmlItem;
end;

procedure TformSMSLokal.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  //Timer1.Enabled := False;
end;

end.
