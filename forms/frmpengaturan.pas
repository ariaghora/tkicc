unit frmpengaturan;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, process, strutils;

type

  { TformPengaturan }

  TformPengaturan = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    memoStatus: TMemo;
    pnlContent: TPanel;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
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
  isCheckingSMSDService: boolean = False;

const
  TERSEDIA = 'OK';
  TAK_TERSEDIA = 'TAK TERSEDIA';

implementation

uses
  frmtestsms;

{$R *.lfm}

{ TCekSMSDThread }

procedure TCekSMSDThread.Execute;
var
  s: string;
begin
  RunCommand('service gammu-smsd status', s);
  statusSMSDService := IfThen(Pos('is running', s) > 0, TERSEDIA, TAK_TERSEDIA);
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

procedure TformPengaturan.Timer1Timer(Sender: TObject);
var
  thrCheckSMSDService: TCekSMSDThread;
begin
  if not isCheckingSMSDService then
  begin
    thrCheckSMSDService := TCekSMSDThread.Create(True);
    thrCheckSMSDService.Start;
  end;

  // update status message
  memoStatus.Text :=
    'SMSD Service       : ' + statusSMSDService + chr(13) +
    'Koneksi ke Server  : ' + TERSEDIA;
end;

end.


