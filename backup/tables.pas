unit tables;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, db_representation, SysUtils, Crt, GeneralTypes, table_manipulation, base_graphic;

type
  { Table1 }
  Table1 = class sealed (InheritedTableCls)
  private
    function enterDeveloperName: string;
    function enterVillageName(text: string): string;
    function enterArea: string;
    function enterInhabitantsCount: string;
  public
    constructor Init(start_x, start_y, border_y, width, height: integer);
    procedure showPage;
    procedure showLine(lineNumber: word);
    procedure showHead;
    function enterTextFormat(InputField: TextButton): string; override;
    function setHeadOfColumns(): Header; override;
  end;

  { Table2 }

  Table2 = class sealed (InheritedTableCls)
  private
    function enterFloorCount: string;
    function enterHouseNumber: string;
    function enterHouseArea: string;
    function enterHouseType: string;
    function enterVillageName: string;
    public
      constructor Init(start_x, start_y, border_y, width, height: integer);
      function setHeadOfColumns(): Header; override;
      function enterTextFormat(InputField: TextButton): string; override;
  end;

  { Table3 }

  Table3 = class sealed (InheritedTableCls)
  private
    function enterAddress: string;
    function enterDeveloperName: string;
    function enterFlatNumber: string;
    function enterHomeNumber: string;
    function enterStreetName: string;
    function enterTownName: string;
    function enterYearPayment: string;
    public
      constructor Init(start_x, start_y, border_y, width, height: integer);
      function setHeadOfColumns(): Header; override;
      function enterTextFormat(InputField: TextButton): string; override;
  end;

implementation
constructor Table1.Init(start_x, start_y, border_y, width, height: integer);
//var
//  i: byte;
//  win: WindowManager;
begin
  countColumn := 4;
  //win := WindowManager.Init;
  //win.createNewWindow(1, 1, 170, 5, 7);
  //win.createNewWindow(120, 1, 220, 50, 7);
  //for i := 1 to win.activeWindows do
  //  win.showWindow(i);
  inherited Init(start_x, start_y, border_y, width, height, countColumn, 0, false);
end;

procedure Table1.showPage;
begin
  inherited;
end;

procedure Table1.showLine(lineNumber: word);
begin
  inherited;
end;

procedure Table1.showHead;
begin
  inherited;
end;

function Table1.enterTextFormat(InputField: TextButton): string;
begin
  inherited enterTextFormat(InputField);
  if on_horizontal_button = 1 then
    enterTextFormat := enterVillageName(InputField.getText)
  else if on_horizontal_button = 2 then
    enterTextFormat := enterDeveloperName
  else if (InputField.getText() = '') or (readkey <> #13) then
  begin
    InputField.setText(deleteText(InputField.getText(), length(InputField.getText())));
    case on_horizontal_button of
      3: enterTextFormat := enterArea;
      4: enterTextFormat := enterInhabitantsCount;
    end;
  end;
  InputField.border.Destroy;
  InputField.Destroy;
end;

function Table1.setHeadOfColumns(): Header;
begin
  setlength(result, countColumn);
  Result[0] := 'ÍÀÇÂÀÍÈÅ';
  Result[1] := 'ÄÅÂÅËÎÏÅĞ';
  Result[2] := 'ÏËÎÙÀÄÜ';
  Result[3] := 'ÊÎËÈ×ÅÑÒÂÎ ÆÈÒÅËÅÉ';
end;

function Table1.enterVillageName(text: string): string;
const
  MaxOrgNameSize = 25;
begin
  enterVillageName := enterText(text, MaxOrgNameSize);
end;

function Table1.enterArea(): string;
begin
  result := enterNumber(2) + '.';
  write('.');
  result := result + enterNumber(2) + 'êì2';
  write('êì2');
end;

function Table1.enterDeveloperName: string;
const
  nameLength = 25;
begin
  result := enterText(result, nameLength);
end;

function Table1.enterInhabitantsCount: string;
const
  maxThousandsCount = 12;
  minThousandsCount = 3;
var
  thousands: string[2];
  hundreds: string[3];
  count: byte;
begin
  count := 0;
  thousands := '';
  repeat
    thousands := deleteText(thousands, length(thousands));
    thousands := enterNumber(2);
    if thousands <> '' then
      count := strToInt(thousands);
  until (count >= minThousandsCount) and (count < maxThousandsCount); // ìåíüøå - ñåëî, áîëüøå - ãîğîä
  write('òûñ. ');

  hundreds := enterNumber(3);
  write(' ÷åë.');
  result := Format('%s òûñ. %s ÷åë.', [thousands, hundreds]);
end;

constructor Table2.Init(start_x, start_y, border_y, width, height: integer);
begin
  countColumn := 5;
  inherited Init(start_x, start_y, border_y, width, height, countColumn);
end;

function Table2.setHeadOfColumns(): Header;
begin
  setlength(result, countColumn);
  Result[0] := 'ÏÎÑÅËÎÊ';
  Result[1] := 'ÍÎÌÅĞ ÄÎÌÀ';
  Result[2] := 'ÏËÎÙÀÄÜ ÄÎÌÀ';
  Result[3] := 'ÊÎËÈ×ÅÑÒÂÎ İÒÀÆÅÉ';
  Result[4] := 'ÒÈÏ ÄÎÌÀ';
end;

function Table2.enterFloorCount: string;
const
  maxFloorCount = 59;
var
  floorCount: string;
  intCount: byte;
begin
  intCount := 0;
  floorCount := '';
  repeat
    floorCount := deleteText(floorCount, 2);
    floorCount := enterNumber(2);
    if floorCount <> '' then
      intCount := strToInt(floorCount);
  until ((intCount <= maxFloorCount) and (intCount > 0)); // Èíòåğåñíûé ôàêò: ñàìîå âûñîêîå çäàíèå â Ìîñêîâñêîé îáëàñòè íàõîäèòñÿ â Õèìêàõ è â í¸ì 59 ıòàæåé)
  write(' ıòàæ(a/åé)');
  result := Format('%s ıòàæ(a/åé)', [floorCount]);
end;

function Table2.enterHouseType: string;
var
  selectionMenu: SwitchMenu;
begin
  selectionMenu := SwitchMenu.Init(additional_textbutton[length(additional_textbutton)-1].GetStartX, additional_textbutton[length(additional_textbutton)-1].GetTopY,
                                  0, 0, 0);
  selectionMenu.addButton('ÒÈÏ: Êàìåííûé');
  selectionMenu.addButton('ÒÈÏ: Äåğåâÿííûé');
  selectionMenu.addButton('ÒÈÏ: Êàğêàñíûé');
  additional_textbutton[length(additional_textbutton)-1].clear;
  selectionMenu.Main;
  result := selectionMenu.buttons[selectionMenu.on_button].getText;
  selectionMenu.Destroy;
  //showPositionHint;
end;

function Table2.enterHouseNumber: string;
const
  homeNumberLength = 4;
begin
  write('ä.');
  enterHouseNumber := 'ä.' + enterNumber(homeNumberLength);
end;

function Table2.enterVillageName: string;
const
  nameLength = 45;
begin
  result := enterText(result, nameLength);
end;

function Table2.enterHouseArea: string;
var
  area: string[3];
begin
  area := enterNumber(3);
  write('ì2');
  result := Format('%sì2', [area])
end;

function Table2.enterTextFormat(InputField: TextButton): string;
begin
  inherited enterTextFormat(InputField);
  if on_horizontal_button = 1 then
    enterTextFormat := enterVillageName
  else if (InputField.getText() = '') or (readkey <> #13) then
  begin
    InputField.setText(deleteText(InputField.getText(), length(InputField.getText())));
    case on_horizontal_button of
       2: enterTextFormat := enterHouseNumber;
       3: enterTextFormat := enterHouseArea;
       4: enterTextFormat := enterFloorCount;
    end;
  end;
  InputField.border.Destroy;
  InputField.Destroy;
  if on_horizontal_button = 5 then
    enterTextFormat := enterHouseType;
end;

constructor Table3.Init(start_x, start_y, border_y, width, height: integer);
begin
  countColumn := 3;
  inherited Init(start_x, start_y, border_y, width, height, countColumn);
end;

function Table3.setHeadOfColumns(): Header;
begin
  setlength(result, countColumn);
  Result[0] := 'ÍÀÇÂÀÍÈÅ ÄÅÂÅËÎÏÅĞÀ';
  Result[1] := 'ÃÎÄÎÂÎÉ ÄÎÕÎÄ';
  Result[2] := 'ÀÄĞÅÑ';
end;

function Table3.enterTextFormat(InputField: TextButton): string;
begin
  inherited enterTextFormat(InputField);
  if on_horizontal_button = 1 then
    enterTextFormat := enterDeveloperName
  else if (InputField.getText() = '') or (readkey <> #13) then
  begin
    InputField.setText(deleteText(InputField.getText(), length(InputField.getText())));
    case on_horizontal_button of
      2: enterTextFormat := enterYearPayment;
      3: enterTextFormat := enterAddress;
    end;
  end;
  InputField.border.Destroy;
  InputField.Destroy;
end;

function Table3.enterDeveloperName: string;
const
  nameLength = 25;
begin
  result := enterText(result, nameLength);
end;

function Table3.enterYearPayment: string;
var
  thousands, hundreds: string;
begin
  result := '';
  thousands := enterNumber(3);
  write(' òûñ. ');
  hundreds := enterNumber(3);
  result := Format('%sòûñ. %s', [thousands, hundreds])
end;

function Table3.enterStreetName: string;
const
  theLongestStreetName = 34;
begin
  write('óë.');
  enterStreetName := 'óë.' + enterText(result, theLongestStreetName);
end;

function Table3.enterHomeNumber: string;
const
  homeNumberLength = 4;
begin
  write('ä.');
  enterHomeNumber := 'ä.' + enterNumber(homeNumberLength);
end;

function Table3.enterTownName: string;
const
  theLongestTownName = 25;
begin
  result := '';
  write('ã.');
  enterTownName := 'ã.' + enterText(result, theLongestTownName);
end;

function Table3.enterFlatNumber: string;
const
  flatNumber = 2;
begin
  write('ê.');
  enterFlatNumber := 'ê.' + enterNumber(flatNumber);
end;

function Table3.enterAddress: string;
begin
  result := '';
  result := enterStreetName;
  write(' ');
  result := result + ' ' + enterHomeNumber;
  write(' ');
  result := result + ' ' + enterFlatNumber;
  write(' ');
  result := result + ' ' + enterTownName;
  //result := ;
end;

end.
