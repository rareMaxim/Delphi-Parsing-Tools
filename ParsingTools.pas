unit ParsingTools;

interface

type
  IParsTools = interface
    ['{ACC6F3C9-2C01-42C7-A08D-36B93C69F6E5}']
    // private
    function GetItems(const AIndex: integer): IParsTools;
    procedure SetItems(const AIndex: integer; const Value: IParsTools);
    // public
    // текущее значение
    function Data: string;
    // Находит первое вхождение из Data
    function First(const AFrom, ATo: string): string;
    // Находит все вхождения из Data
    function All(const AFrom, ATo: string): TArray<string>;
    // Находит первое вхождение из Data и возвращает интерфейс для дальнейших действий
    function FirstAnd(const AFrom, ATo: string): IParsTools;
    // Находит все вхождения из Data и возвращает интерфейс для дальнейших действий
    function AllAnd(const AFrom, ATo: string): IParsTools;
    // Содержит массив интерфейсов после метода AllAnd
    property Items[const AIndex: integer]: IParsTools read GetItems write SetItems; default;
    // Количество в массиве после метода AllAnd
    function ItemsCount: integer;
  end;

function ParsingTool(const AData: string): IParsTools;

implementation

uses
  System.SysUtils;

type
  TParsTools = class(TInterfacedObject, IParsTools)
  private
    FData_: string; // readonly
    FItems: TArray<IParsTools>;
    function GetItems(const AIndex: integer): IParsTools;
    procedure SetItems(const AIndex: integer; const Value: IParsTools);
  protected
    constructor Create(const AData: string); overload;
    constructor Create(const AItems: TArray<IParsTools>); overload;
  public
    class function Pars(const AText: string): IParsTools;
    function Data: string;
    function First(const AFrom, ATo: string): string;
    function FirstAnd(const AFrom, ATo: string): IParsTools;
    function All(const AFrom, ATo: string): TArray<string>;
    function AllAnd(const AFrom, ATo: string): IParsTools;
    property Items[const AIndex: integer]: IParsTools read GetItems write SetItems; default;
    function ItemsCount: integer;
  end;

  { TParsTools }

function TParsTools.All(const AFrom, ATo: string): TArray<string>;
var
  TagAPosition: integer;
  TagBPosition: integer;
  LData: string;
  lResult: string;
begin
  LData := FData_;
  while true do
  begin
    TagAPosition := LData.IndexOf(AFrom);
    if TagAPosition < 0 then
      break;
    LData := LData.Remove(0, TagAPosition + AFrom.Length);
    TagBPosition := LData.IndexOf(ATo);
    if TagBPosition < 0 then
      break;
    lResult := LData.Substring(0, TagBPosition);
    LData := LData.Substring(TagBPosition + ATo.Length);
    if not lResult.IsEmpty then
    begin
      SetLength(Result, Length(Result) + 1);
      Result[High(Result)] := lResult;
    end;
  end;
end;

function TParsTools.AllAnd(const AFrom, ATo: string): IParsTools;
var
  LData: TArray<string>;
  LItems: TArray<IParsTools>;
  I: integer;
begin
  LData := All(AFrom, ATo);
  SetLength(LItems, Length(LData));
  for I := Low(LData) to High(LData) do
    LItems[I] := TParsTools.Create(LData[I]);
  Result := TParsTools.Create(LItems);
end;

constructor TParsTools.Create(const AItems: TArray<IParsTools>);
begin
  FItems := AItems;
end;

constructor TParsTools.Create(const AData: string);
begin
  FData_ := AData;
end;

function TParsTools.Data: string;
begin
  Result := FData_;
end;

class function TParsTools.Pars(const AText: string): IParsTools;
begin
  Result := TParsTools.Create(AText);
end;

function TParsTools.First(const AFrom, ATo: string): string;
var
  TagAPosition: integer;
  TagBPosition: integer;
  LData: string;
begin
  LData := FData_;
  TagAPosition := LData.IndexOf(AFrom);
  if TagAPosition < 0 then
    raise ERangeError.CreateFmt('Tag A: %s not found', [AFrom]);
  LData := LData.Remove(0, TagAPosition + AFrom.Length);
  TagBPosition := LData.IndexOf(ATo);
  if TagBPosition < 0 then
    raise ERangeError.CreateFmt('Tag B: %s not found', [ATo]);
  Result := LData.Remove(TagBPosition);
end;

function TParsTools.FirstAnd(const AFrom, ATo: string): IParsTools;
var
  LText: string;
begin
  LText := First(AFrom, ATo);
  Result := TParsTools.Create(LText);
end;

function TParsTools.GetItems(const AIndex: integer): IParsTools;
begin
  Result := FItems[AIndex];
end;

function TParsTools.ItemsCount: integer;
begin
  Result := Length(FItems);
end;

procedure TParsTools.SetItems(const AIndex: integer; const Value: IParsTools);
begin
  FItems[AIndex] := Value;
end;

function ParsingTool(const AData: string): IParsTools;
begin
  Result := TParsTools.Pars(AData);
end;

end.
