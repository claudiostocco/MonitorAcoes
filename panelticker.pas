unit PanelTicker;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, constants, Ticker,
		uCEFBrowserWindow, uCEFInterfaces, uCEFChromiumEvents;

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
procedure changeDOM(const document: ICefDomDocument);
begin
  ShowMessage(document.GetElementById('defaultLDRB-wrapper').ElementInnerText);
end;

function TfmPanelTicker.LoadTicker(value: TTicker): TfmPanelTicker;
begin
  Result := Self;
  Caption := value.ticker;
  pnInfo.Caption := Format('Teto: %f',[value.ceilingPrice]);
  bwCotacao.LoadURL(Format('%s/%s',[kYahooFinanceUrl,value.ticker]));
  Show;
end;

end.
