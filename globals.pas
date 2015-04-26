unit globals;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

var
  HOST: string;
  API_DIR: string;

  LINK_LOGIN_STAKEHOLDER: string;
  LINK_LIST_LAPORAN: string;
  LINK_LIST_BROADCAST: string;
  LINK_KIRIM_BROADCAST: string;

  //** SESSION VARIABLES **//
  USER_ID, USER_NAME, USER_PASSWORD, ID_SIMPUL_CABANG, NAMA_WILAYAH: string;


procedure init(isOnline: boolean);
procedure setupSession(aid, ausername, apassword, aid_simpul_cabang,
  anama_wilayah: string);

implementation

procedure init(isOnline: boolean);
begin
  if isOnline then
  begin
    HOST := 'http://';
    API_DIR := '';
  end
  else
  begin
    HOST := 'http://localhost/kawal-tki/';
    API_DIR := 'api/';
  end;
  HOST := HOST + API_DIR;

  LINK_LOGIN_STAKEHOLDER := HOST + 'loginstakeholder/';
  LINK_LIST_LAPORAN := HOST + 'listlaporan/';
  LINK_LIST_BROADCAST := HOST + 'listpesanbroadcast/';
  LINK_KIRIM_BROADCAST := HOST + 'kirimbroadcast/';
end;

procedure setupSession(aid, ausername, apassword, aid_simpul_cabang,
  anama_wilayah: string);
begin
  USER_ID := aid;
  USER_NAME := ausername;
  USER_PASSWORD := apassword;
  ID_SIMPUL_CABANG := aid_simpul_cabang;
  NAMA_WILAYAH := anama_wilayah;
end;

end.
