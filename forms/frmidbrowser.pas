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
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
  public
    acuan: TLabeledEdit;
    procedure update(var s: string);
  end;

var
  formIDBrowser: TformIDBrowser;

implementation

{$R *.lfm}

{ TformIDBrowser }


procedure TformIDBrowser.Button1Click(Sender: TObject);
begin
  acuan := TLabeledEdit.Create(nil);
end;

procedure TformIDBrowser.update(var s: string);
begin
  s := '12123213';
end;

end.

