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
  public
    { public declarations }
  end;

var
  formSMSLokal: TformSMSLokal;
  isNewSMS: boolean = False;

  isThreadRunning: boolean = False;
  strJSON: string;
  jmlItem: integer;
  jmlItemTerupdate: integer;

implementation

{$R *.lfm}

{ TformSMSLokal }

procedure TformSMSLokal.FormShow(Sender: TObject);
begin
  refreshList();
  jmlItemTerupdate := jmlItem;
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
  // pool sms baru
  poolSMSBaru;

  if isNewSMS then
  begin
    // notifikasi
    notifikasi;

    // refresh list
    refreshList;

    // tak ada sms baru lagi
    isNewSMS := False;
  end;

  // update status
  Label1.Caption := 'item sekarang: ' + IntToStr(jmlItem) + ', item terbaru: ' +
    IntToStr(jmlItemTerupdate);
end;

procedure TformSMSLokal.refreshList;
var
  jParser: TJSONParser;
  jData: TJSONData;
begin
  strJSON := TFPHTTPClient.SimpleGet(LINK_LIST_SMS_LOKAL);
  jParser := TJSONParser.Create(strJSON);
  jData := jParser.Parse;

  jmlItem := TJSONArray(jData).Count;

  renderJSON2ListView(strJSON, ListView1);

  jParser.Free;

end;

procedure setJmlItemSekarang;
var
  jParser: TJSONParser;
  jData: TJSONData;
begin
  jParser := TJSONParser.Create(TFPHTTPClient.SimpleGet(LINK_LIST_SMS_LOKAL));
  jData := jParser.Parse;
  jmlItemTerupdate := TJSONArray(jData).Count;
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

procedure TformSMSLokal.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  //Timer1.Enabled := False;
end;

end.


