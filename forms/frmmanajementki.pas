unit frmmanajementki;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, StdCtrls, Buttons, Menus, threadutils, json2lv, fphttpclient, globals;

type

  { TformManajemenTKI }

  TformManajemenTKI = class(TForm)
    cbStatus: TComboBox;
    Label1: TLabel;
    ListView1: TListView;
    MenuItem1: TMenuItem;
    Panel3: TPanel;
    pnlContent: TPanel;
    PopupMenu1: TPopupMenu;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    procedure cbStatusChange(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
    { private declarations }
  public
    procedure renderListview;
    procedure hapus;
    procedure sunting;
    procedure tambah;
  end;

var
  formManajemenTKI: TformManajemenTKI;

implementation

uses
  frmeditdatatki, frmMain;

{$R *.lfm}

{ TformManajemenTKI }

procedure doRender;
begin
  // lalala
end;

procedure TformManajemenTKI.ListView1DblClick(Sender: TObject);
begin
  sunting;
end;

procedure TformManajemenTKI.cbStatusChange(Sender: TObject);
begin
  renderListview;
end;

procedure TformManajemenTKI.MenuItem1Click(Sender: TObject);
begin
  ListView1DblClick(nil);
end;

procedure TformManajemenTKI.SpeedButton1Click(Sender: TObject);
begin
  renderListview;
end;

procedure TformManajemenTKI.SpeedButton2Click(Sender: TObject);
begin
  tambah;
end;

procedure TformManajemenTKI.SpeedButton4Click(Sender: TObject);
begin
  hapus;
end;

procedure TformManajemenTKI.renderListview;
var
  thr: TRenderTkiThread;
begin
  thr := TRenderTkiThread.Create(True);
  thr.lv := ListView1;
  thr.status := cbStatus.Text;
  thr.Start;
end;

procedure TformManajemenTKI.hapus;
begin
  if ListView1.SelCount > 0 then
  begin
    if MessageDlg('Konfirmasi', 'Hapus data?', mtConfirmation, mbYesNo, 0) = mrYes then
      try
        if trim(TFPHTTPClient.SimpleGet(LINK_HAPUS_DATA_TKI + '/' +
          ListView1.Selected.Caption)) = '1' then
        begin
          ShowMessage('Data berhasil dihapus');
        end
        else
          ShowMessage('Gagal menghapus data.');
      except
        on Exception do
        begin
          ShowMessage('Kesalahan pada koneksi.');
        end;
      end;
  end
  else
    ShowMessage('Pilih data terlebih dahulu.');

  renderListview;
end;

procedure TformManajemenTKI.sunting;
begin
  if ListView1.SelCount > 0 then
  begin
    formEditDataTKI.pnlContent.Show;
    formEditDataTKI.pnlContent.Parent := formMain.pnlContent;
    formEditDataTKI.idTKI := ListView1.Selected.Caption;
    formEditDataTKI.muatInformasi;
    formEditDataTKI.mode := 'EDIT';
    formEditDataTKI.cbStatus.Visible := True;
    formEditDataTKI.Label1.Visible := True;
    pnlContent.Hide;
  end;
end;

procedure TformManajemenTKI.tambah;
begin
  formEditDataTKI.pnlContent.Show;
  formEditDataTKI.pnlContent.Parent := formMain.pnlContent;
  formEditDataTKI.txtID.Hide;
  formEditDataTKI.clearForm;
  formEditDataTKI.mode := 'TAMBAH';
  formEditDataTKI.cbStatus.Visible := False;
  formEditDataTKI.Label1.Visible := False;
  pnlContent.Hide;
end;


end.
