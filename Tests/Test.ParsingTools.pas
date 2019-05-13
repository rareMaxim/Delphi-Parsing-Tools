unit Test.ParsingTools;

interface

uses
  ParsingTools,
  DUnitX.TestFramework;

type
  [TestFixture]
  TMyTestObject = class
  private
    FParsTools: TParsTools;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    // Test with TestCase Attribute to supply parameters.

    [Test]
    [TestCase('TestA',
      '<meta name="csrf-token" content="xJC904V7lCCUbrjWYxqCj_xecjEbcMOSuwj1JuHHcrKm0fbktTXEauEm2pwNSMu8iTYTBmg6ucDUPKpXrLYr3Q==">,<meta name="csrf-token" content=",">,xJC904V7lCCUbrjWYxqCj_xecjEbcMOSuwj1JuHHcrKm0fbktTXEauEm2pwNSMu8iTYTBmg6ucDUPKpXrLYr3Q==')]
    [TestCase('TestB', '<b>data</b>,<b>,</b>,data')]
    procedure First(const AValue, AFrom, ATo, AData: string);
    [Test]
    [TestCase('TestA', '<b>data</b><b>data2</b><b>data3</b>,<b>,</b>,datadata2data3')]
    procedure All(const AValue, AFrom, ATo, AData: string);
  end;

implementation

uses
  System.SysUtils;

procedure TMyTestObject.Setup;
begin

end;

procedure TMyTestObject.TearDown;
begin
end;

procedure TMyTestObject.All(const AValue, AFrom, ATo, AData: string);
var
  LActualRaw: TArray<string>;
  LActual: string;
begin
  LActualRaw := TParsTools.Extract(AValue).All(AFrom, ATo);
  LActual := string.Join('', LActualRaw);
  Assert.AreEqual(AData, LActual);
end;

procedure TMyTestObject.First(const AValue, AFrom, ATo, AData: string);
var
  LActual: string;
begin
  LActual := TParsTools.Extract(AValue).First(AFrom, ATo);
  Assert.AreEqual(AData, LActual);
end;

initialization
  TDUnitX.RegisterTestFixture(TMyTestObject);

end.

