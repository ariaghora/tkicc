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
  LINK_DETAIL_TKI: string;
  LINK_DATA_GRAFIK: string;
  LINK_EDIT_DATA_TKI: string;
  LINK_HAPUS_DATA_TKI: string;
  LINK_JUMLAH_SMS_LOKAL: string;
  LINK_JUMLAH_SMS_REMOTE: string;
  LINK_JUMLAH_PESAN_ONDEMAND: string;
  LINK_JUMLAH_SMS_MONITOR: string;
  LINK_JUMLAH_SMS_POOL: string;
  LINK_JUMLAH_BROADCAST_POOL: string;
  LINK_JUMLAH_PESAN_ONDEMAND_UNCONFIRMED: string;
  LINK_KIRIM_BROADCAST: string;
  LINK_KIRIM_BROADCAST_DAN_POOL: string;
  LINK_LOGIN_STAKEHOLDER: string;
  LINK_LIST_LAPORAN: string;
  LINK_LIST_BROADCAST: string;
  LINK_LIST_NOMOR_TELEPON: string;
  LINK_LIST_NOMOR_TELEPON_STAKEHOLDER: string;
  LINK_LIST_NEGARA: string;
  LINK_LIST_PESAN_ONDEMAND: string;
  LINK_LIST_SMS_BY_PENGIRIM: string;
  LINK_LIST_SMS_LOKAL: string;
  LINK_LIST_SMS_REMOTE: string;
  LINK_LIST_TKI: string;
  LINK_LIST_WILAYAH: string;
  LINK_LIST_PEER: string;
  LINK_MASTER: string;
  LINK_NILAI_TERBARU: string;
  LINK_TAMBAH_TKI: string;
  LINK_TULIS_BROADCAST: string;
  LINK_TEST_KONEKSI_KE_SERVER: string;
  LINK_POP_SMS_LOKAL: string;
  LINK_POP_SMS_POOL: string;
  LINK_POP_BROADCAST_POOL: string;
  LINK_POP_PESAN_ONDEMAND_UNCONFIRMED: string;
  LINK_POOL_SMS: string;

  //** SESSION VARIABLES **//
  USER_ID, USER_NAME, USER_PASSWORD, ID_SIMPUL_CABANG, NAMA_WILAYAH: string;

  // SHARED STATUS VARIABLE
  TERKONEKSI_KE_SERVER: boolean = False;
  SMSD_AKTIF: boolean = False;


procedure init(isOnline: boolean);
procedure setupSession(aid, ausername, apassword, aid_simpul_cabang,
  anama_wilayah: string);

implementation

procedure init(isOnline: boolean);
begin
  HOST_LOKAL := 'http://localhost/rhctkicc/';

  //HOST_REMOTE := 'http://grepegre.pe.hu/';
  //HOST_REMOTE := 'http://ghora.koding.io/';
  //HOST_REMOTE := 'http://tkicc.16mb.com/';
  HOST_REMOTE := 'http://tkicc-ghora.rhcloud.com/';

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
  LINK_DATA_GRAFIK := HOST + 'datagrafik';
  LINK_DETAIL_TKI := HOST + 'detailtki';
  LINK_EDIT_DATA_TKI := HOST + 'editdatatki';
  LINK_HAPUS_DATA_TKI := HOST + 'hapustki';
  LINK_LOGIN_STAKEHOLDER := HOST + 'loginstakeholder/';
  LINK_LIST_LAPORAN := HOST + 'listlaporan/';
  LINK_LIST_BROADCAST := HOST + 'listpesanbroadcast/';
  //LINK_KIRIM_BROADCAST := HOST + 'kirimbroadcast/';
  LINK_KIRIM_BROADCAST := HOST + 'kirimbroadcast';
  LINK_KIRIM_BROADCAST_DAN_POOL := HOST + 'kirimbroadcastdanpool';
  LINK_JUMLAH_BROADCAST_POOL := HOST + 'jumlahbroadcastpool';
  LINK_JUMLAH_SMS_REMOTE := HOST + 'jumlahsmsremote';
  LINK_JUMLAH_PESAN_ONDEMAND := HOST + 'jumlahpesanondemand/';
  LINK_JUMLAH_PESAN_ONDEMAND_UNCONFIRMED := HOST + 'jumlahpesanondemandunconfirmed';
  LINK_JUMLAH_SMS_MONITOR := HOST + 'jumlahsmsmonitor';
  LINK_JUMLAH_SMS_POOL := HOST + 'jumlahsmspool';
  LINK_LIST_PESAN_ONDEMAND := HOST + 'listpesanondemand';
  LINK_LIST_SMS_BY_PENGIRIM := HOST + 'listsmsbypengirim';
  LINK_LIST_SMS_REMOTE := HOST + 'listsmsremote';
  LINK_LIST_TKI := HOST + 'listtki';
  LINK_LIST_NEGARA := HOST + 'listnegara';
  LINK_LIST_NOMOR_TELEPON := HOST + 'listnomortelepon';
  LINK_LIST_NOMOR_TELEPON_STAKEHOLDER := HOST + 'listnomorteleponstakeholder';
  LINK_LIST_WILAYAH := HOST + 'listwilayah';
  LINK_LIST_PEER := HOST + 'listpeer';
  LINK_MASTER := HOST + 'master';
  LINK_NILAI_TERBARU := HOST + 'nilaiterbaru';
  LINK_TAMBAH_TKI := HOST + 'tambahtki';
  LINK_POP_BROADCAST_POOL := HOST + 'popbroadcastpool';
  LINK_POP_PESAN_ONDEMAND_UNCONFIRMED := HOST + 'poppesanondemandunconfirmed';
  LINK_POP_SMS_POOL := HOST + 'popsmspool';
  LINK_POOL_SMS := HOST + 'poolsms';

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
