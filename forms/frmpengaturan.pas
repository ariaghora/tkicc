unit frmpengaturan;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, BCButton, process, strutils, globals, fphttpclient;

type

  { TformPengaturan }

  TformPengaturan = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    memoStatus: TMemo;
    pnlContent: TPanel;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

  { TCekSMSDThread }

  TCekSMSDThread = class(TThread)
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: boolean);
    procedure preRun;
    procedure postRun;
  end;

var
  formPengaturan: TformPengaturan;
  statusSMSDService: string;
  statusInternet: string;
  isCheckingSMSDService: boolean = False;

const
  TERSEDIA = 'OK';
  TAK_TERSEDIA = 'TAK TERSEDIA';

implementation

uses
  frmtestsms, frmMain, frmsmslokal, frmlogoutput, frmmasukkanpassword;

{$R *.lfm}

{ TCekSMSDThread }

procedure TCekSMSDThread.Execute;
var
  s: string;
begin
  RunCommand('service gammu-smsd status', s);
  if Pos('is running', s) > 0 then
  begin
    statusSMSDService := TERSEDIA;
    SMSD_AKTIF := True;
  end
  else
  begin
    statusSMSDService := TAK_TERSEDIA;
    SMSD_AKTIF := False;
  end;

end;

constructor TCekSMSDThread.Create(CreateSuspended: boolean);
begin
  FreeOnTerminate := True;
  inherited Create(CreateSuspended);
end;

procedure TCekSMSDThread.preRun;
begin
  isCheckingSMSDService := True;
end;

procedure TCekSMSDThread.postRun;
begin
  isCheckingSMSDService := False;
end;

{ TformPengaturan }

procedure TformPengaturan.Button1Click(Sender: TObject);
begin

  formTestSMS.ShowModal;
end;

procedure thrTestKoneksi;
begin
  //ShowMessage('');
  //TFPHTTPClient.SimpleGet(LINK_TEST_KONEKSI_KE_SERVER);
end;

procedure TformPengaturan.Button2Click(Sender: TObject);
var
  s: string;
  client: TFPHTTPClient;
begin

  client := TFPHTTPClient.Create(nil);
  try
    s := client.get(LINK_TEST_KONEKSI_KE_SERVER);
    if client.ResponseStatusCode <> 404 then
      ShowMessage(s);
  finally
  end;

  //BeginThread(TThreadFunc(@thrTestKoneksi));

end;

procedure TformPengaturan.Button3Click(Sender: TObject);
begin
  formSMSLokal.ShowModal;
end;

procedure TformPengaturan.Button4Click(Sender: TObject);
begin
  if ID_SIMPUL_CABANG = '0' then
    formMasukkanPassword.Show
  else
    ShowMessage('Fitur hanya untuk eksekutif');
end;

procedure TformPengaturan.Timer1Timer(Sender: TObject);
var
  thrCheckSMSDService: TCekSMSDThread;
begin
  if ID_SIMPUL_CABANG = '0' then
    if not isCheckingSMSDService then
    begin
      thrCheckSMSDService := TCekSMSDThread.Create(True);
      thrCheckSMSDService.Start;
    end;

  if TERKONEKSI_KE_SERVER then
  begin
    statusInternet := TERSEDIA;
  end
  else
  begin
    statusInternet := TAK_TERSEDIA;
  end;


  if statusSMSDService = TERSEDIA then
  begin
    formMain.shapeIndicatorSMSD.FillColor := clLime;
  end
  else
  begin
    formMain.shapeIndicatorSMSD.FillColor := clRed;
  end;

  // update status message
  memoStatus.Text :=
    'SMSD Service       : ' + statusSMSDService + chr(13) +
    'Koneksi Internet   : ' + statusInternet + chr(13) + 'Server             : ' + HOST;
end;

end.




