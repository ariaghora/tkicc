unit frmidbrowser;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, StdCtrls, json2lv, globals, fphttpclient;

type

  { TformIDBrowser }

  TformIDBrowser = class(TForm)
    Button1: TButton;
    ListView1: TListView;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    acuan: TLabeledEdit;
    mode: string;
    procedure update(var s: string);
  end;

var
  formIDBrowser: TformIDBrowser;

implementation

uses
  frmeditdatatki;

{$R *.lfm}

{ TformIDBrowser }


procedure TformIDBrowser.Button1Click(Sender: TObject);
var
  outText: string;
begin
  //acuan := TLabeledEdit.Create(nil);
  if ListView1.SelCount > 0 then
  begin
    outText := ListView1.Selected.Caption;
    case mode of
      'KODE_TIPE':
        formEditDataTKI.txtKodeTipe.Text := outText;
      'KODE_NEGARA':
        formEditDataTKI.txtKodeNegara.Text := outText;
      'KODE_WILAYAH':
        formEditDataTKI.txtKodeWilayah.Text := outText;
    end;
    //ShowMessage(IntToStr(ListView1.SelCount));
  end;
  Close;
end;

procedure TformIDBrowser.FormShow(Sender: TObject);
var
  tabel: string;
begin
  case mode of
    'KODE_TIPE':
      tabel := 'tipe_tki';
    'KODE_NEGARA':
      tabel := 'negara';
    'KODE_WILAYAH':
      tabel := 'wilayah';
  end;

  try
    json2lv.renderJSON2ListView(TFPHTTPClient.SimpleGet(LINK_MASTER + '/' + tabel),
      ListView1);
  except
    on Exception do
    begin
      ShowMessage('Gagal memuat tabel.');
      Close;
    end;
  end;
end;

procedure TformIDBrowser.update(var s: string);
begin
  s := '12123213';
end;

end.
