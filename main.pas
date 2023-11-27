unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, fgl, constants, Ticker, PanelTicker;

type
  TfmPanelTickerList = specialize TFPGObjectList<TfmPanelTicker>;

		{ TfmMain }

  TfmMain = class(TForm)
				procedure FormShow(Sender: TObject);
  private
    panelList: TfmPanelTickerList;
    procedure showTickers(tickers: TTickers);
    procedure ResizeChilds(child: TForm; index: Integer);
  public

  end;

var
  fmMain: TfmMain;

implementation

uses RESTRequest4D, uCEFApplication, uCEFWorkScheduler, GlobalCefApplication;

{$R *.lfm}

{ TfmMain }

procedure TfmMain.FormShow(Sender: TObject);
var response: IResponse;
    tickers: TTickers;
    fmPanelTicker: TfmPanelTicker;
begin
  WindowState := wsMaximized;
  Caption := kTitle;
  response := TRequest.New
              .BaseURL(Format('%s/tickers.json',[kFirebaseUrl]))
              .Accept('application/json')
              .Get;
  if response.StatusCode = 200 then
  begin
    tickers := TTicker.list(response.Content);
    showTickers(tickers);
		end;

  //fmPanelTicker := TfmPanelTicker.Create(Self);
  //fmPanelTicker.Show;
end;

procedure TfmMain.showTickers(tickers: TTickers);
var i: Integer;
begin
  if tickers.Count > 0 then
    panelList := TfmPanelTickerList.Create;
  //for i := 0 to 1 do
  for i := 0 to tickers.Count-1 do
  begin
    //ShowMessage(TTicker(tickers.Items[i]).ticker);
    panelList.Add(TfmPanelTicker.Create(Self).LoadTicker(TTicker(tickers.Items[i])));
    ResizeChilds(panelList.Items[i],i);
		end;
end;

procedure TfmMain.ResizeChilds(child: TForm; index: Integer);
begin
  //child.Height := 0;
  child.Top := (index div 2) * child.Height;
  child.Width := Width div 2;
  child.Left := child.Width * (index mod 2);
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
