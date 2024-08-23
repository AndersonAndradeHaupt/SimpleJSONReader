unit SimpleJSONReader;

interface

uses
  System.SysUtils, System.JSON, System.Classes;


type
  ISimpleJSONReader = interface
    ['{5457A250-CE9D-489F-B891-95C563F5A9CA}']
    function GetArray(const AName: string): ISimpleJSONReader;
    function GetObject(const AName: string): ISimpleJSONReader;
    function GetValue(const AName: string): TJSONValue;
    function GetValueAsString(const AName: string): string;
    function GetValueFromArray(Index: Integer): ISimpleJSONReader;
    function GetArrayCount: Integer;
  end;


type
  TSimpleJSONReader = class(TInterfacedObject, ISimpleJSONReader)
  private
    FJSONValue: TJSONValue;
    FJsonCriado: Boolean;
  public
    constructor Create(const AJSON: string); overload;
    constructor Create(AJSONValue: TJSONValue; ACriado: Boolean = False); overload;
    destructor Destroy; override;
    class function New(const AJSON: string): ISimpleJSONReader;
    function GetArray(const AName: string): ISimpleJSONReader;
    function GetObject(const AName: string): ISimpleJSONReader;
    function GetValue(const AName: string): TJSONValue;
    function GetValueAsString(const AName: string): string;
    function GetValueFromArray(Index: Integer): ISimpleJSONReader;
    function GetArrayCount: Integer;
  end;

implementation

constructor TSimpleJSONReader.Create(const AJSON: string);
begin
  inherited Create;
  FJSONValue := TJSONObject.ParseJSONValue(AJSON);
  if not (FJSONValue is TJSONObject) and  not (FJSONValue is TJSONArray) then
    raise Exception.Create('Json invalido');
  FJsonCriado := True;
end;

constructor TSimpleJSONReader.Create(AJSONValue: TJSONValue; ACriado: Boolean);
begin
  inherited Create;
  FJSONValue := AJSONValue;
  FJsonCriado := ACriado;
end;

destructor TSimpleJSONReader.Destroy;
begin
  if FJsonCriado then
    FJSONValue.Free;
  inherited;
end;

class function TSimpleJSONReader.New(const AJSON: string): ISimpleJSONReader;
begin
  Result := TSimpleJSONReader.Create(AJSON) as ISimpleJSONReader;
end;

function TSimpleJSONReader.GetArray(const AName: string): ISimpleJSONReader;
var
  JSONArray: TJSONArray;
  Value: TJSONValue;
begin
  Value := (FJSONValue as TJSONObject).GetValue(AName);
  if not (Value is TJSONArray) then
    raise Exception.CreateFmt('Array "%s" não encontrado ou invalido', [AName]);

  JSONArray := Value as TJSONArray;
  Result := TSimpleJSONReader.Create(JSONArray, False) as ISimpleJSONReader
end;

function TSimpleJSONReader.GetArrayCount: Integer;
begin
    if FJSONValue is TJSONArray then
    Result := TJSONArray(FJSONValue).Count
  else
    raise Exception.Create('Não é JSON array');
end;

function TSimpleJSONReader.GetObject(const AName: string): ISimpleJSONReader;
var
  JSONObject: TJSONObject;
  Value: TJSONValue;
begin
  Value := (FJSONValue as TJSONObject).GetValue(AName);
  if not (Value is TJSONObject) then
    raise Exception.CreateFmt('Object "%s" não encontrado ou invalido', [AName]);

  JSONObject := Value as TJSONObject;
  Result := TSimpleJSONReader.Create(JSONObject, False) as ISimpleJSONReader;
end;

function TSimpleJSONReader.GetValue(const AName: string): TJSONValue;
begin
  Result := (FJSONValue as TJSONObject).GetValue(AName);
  if Result = nil then
    raise Exception.CreateFmt('Field "%s" não encontrato', [AName]);
end;

function TSimpleJSONReader.GetValueAsString(const AName: string): string;
begin
  Result := GetValue(AName).Value;
end;

function TSimpleJSONReader.GetValueFromArray(Index: Integer): ISimpleJSONReader;
var
  JSONArray: TJSONArray;
begin
  if not (FJSONValue is TJSONArray) then
    raise Exception.Create('Não é um JSON array');

  JSONArray := FJSONValue as TJSONArray;
  if (Index >= 0) and (Index < JSONArray.Count) then
    Result := TSimpleJSONReader.Create(JSONArray.Items[Index], False) as ISimpleJSONReader
  else
    raise Exception.CreateFmt('Index %d não encontrado', [Index]);
end;

end.

