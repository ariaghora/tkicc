unit json2lv;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ComCtrls, fphttpclient, fpjson, jsonparser, dialogs;

procedure renderJSON2ListView(s: string; var lv: TListView);

implementation


procedure renderJSON2ListView(s: string; var lv: TListView);
var
  lvi: TListItem;
  i, col, colCount: integer;
  jData: TJSONData;
  jParser: TJSONParser;

  procedure addColumn(title: string);
  var
    c: TListColumn;
  begin
    c := lv.Columns.Add;
    c.Caption := title;
    c.AutoSize := True;
  end;

begin
  // clear listview
  lv.Columns.Clear;
  lv.Items.Clear;
  colCount := 0;

  try
    jParser := TJSONParser.Create(s);
    jData := jParser.Parse;
    jParser.Free;

    // make columns
    if TJSONArray(jData).Count > 0 then
      for col := 0 to TJSONArray(jData).Objects[0].Count - 1 do
      begin
        addColumn(TJSONArray(jData).Objects[0].Names[col]);
        Inc(colCount);
      end;


    for i := 0 to jData.Count - 1 do
      with (jData as TJSONArray).Objects[i] do
      begin
        //lvi := ListView1.lvClass.Items.Add;
        lvi := lv.Items.Add;
        lvi.Caption := Get(Names[0]);
        for col := 1 to colCount - 1 do
          lvi.SubItems.Add(Get(Names[col]));
      end;

  except
    MessageDlg('Error', 'Error reading database', mtError, [mbOK], 0);
  end;
end;


end.
