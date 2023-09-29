unit PanelTicker;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, constants, Ticker,
		uCEFBrowserWindow;

type

		{ TfmPanelTicker }

  TfmPanelTicker = class(TForm)
				bwCotacao: TBrowserWindow;
				pnCotacao: TPanel;
				pnInfo: TPanel;
  private

  public
    function LoadTicker(value: TTicker): TfmPanelTicker;
  end;

//var
  //fmPanelTicker: TfmPanelTicker;

implementation

{$R *.lfm}

{ TfmPanelTicker }

function TfmPanelTicker.LoadTicker(value: TTicker): TfmPanelTicker;
begin
  Result := Self;
  Caption := value.ticker;
  pnInfo.Caption := Format('Comprar em %f',[value.ceilingPrice]);
  bwCotacao.LoadURL(Format('%s/%s',[kYahooFinanceUrl,value.ticker]));
  Show;
end;

initialization
  {$IFDEF DARWIN}  // $IFDEF MACOSX
  AddCrDelegate;
  {$ENDIF}
  if GlobalCEFApp = nil then begin
    CreateGlobalCEFApp;
    if not GlobalCEFApp.StartMainProcess then begin
      DestroyGlobalCEFApp;
      DestroyGlobalCEFWorkScheduler;
      halt(0); // exit the subprocess
    end;
  end;

finalization
  (* Destroy from this unit, which is used after "Interfaces". So this happens before the Application object is destroyed *)
  if GlobalCEFWorkScheduler <> nil then
    GlobalCEFWorkScheduler.StopScheduler;
  DestroyGlobalCEFApp;
  DestroyGlobalCEFWorkScheduler;

end.
