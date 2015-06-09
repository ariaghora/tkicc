unit frmidbrowser;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, StdCtrls;

type

  { TformIDBrowser }

  TformIDBrowser = class(TForm)
    Button1: TButton;
    ListView1: TListView;
  private
    { private declarations }
  public
    acuan: TLabeledEdit;
  end;

var
  formIDBrowser: TformIDBrowser;

implementation

{$R *.lfm}

end.

