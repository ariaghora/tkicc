program ews;

{$mode objfpc}{$H+}

uses {$DEFINE UseCThreads} {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads,
  cmem, {$ENDIF} {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  frmMain,
  tachartlazaruspkg,
  beautify,
  helper,
  globals,
  frmlogin,
  bgrabitmappack,
  laz_synapse,
  frmMonitoring,
  threadutils,
  frmmessaging,
  frmTulisBroadcast,
  frmDetailTKI,
  frmtestsms,
  frmpengaturan,
  frmmanajementki,
  frmsmslokal,
  frmlogoutput,
  frmondemand,
  frmeditdatatki, frmidbrowser;

{$R *.res}

begin
  init(True);
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TformLogin, formLogin);
  Application.CreateForm(TformMain, formMain);
  Application.CreateForm(TformMonitoring, formMonitoring);
  Application.CreateForm(TformMessaging, formMessaging);
  Application.CreateForm(TformTulisBroadcast, formTulisBroadcast);
  Application.CreateForm(TformDetailTKI, formDetailTKI);
  Application.CreateForm(TformTestSMS, formTestSMS);
  Application.CreateForm(TformPengaturan, formPengaturan);
  Application.CreateForm(TformManajemenTKI, formManajemenTKI);
  Application.CreateForm(TformSMSLokal, formSMSLokal);
  Application.CreateForm(TformLogOutput, formLogOutput);
  Application.CreateForm(TformOnDemand, formOnDemand);
  Application.CreateForm(TformEditDataTKI, formEditDataTKI);
  Application.CreateForm(TformIDBrowser, formIDBrowser);
  Application.Run;
end.
