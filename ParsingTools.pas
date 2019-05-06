unit ParsingTools;

interface

uses
  System.SysUtils;

type
  IParsTools = interface
    ['{ACC6F3C9-2C01-42C7-A08D-36B93C69F6E5}']
    function Tag(const AFrom, ATo: string): string;
    function Tags(const AFrom, ATo: string): TArray<string>;
  end;

  TParsTools = class(TInterfacedObject, IParsTools)
  private
    FText: string;
  public
    function Tag(const AFrom, ATo: string): string;
    function Tags(const AFrom, ATo: string): TArray<string>;
    class function Extract(const AText: string): IParsTools;
  end;

implementation

{ TParsTools }

class function TParsTools.Extract(const AText: string): IParsTools;
begin
  Result := TParsTools.Create;
  (Result as TParsTools).FText := AText;
end;

function TParsTools.Tag(const AFrom, ATo: string): string;
begin

end;

function TParsTools.Tags(const AFrom, ATo: string): TArray<string>;
begin

end;

end.

