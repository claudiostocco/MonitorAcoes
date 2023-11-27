program MonitorAcoes;

{$mode objfpc}{$H+}
{$I cef.inc}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  {$IFDEF LINUX}
  InitSubProcess, // On Linux this unit must be used *before* the "interfaces" unit.
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  main,
  Ticker, GlobalCefApplication, PanelTicker, constants;

{$R *.res}

begin
  RequireDerivedFormResource := True;
		Application.Scaled := True;
  Application.Initialize;
		Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.

