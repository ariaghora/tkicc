unit frmDetailTKI;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, ComCtrls, PairSplitter, BGRAFlashProgressBar;

type

  { TformDetailTKI }

  TformDetailTKI = class(TForm)
    BGRAFlashProgressBar1: TBGRAFlashProgressBar;
    BGRAFlashProgressBar2: TBGRAFlashProgressBar;
    BGRAFlashProgressBar3: TBGRAFlashProgressBar;
    BGRAFlashProgressBar4: TBGRAFlashProgressBar;
    BGRAFlashProgressBar5: TBGRAFlashProgressBar;
    lblNama: TLabel;
    Panel3: TPanel;
    pnlContent: TPanel;
    ScrollBox1: TScrollBox;
    SpeedButton1: TSpeedButton;
    procedure BGRAFlashProgressBar1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { private declarations }
  public
    jString: string;
  end;

var
  formDetailTKI: TformDetailTKI;

implementation

uses
  frmMonitoring;

{$R *.lfm}

{ TformDetailTKI }

procedure TformDetailTKI.BGRAFlashProgressBar1Click(Sender: TObject);
begin

end;

procedure TformDetailTKI.SpeedButton1Click(Sender: TObject);
begin
  //ShowMessage(pnlContent.Parent.Name);
  pnlContent.Parent := nil;
  //pnlContent.Hide;
  formMonitoring.Panel3.Show;
  formMonitoring.ListView1.Show;

end;

end.

