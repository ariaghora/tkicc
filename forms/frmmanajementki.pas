unit frmmanajementki;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, StdCtrls, Buttons;

type

  { TformManajemenTKI }

  TformManajemenTKI = class(TForm)
    ListView1: TListView;
    Panel3: TPanel;
    pnlContent: TPanel;
    SpeedButton1: TSpeedButton;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  formManajemenTKI: TformManajemenTKI;

implementation

{$R *.lfm}

end.

