unit frmDetailTKI;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, ComCtrls, PairSplitter, BGRAFlashProgressBar, json2lv;

type

  { TformDetailTKI }

  TformDetailTKI = class(TForm)
    bar1: TBGRAFlashProgressBar;
    bar2: TBGRAFlashProgressBar;
    bar3: TBGRAFlashProgressBar;
    bar4: TBGRAFlashProgressBar;
    bar5: TBGRAFlashProgressBar;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lbl: TLabel;
    Label6: TLabel;
    lblHakInfo: TLabel;
    lblHakJamKerja: TLabel;
    lblHakKeselamatan: TLabel;
    lblHakPRT: TLabel;
    lblHakUpah: TLabel;
    lblNama: TLabel;
    ListView1: TListView;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    pnlContent: TPanel;
    ScrollBox1: TScrollBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Splitter1: TSplitter;
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { private declarations }
  public
    jString: string;
    namaTKI: string;
    idTKI, nomorTelepon: string;
    nil1, nil2, nil3, nil4, nil5: string;
    dataSMS: ansistring;
    procedure refreshLogSMS;
  end;

var
  formDetailTKI: TformDetailTKI;



implementation

uses
  frmMonitoring, frmtestsms;

{$R *.lfm}

{ TformDetailTKI }

procedure TformDetailTKI.SpeedButton1Click(Sender: TObject);
begin
  //ShowMessage(pnlContent.Parent.Name);
  pnlContent.Parent := nil;
  //pnlContent.Hide;
  formMonitoring.Panel3.Show;
  formMonitoring.ListView1.Show;

end;

procedure TformDetailTKI.Button1Click(Sender: TObject);
begin
  formTestSMS.Edit1.Enabled := False;
  formTestSMS.Edit1.Text := nomorTelepon;
  formTestSMS.ShowModal;
end;

procedure TformDetailTKI.SpeedButton2Click(Sender: TObject);
begin
  refreshLogSMS;
end;

procedure TformDetailTKI.refreshLogSMS;
begin
  renderJSON2ListView(dataSMS, ListView1);
end;

end.

