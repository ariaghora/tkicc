unit helper;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fphttpclient, synacode, globals;

function gammusendsms(dest, msg: string): string;
function serializeFromArr(api: string; arr: array of string): string;

procedure catatLog(pesan: string);


implementation

uses
  frmlogoutput, frmMain;

function gammusendsms(dest, msg: string): string;
begin

  Result := TFPHTTPClient.SimpleGet(LINK_TULIS_BROADCAST + '.php?nomor_tujuan=' +
    dest + '&pesan=' + EncodeURLElement(msg));

end;

function serializeFromArr(api: string; arr: array of string): string;
var
  argNum: integer;
  i: integer;
  s: string;
begin
  argNum := Length(arr);
  s := s + api + '/';
  for i := 0 to argNum - 1 do
  begin
    s := s + arr[i];
    if i < argNum - 1 then
      s := s + '/';
  end;

  Result := s;
end;

procedure catatLog(pesan: string);
begin
  with formMain do
  begin
    memoLog.Lines.Add('[' + DateTimeToStr(Now) + '] ' + pesan);
  end;
end;

end.

