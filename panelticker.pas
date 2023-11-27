unit PanelTicker;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
		constants, Ticker, uCEFBrowserWindow, uCEFInterfaces, uCEFChromiumEvents,
		uCEFTypes;

type

  //TDomVisitorFindXY = class(TCefDomVisitorOwn)
  //  protected
  //    FFrame: ICefFrame;
  //    procedure visit(const document: ICefDomDocument); override;
  //  public
  //    constructor Create(AFrame: ICefFrame; X,Y: Integer); reintroduce; virtual;
  //end;

		{ TfmPanelTicker }

  TfmPanelTicker = class(TForm)
				bwCotacao: TBrowserWindow;
				Label1: TLabel;
				Label2: TLabel;
				pnCotacao: TPanel;
				pnInfo: TPanel;
				procedure ChromiumBeforeBrowse(Sender: TObject; const browser: ICefBrowser;
						const frame: ICefFrame; const request: ICefRequest; user_gesture,
						isRedirect: Boolean; out Result: Boolean);
    procedure ChromiumLoadEnd(Sender: TObject; const browser: ICefBrowser;
						const frame: ICefFrame; httpStatusCode: Integer);
				procedure FormResize(Sender: TObject);
  private

  public
    function LoadTicker(value: TTicker): TfmPanelTicker;
  end;

//var
  //fmPanelTicker: TfmPanelTicker;

implementation

{$R *.lfm}

{ TfmPanelTicker }
procedure changeDOM(const document: ICefDomDocument);
begin
  ShowMessage(document.GetElementById('guce-inline-consent-iframe').ElementInnerText);
end;

procedure TfmPanelTicker.ChromiumLoadEnd(Sender: TObject;	const browser: ICefBrowser; const frame: ICefFrame; httpStatusCode: Integer);
begin
  frame.ExecuteJavaScript('document.getElementById("guce-inline-consent-iframe").remove()','',0);
  frame.ExecuteJavaScript('document.getElementsByTagName("footer").item(document.getElementsByTagName("footer").length-1).previousElementSibling.remove()','',0);
  frame.ExecuteJavaScript('document.getElementsByTagName("footer").item(document.getElementsByTagName("footer").length-1).remove()','',0);
  //frame.VisitDomProc(@changeDOM);
  //ShowMessage('LoadEnd');
end;

procedure TfmPanelTicker.FormResize(Sender: TObject);
begin
  bwCotacao.Width := Width - pnInfo.Width-5;
  bwCotacao.Height := Height+135;
end;

procedure TfmPanelTicker.ChromiumBeforeBrowse(Sender: TObject;
		const browser: ICefBrowser; const frame: ICefFrame;
		const request: ICefRequest; user_gesture, isRedirect: Boolean; out
		Result: Boolean);
begin
  //frame.VisitDomProc(@changeDOM);
end;

function TfmPanelTicker.LoadTicker(value: TTicker): TfmPanelTicker;
begin
  Result := Self;
  Caption := value.ticker;
  Label1.Caption := 'Teto:';
  Label2.Caption := Format('%8.2f',[value.ceilingPrice]);
  //pnInfo.Caption := Format('Teto: %f',[value.ceilingPrice]);
  bwCotacao.LoadURL(Format('%s/%s',[kYahooFinanceUrl,value.ticker]));
  bwCotacao.Left := 0;
  bwCotacao.Top := 0;
  Show;
end;

end.
