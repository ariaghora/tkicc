unit frmDetailTKI;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, ComCtrls, PairSplitter, BGRAFlashProgressBar;

type

  { TformDetailTKI }

  TformDetailTKI = class(TForm)
    bar1: TBGRAFlashProgressBar;
    bar2: TBGRAFlashProgressBar;
    bar3: TBGRAFlashProgressBar;
    bar4: TBGRAFlashProgressBar;
    lblNama: TLabel;
    Panel3: TPanel;
    pnlContent: TPanel;
    ScrollBox1: TScrollBox;
    SpeedButton1: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
  private
    { private declarations }
  public
    jString: string;
    namaTKI: string;
    nil1, nil2, nil3: string;
  end;

var
  formDetailTKI: TformDetailTKI;



implementation

uses
  frmMonitoring;

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

end.

