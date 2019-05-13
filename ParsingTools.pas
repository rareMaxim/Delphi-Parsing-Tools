unit ParsingTools;

interface

uses
  System.Generics.Collections,
  System.SysUtils;

type
  IParsTools = interface
    ['{ACC6F3C9-2C01-42C7-A08D-36B93C69F6E5}']
    function First(const AFrom, ATo: string): string;
    function All(const AFrom, ATo: string): TArray<string>;
  end;

  TParsTools = class(TInterfacedObject, IParsTools)
  private
    FText: string;
  public
    class function Extract(const AText: string): IParsTools;
    function First(const AFrom, ATo: string): string;
    function All(const AFrom, ATo: string): TArray<string>;
  end;

implementation

{ TParsTools }

function TParsTools.All(const AFrom, ATo: string): TArray<string>;
var
  LFinded: TList<string>;
  LCurrent: string;
begin
  LFinded := TList<string>.Create;
  try
    while not FText.IsEmpty do
    begin
      LCurrent := First(AFrom, ATo);
      LFinded.Add(LCurrent);
    end;
    Result := LFinded.ToArray;
  finally
    LFinded.Free;
  end;
end;

class function TParsTools.Extract(const AText: string): IParsTools;
begin
  Result := TParsTools.Create;
  (Result as TParsTools).FText := AText;
end;

function TParsTools.First(const AFrom, ATo: string): string;
var
  LFirst: Integer;
  LLast: Integer;
begin
  LFirst := FText.IndexOf(AFrom) + AFrom.Length;
  FText := FText.Remove(0, LFirst);
  LLast := FText.IndexOf(ATo);
  Result := FText.Substring(0, LLast);
  if (LFirst < 0) or (LLast < 0) then
    FText := ''
  else
    FText := FText.Substring(LLast);
end;

end.

