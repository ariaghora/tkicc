program ews;

{$mode objfpc}{$H+}

uses {$DEFINE UseCThreads} {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, cmem,{$ENDIF} {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, frmMain, tachartlazaruspkg, beautify, helper, globals, frmlogin,
  bgrabitmappack, laz_synapse, frmMonitoring, threadutils, frmmessaging,
  frmTulisBroadcast, frmDetailTKI, frmtestsms,
frmpengaturan { you can add units after this };

{$R *.res}

begin
  init(False);
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
  Application.Run;
end.
