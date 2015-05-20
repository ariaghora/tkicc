unit globals;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

var
  HOST: string;
  HOST_LOKAL: string;
  HOST_REMOTE: string;

  API_DIR: string;
  API_DIR_LOKAL: string;
  API_DIR_REMOTE: string;

  LINK_COMMIT_SMS_LOKAL: string;
  LINK_DELETE_SMS_LOKAL: string;
  LINK_JUMLAH_SMS_LOKAL: string;
  LINK_JUMLAH_SMS_REMOTE: string;
  LINK_LOGIN_STAKEHOLDER: string;
  LINK_LIST_LAPORAN: string;
  LINK_LIST_BROADCAST: string;
  LINK_LIST_SMS_LOKAL: string;
  LINK_LIST_SMS_REMOTE: string;
  LINK_KIRIM_BROADCAST: string;
  LINK_TULIS_BROADCAST: string;
  LINK_TEST_KONEKSI_KE_SERVER: string;
  LINK_POP_SMS_LOKAL: string;

  //** SESSION VARIABLES **//
  USER_ID, USER_NAME, USER_PASSWORD, ID_SIMPUL_CABANG, NAMA_WILAYAH: string;

  // SHARED STATUS VARIABLE
  TERKONEKSI_KE_SERVER: boolean = False;


procedure init(isOnline: boolean);
procedure setupSession(aid, ausername, apassword, aid_simpul_cabang,
  anama_wilayah: string);

implementation

procedure init(isOnline: boolean);
begin
  HOST_LOKAL := 'http://localhost/tkicc/';

  //HOST_REMOTE := 'http://grepegre.pe.hu/';
  HOST_REMOTE := 'http://tkicc.16mb.com/';

  API_DIR_LOKAL := 'api/';
  API_DIR_REMOTE := 'api/';

  if isOnline then
  begin
    HOST := HOST_REMOTE;
    API_DIR := API_DIR_REMOTE;
  end
  else
  begin
    HOST := HOST_LOKAL;
    API_DIR := API_DIR_LOKAL;
  end;
  HOST := HOST + API_DIR;

  LINK_COMMIT_SMS_LOKAL := HOST + 'commitsmslokal';
  LINK_LOGIN_STAKEHOLDER := HOST + 'loginstakeholder/';
  LINK_LIST_LAPORAN := HOST + 'listlaporan/';
  LINK_LIST_BROADCAST := HOST + 'listpesanbroadcast/';
  //LINK_KIRIM_BROADCAST := HOST + 'kirimbroadcast/';
  LINK_KIRIM_BROADCAST := HOST + 'kirimbroadcast';
  LINK_JUMLAH_SMS_REMOTE := HOST + 'jumlahsmsremote';
  LINK_LIST_SMS_REMOTE := HOST + 'listsmsremote';

  LINK_TEST_KONEKSI_KE_SERVER := HOST + 'testkoneksi';

  // Untuk keperluan layanan gammu
  // host selalu lokal
  //LINK_TULIS_BROADCAST := HOST_LOKAL + API_DIR_LOKAL + 'tulisbroadcast/';
  LINK_DELETE_SMS_LOKAL := HOST_LOKAL + API_DIR_LOKAL + 'deletesmslokal';
  LINK_TULIS_BROADCAST := HOST_LOKAL + API_DIR_LOKAL + 'tulisbroadcast';
  LINK_LIST_SMS_LOKAL := HOST_LOKAL + API_DIR_LOKAL + 'listsmslokal';
  LINK_JUMLAH_SMS_LOKAL := HOST_LOKAL + API_DIR_LOKAL + 'jumlahsmslokal';
  LINK_POP_SMS_LOKAL := HOST_LOKAL + API_DIR_LOKAL + 'popsmslokal';
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
