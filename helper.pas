unit helper;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function serializeFromArr(api: string; arr: array of string): string;

implementation

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

end.

