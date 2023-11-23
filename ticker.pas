unit Ticker;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fgl, fpjson;

type
		{ TTicker }
  TTicker = class;

  generic TGList<T> = class(TList);
  TTickers = specialize TGList<TTicker>;

		{ TTicker }
  TTicker = class
		private
				FceilingPrice: Double;
				Fprice: Double;
				Fticker: String;
				procedure SetceilingPrice(AValue: Double);
				procedure Setprice(AValue: Double);
				procedure Setticker(AValue: String);
  public
    constructor fromJson(value: TJSONData);
    class function list(value: String): TTickers;
  published
    property ticker: String read Fticker write Setticker;
    property price: Double read Fprice write Setprice;
    property ceilingPrice: Double read FceilingPrice write SetceilingPrice;
		end;

implementation

{ TTicker }

procedure TTicker.SetceilingPrice(AValue: Double);
begin
		if FceilingPrice = AValue then Exit;
		FceilingPrice := AValue;
end;

procedure TTicker.Setprice(AValue: Double);
begin
		if Fprice = AValue then Exit;
		Fprice := AValue;
end;

procedure TTicker.Setticker(AValue: String);
begin
		if Fticker = AValue then Exit;
		Fticker := AValue;
end;

constructor TTicker.fromJson(value: TJSONData);
begin
  if (value <> nil) and (value is TJSONObject) then
  begin
    if value.FindPath('ticker') <> nil then
      Fticker := value.GetPath('ticker').Value;
    if value.FindPath('price') <> nil then
      Fprice := value.GetPath('price').AsFloat;
    if value.FindPath('ceiling_price') <> nil then
      FceilingPrice := value.GetPath('ceiling_price').AsFloat;
		end;
end;

class function TTicker.list(value: String): TTickers;
var jsonData: TJSONData;
    i: Integer;
begin
  Result := TTickers.Create;
  if not value.IsEmpty then
  begin
    jsonData := GetJSON(value);
    if jsonData is TJSONArray then
    begin
      for i := 0 to TJSONArray(jsonData).Count-1 do
        Result.Add(TTicker.fromJson(TJSONArray(jsonData).Items[i]));
				end else if jsonData is TJSONObject then
      Result.Add(TTicker.fromJson(jsonData));
		end;
end;

end.

