unit tables;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, db_representation, SysUtils, Crt, GeneralTypes, table_manipulation, base_graphic;

type
  { Table1 }
  Table1 = class sealed (InheritedTableCls)
  private
    function enterAccreditation: string;
    function enterDateForm: string;
    function enterFlatNumber: string;
    function enterLicence: string;
    function enterTownName: string;
    function enterTypeOfSubordination: string;
    function enterYear: string;
  public
    constructor Init(start_x, start_y, border_y, width, height: integer);
    procedure showPage;
    procedure showLine(lineNumber: word);
    procedure showHead;
    function enterStreetName: string;
    function enterTextFormat(InputField: TextButton): string; override;
    function setHeadOfColumns(): Header; override;
    {function enterDateForm: string;}
    function checkDayFormat(day: string): boolean;
    function checkMonthFormat(month: string): boolean;
    function checkYearFormat(year: string): boolean;
    function checkOrganizationName(text: string): boolean;
    function enterOrganizationName(text: string): string;
    function enterAddress: string;
    function enterHomeNumber: string;
    {procedure enterSubmissionForm;
    procedure enterNumberForm;
    procedure enterAddressForm;}
  end;

  { Table2 }

  Table2 = class sealed (InheritedTableCls)
  private
    function enterNameOfTheInstitution: string;
    function enterNumberOfSeats: string;
    function enterSpecialtyCode: string;
    public
      constructor Init(start_x, start_y, border_y, width, height: integer);
      function setHeadOfColumns(): Header; override;
      function enterTextFormat(InputField: TextButton): string; override;
  end;

  { Table3 }

  Table3 = class sealed (InheritedTableCls)
  private
    function enterDurationOfLearning: string;
    function enterName: string;
    function enterNumberOfSpeciality: string;
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
  countColumn := 7;
  //win := WindowManager.Init;
  //win.createNewWindow(1, 1, 170, 5, 7);
  //win.createNewWindow(120, 1, 220, 50, 7);
  //for i := 1 to win.activeWindows do
  //  win.showWindow(i);
  inherited Init(start_x, start_y, border_y, width, height, countColumn, 0, true);
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
  case on_horizontal_button of
    1: enterTextFormat := enterOrganizationName(InputField.getText);
    2: enterTextFormat := enterAddress;
    4: enterTextFormat := enterYear;
    5: enterTextFormat := enterLicence;
    6: enterTextFormat := enterAccreditation;
    7: enterTextFormat := enterDateForm;
  end;
  InputField.border.Destroy;
  InputField.Destroy;
  if on_horizontal_button = 3 then
    enterTextFormat := enterTypeOfSubordination;
end;

function Table1.setHeadOfColumns(): Header;
begin
  setlength(result, countColumn);
  Result[0] := 'ÍÀÇÂÀÍÈÅ';
  Result[1] := 'ÀÄĞÅÑ';
  Result[2] := 'ÒÈÏ ÏÎÄ×ÈÍÅÍÈß';
  Result[3] := 'ÃÎÄ ÎÑÍÎÂÀÍÈß';
  Result[4] := 'ÍÎÌÅĞ ËÈÖÅÍÇÈÈ';
  Result[5] := 'ÍÎÌÅĞ ÀÊÊĞÅÄÈÒÀÖÈÈ';
  Result[6] := 'ÄÀÒÀ ÎÊÎÍ×ÀÍÈß ÄÅÉÑÒÂÈß ÀÊÊĞÅÄÈÒÀÖÈÈ';
end;

function Table1.checkDayFormat(day: string): boolean;
const
  lowerBoundOfTheDay = 0;
  highestBoundOfTheDay = 13;
var
  int_day: integer;
begin
  if isInteger(day) then
  begin
    int_day := strtoint(day);
    if ((int_day < highestBoundOfTheDay) and (int_day > lowerBoundOfTheDay)) then
      result := true
    else
      result := false;
  end
  else
    result := false;
end;

function Table1.checkMonthFormat(month: string): boolean;
const
  lowerBoundOfTheMonth = 0;
  highestBoundOfTheMonth = 13;
var
  int_month: integer;
begin
  if isInteger(month) then
  begin
    int_month := strtoint(month);
    if ((int_month < highestBoundOfTheMonth) and (int_month > lowerBoundOfTheMonth)) then
      result := true
    else
      result := false;
  end
  else
    result := false;
end;

function Table1.checkYearFormat(year: string): boolean;
const
  lowerBoundOfTheYear = 1723;
  highestBoundOfTheYear = 2023;
var
  int_year: integer;
begin
  result := false;
  if isInteger(year) then
  begin
    int_year := strtoint(year);
    if ((int_year > lowerBoundOfTheYear) and (int_year < highestBoundOfTheYear)) then
      result := true
  end
end;

function Table1.checkOrganizationName(text: string): boolean;
const
  acceptSize = 100;
begin
  begin
    if length(text) <= acceptSize then
      result := true
    else
      result := false;
  end;
end;

function Table1.enterDateForm: string;
const
  otherLen = 2; { ïåğåèìåíîâàòü }
  yearLen = 4;
var
  x_, y_: integer;
  text: string;
begin
 { x_ := 1;
  y_ := 1;

  write('  .  .');
  gotoxy(x_ + otherLen, y_);
  repeat
    deleteText(otherLen);
    enterText(otherLen);
  until (checkDayFormat(text));

  x_ := x_ + otherLen;
  gotoxy(x_ + otherLen, y_);
  repeat
    deleteText(otherLen);
    enterText(otherLen);
    write(text);
  until (checkMonthFormat(text));

  x_ := x_ + otherLen;
  gotoxy(x_ + yearLen, y_);
  repeat
    deleteText(yearLen);
    enterText(yearLen);
  until (checkYearFormat(text)); }
end;

function Table1.enterStreetName: string;
const
  theLongestStreetName = 34;
begin
  write('óë.');
  enterStreetName := 'óë.' + enterText(result, theLongestStreetName);
end;

function Table1.enterHomeNumber: string;
const
  homeNumberLength = 4;
begin
  write('ä.');
  enterHomeNumber := 'ä.' + enterNumber(homeNumberLength);
end;

function Table1.enterTownName: string;
const
  theLongestTownName = 25;
begin
  write('ã.');
  enterTownName := enterText(result, theLongestTownName);
end;

function Table1.enterFlatNumber: string;
const
  flatNumber = 2;
begin
  write('ê.');
  enterFlatNumber := 'ê.' + enterNumber(flatNumber);
end;

function Table1.enterAddress: string;
begin
  result := enterStreetName;
  write(' ');
  result := result + ' ' + enterHomeNumber;
  write(' ');
  result := result + ' ' + enterFlatNumber;
  write(' ');
  result := result + ' ' + enterTownName;
  //result := ;
end;

function Table1.enterOrganizationName(text: string): string;
const
  MaxOrgNameSize = 80;
begin
  enterOrganizationName := enterText(text, MaxOrgNameSize);
end;

function Table1.enterYear: string;
const
  countNumberInYear = 4;
begin
  repeat
    enterYear := enterNumber(countNumberInYear);
    if not checkYearFormat(enterYear) then
      enterYear := deleteText(enterYear, length(enterYear));
  until length(enterYear) > 0;
  enterYear := enterYear + ' ã.';
end;

function Table1.enterLicence: string;
const
  licenseType = 'ËÎ1';
begin
  enterLicence := enterNumber(2) + licenseType + '-¹';
  write(licenseType + '-¹');
  enterLicence := enterLicence + enterNumber(7);
end;

function Table1.enterAccreditation: string;
const
  accreditationType = 'ÀÎ1';
begin
  enterAccreditation := enterNumber(2) + accreditationType + '-¹';
  write(accreditationType + '-¹');
  enterAccreditation := enterAccreditation + enterNumber(7);
end;

function Table1.enterTypeOfSubordination: string;
var
  mmenu: Menu;
begin
  mmenu := Menu.Init(x_border div 2, y_border div 2, (x_border div 2) + 8, (y_border div 2) + 15, 0);
  mmenu.addButton('Ôåäåğàëüíûé');
  mmenu.addButton('Ğåãèîíàëüíûé');
  mmenu.main;
  result := mmenu.buttons[mmenu.on_button].getText;
  mmenu.Destroy;
  showPage;
end;

constructor Table2.Init(start_x, start_y, border_y, width, height: integer);
begin
  countColumn := 4;
  inherited Init(start_x, start_y, border_y, width, height, countColumn);
end;

function Table2.setHeadOfColumns(): Header;
begin
  setlength(result, countColumn);
  Result[0] := 'Ó×ĞÅÆÄÅÍÈÅ';
  Result[1] := 'ÑÏÅÖÈÀËÜÍÎÑÒÜ';
  Result[2] := 'ÊÎËÈ×ÅÑÒÂÎ ÁŞÄÆÅÒÍÛÕ ÌÅÑÒ';
  Result[3] := 'ÊÎËÈ×ÅÑÒÂÎ ÊÎÌÌÅĞ×ÅÑÊÈÕ ÌÅÑÒ';
end;

function Table2.enterNameOfTheInstitution: string;
const
  theLongestInstitutionName = 80;
begin
  result := '';
  while result = '' do
  begin
    result := enterText(result, theLongestInstitutionName);
    if isString(result) and isInteger(result) then
      result := deleteText(result, length(result));
  end;
end;

function Table2.enterSpecialtyCode: string;
const
  numberCount = 3;
  numbersLength = 2;
var
  i: byte = 0;
  intermediateText: string = '';
begin
  result := '';
  while i < numberCount do
  begin
    intermediateText := enterText(intermediateText, numbersLength);
    if isInteger(intermediateText) then
    begin
      result := result + intermediateText;
      if i < numberCount - 1 then
      begin
        result := result + '.';
        write('.');
      end;
      i := i + 1;
      intermediateText := '';
    end
    else
      intermediateText := deleteText(intermediateText, numbersLength);
  end;
end;

function Table2.enterNumberOfSeats: string;
const
  postscript = ' ìåñò(î/a)';
  digitsCountInNumber = 3;
begin
  result := enterNumber(digitsCountInNumber) + postscript;
  write(postscript);
end;

function Table2.enterTextFormat(InputField: TextButton): string;
begin
  inherited enterTextFormat(InputField);

  case on_horizontal_button of
      1: enterTextFormat := enterNameOfTheInstitution;
      2: enterTextFormat := enterSpecialtyCode;
      3: enterTextFormat := enterNumberOfSeats;
      4: enterTextFormat := enterNumberOfSeats;
    end;
  InputField.border.Destroy;
  InputField.Destroy;
end;

constructor Table3.Init(start_x, start_y, border_y, width, height: integer);
begin
  countColumn := 3;
  inherited Init(start_x, start_y, border_y, width, height, countColumn);
end;

function Table3.setHeadOfColumns(): Header;
begin
  setlength(result, countColumn);
  Result[0] := 'Íîìåğ';
  Result[1] := 'Íàçâàíèå';
  Result[2] := 'Äëèòåëüíîñòü îáó÷åíèÿ';
end;

function Table3.enterNumberOfSpeciality: string;
const
  digitsInNumber = 4;
begin
  write('¹');
  result := '¹' + enterNumber(digitsInNumber);
end;

function Table3.enterName: string;
const
  nameLength = 80;
begin
  result := '';
  while result = '' do
  begin
    result := enterText(result, nameLength);
    if isString(result) and isInteger(result) then
      result := deleteText(result, length(result));
  end;
end;

function Table3.enterDurationOfLearning: string;
const
  postScriptum = 'a';
begin

end;

function Table3.enterTextFormat(InputField: TextButton): string;
begin
  inherited enterTextFormat(InputField);

  case on_horizontal_button of
      1: enterTextFormat := enterNumberOfSpeciality;
      2: enterTextFormat := enterName;
      3: enterTextFormat := enterDurationOfLearning;
  end;
  InputField.border.Destroy;
  InputField.Destroy;
end;
end.

