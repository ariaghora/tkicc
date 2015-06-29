unit frmeditdatatki;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, StdCtrls, Buttons, threadutils, synacode, globals, fphttpclient;

type

  { TformEditDataTKI }

  TformEditDataTKI = class(TForm)
    Button1: TButton;
    btnBrowseKodeTipe: TButton;
    btnBrowseKodeNegara: TButton;
    btnBrowseKodeWilayah: TButton;
    btnBrowseKodePeer: TButton;
    btnSubmit: TButton;
    Panel3: TPanel;
    SpeedButton1: TSpeedButton;
    txtID: TLabeledEdit;
    txtKodeWilayah: TLabeledEdit;
    txtKodePeer: TLabeledEdit;
    txtNama: TLabeledEdit;
    txtKodeTipe: TLabeledEdit;
    txtNomorTelepon: TLabeledEdit;
    txtLokasiKerja: TLabeledEdit;
    txtKodeNegara: TLabeledEdit;
    pnlTxtHolder: TPanel;
    pnlContent: TPanel;
    procedure btnBrowseKodeTipeClick(Sender: TObject);
    procedure btnSubmitClick(Sender: TObject);
    procedure pnlContentResize(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
  public
    idTKI: string;
    kodeTipe, nomorTelepon, nama, lokasiKerja, kodeNegara, kodeWilayah, kodePeer: string;
    mode: string;
    procedure muatInformasi;
    procedure clearForm;
  end;

var
  formEditDataTKI: TformEditDataTKI;

implementation

uses
  frmmanajementki, frmidbrowser;

{$R *.lfm}

{ TformEditDataTKI }

procedure TformEditDataTKI.pnlContentResize(Sender: TObject);
begin
  pnlTxtHolder.Left := pnlContent.Width div 2 - pnlTxtHolder.Width div 2;
  // pnlTxtHolder.Top := pnlContent.Height div 2 - pnlTxtHolder.Height div 2;
end;

procedure TformEditDataTKI.btnSubmitClick(Sender: TObject);
var
  aid_tki: string;
  akode_tipe: string;
  anomor_telepon: string;
  anama: string;
  alokasi_kerja: string;
  aisvirtual: string;
  akode_negara: string;
  akode_wilayah: string;
  apassword: string;
  akode_peer: string;

  url: string;
  pesan: string;
begin
  aid_tki := EncodeURLElement(txtID.Text);
  akode_tipe := EncodeURLElement(txtKodeTipe.Text);
  anomor_telepon := EncodeURLElement(txtNomorTelepon.Text);
  anama := EncodeURLElement(txtNama.Text);
  alokasi_kerja := EncodeURLElement(txtLokasiKerja.Text);
  aisvirtual := '0';
  akode_negara := EncodeURLElement(txtKodeNegara.Text);
  akode_wilayah := EncodeURLElement(txtKodeWilayah.Text);
  apassword := 'asd';
  akode_peer := EncodeURLElement(txtKodePeer.Text);

  if mode = 'EDIT' then
  begin
    url := LINK_EDIT_DATA_TKI + '?id_tki=' + aid_tki + '&kode_tipe=' +
      akode_tipe + '&nomor_telepon=' + anomor_telepon + '&nama=' +
      anama + '&lokasi_kerja=' + alokasi_kerja + '&virtual=' + aisvirtual +
      '&kode_negara=' + akode_negara + '&kode_wilayah=' + akode_wilayah +
      '&password=' + apassword + '&kode_peer=' + akode_peer;
    pesan := 'Data TKI berhasil diperbaharui.';
  end
  else
  begin
    url := LINK_TAMBAH_TKI + '?id_tki=' + aid_tki + '&kode_tipe=' +
      akode_tipe + '&nomor_telepon=' + anomor_telepon + '&nama=' +
      anama + '&lokasi_kerja=' + alokasi_kerja + '&virtual=' + aisvirtual +
      '&kode_negara=' + akode_negara + '&kode_wilayah=' + akode_wilayah +
      '&password=' + apassword + '&kode_peer=' + akode_peer;
    pesan := 'Data TKI berhasil ditambahkan.';
  end;

  try
    if trim(TFPHTTPClient.SimpleGet(url)) = '1' then
    begin
      ShowMessage(pesan);
      formManajemenTKI.renderListview;
      SpeedButton1Click(nil);
    end;
  except
    on Exception do
    begin
      ShowMessage('Terjadi kesalahan pada koneksi.');
      SpeedButton1Click(nil);
    end;
  end;
end;

procedure TformEditDataTKI.btnBrowseKodeTipeClick(Sender: TObject);
begin
  case TButton(Sender).Name of
    'btnBrowseKodeTipe':
      formIDBrowser.mode := 'KODE_TIPE';
    'btnBrowseKodeNegara':
      formIDBrowser.mode := 'KODE_NEGARA';
    'btnBrowseKodeWilayah':
      formIDBrowser.mode := 'KODE_WILAYAH';
  end;

  formIDBrowser.acuan := txtKodeTipe;
  formIDBrowser.ShowModal;
end;

procedure TformEditDataTKI.SpeedButton1Click(Sender: TObject);
begin
  formManajemenTKI.pnlContent.Show;
  pnlContent.Hide;
end;

procedure TformEditDataTKI.muatInformasi;
var
  thr: TMuatDetailThread;
begin
  txtID.Text := idTKI;

  thr := TMuatDetailThread.Create(True);
  thr.idTKI := idTKI;
  thr.Start;
end;

procedure TformEditDataTKI.clearForm;
var
  i: integer;
begin
  for i := 0 to pnlTxtHolder.ControlCount - 1 do
  begin
    if pnlTxtHolder.Controls[i] is TLabeledEdit then
      TLabeledEdit(pnlTxtHolder.Controls[i]).Text := '';
  end;
end;

end.
