unit helper;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fphttpclient, synacode, globals, process, Dialogs;

function gammusendsms(dest, msg: string): string;
function serializeFromArr(api: string; arr: array of string): string;

procedure catatLog(pesan: string);


implementation

uses
  frmlogoutput, frmMain;

function gammusendsms(dest, msg: string): string;
var
  s: string;
begin
  RunCommand('gammu-smsd-inject TEXT ' + dest + ' -len 400 -text "' + msg + '"', s);
  if length(trim(s)) > 0 then
    Result := '1'
  else
    Result := '0';
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

