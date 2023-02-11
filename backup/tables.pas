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
    function enterDayInDate: string;
    function enterFlatNumber: string;
    function enterLicence: string;
    function enterMonthInDate: string;
    function enterTownName: string;
    function enterTypeOfSubordination: string;
    function enterYear: string;
    function enterYearInDate: string;
    function checkDayFormat(day: string): boolean;
    function checkMonthFormat(month: string): boolean;
    function checkYearFormat(year: string): boolean;
    function checkOrganizationName(text: string): boolean;
    function enterOrganizationName(text: string): string;
    function enterAddress: string;
    function enterHomeNumber: string;
    function enterStreetName: string;
  public
    constructor Init(start_x, start_y, border_y, width, height: integer);
    procedure showPage;
    procedure showLine(lineNumber: word);
    procedure showHead;
    function enterTextFormat(InputField: TextButton): string; override;
    function setHeadOfColumns(): Header; override;
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
    function enterDatePart: string;
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
  countColumn := 4;
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
  if (on_horizontal_button <> 3) then
  begin
    if on_horizontal_button = 1 then
      enterTextFormat := enterOrganizationName(InputField.getText)
    else if (InputField.getText() = '') or (readkey <> #13) then
    begin
      InputField.setText(deleteText(InputField.getText(), length(InputField.getText())));
      case on_horizontal_button of
        2: enterTextFormat := enterAddress;
        4: enterTextFormat := enterYear;
        5: enterTextFormat := enterLicence;
        6: enterTextFormat := enterAccreditation;
        7: enterTextFormat := enterDateForm;
      end;
    end;
    InputField.border.Destroy;
    InputField.Destroy;
  end
  else
  begin
    InputField.border.Destroy;
    InputField.Destroy;
    enterTextFormat := enterTypeOfSubordination;
  end;
end;

function Table1.setHeadOfColumns(): Header;
begin
  setlength(result, countColumn);
  Result[0] := 'ÍÀÇÂÀÍÈÅ';
  Result[1] := 'ÄÅÂÅËÎÏÅĞ';
  Result[2] := 'ÏËÎÙÀÄÜ';
  Result[3] := 'ÊÎËÈ×ÅÑÒÂÎ ÆÈÒÅËÅÉ';
end;

function Table1.checkDayFormat(day: string): boolean;
const
  lowerBoundOfTheDay = 0;
  highestBoundOfTheDay = 32;
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

function Table1.enterDayInDate: string;
const
  countNumbersBeforeDot = 2;
begin
  enterDayInDate := enterNumber(countNumbersBeforeDot);
  while not checkDayFormat(enterDayInDate) do
  begin
    enterDayInDate := deleteText(enterDayInDate, countNumbersBeforeDot);
    enterDayInDate := enterNumber(countNumbersBeforeDot);
  end;
  enterDayInDate := enterDayInDate + '.';
  write('.');
end;

function Table1.enterMonthInDate: string;
const
  countNumbersBeforeDot = 2;
begin
  enterMonthInDate := enterNumber(countNumbersBeforeDot);
  while not checkMonthFormat(enterMonthInDate) do
  begin
    enterMonthInDate := deleteText(enterMonthInDate, countNumbersBeforeDot);
    enterMonthInDate := enterNumber(countNumbersBeforeDot);
  end;
  enterMonthInDate := enterMonthInDate + '.';
  write('.');
end;

function Table1.enterYearInDate: string;
const
  countDigitsInYear = 4;
begin
  enterYearInDate := enterNumber(countDigitsInYear);
  while not checkYearFormat(enterYearInDate) do
  begin
    enterYearInDate := deleteText(enterYearInDate, countDigitsInYear);
    enterYearInDate := enterNumber(countDigitsInYear);
  end;
end;

function Table1.enterDateForm: string;
begin
  result := result + enterDayInDate;
  result := result + enterMonthInDate;
  result := result + enterYearInDate;
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
begin
  result := '';
  while i < numberCount do
  begin
    result := result + enterNumber(numbersLength);
    if i < numberCount - 1 then
    begin
      result := result + '.';
      write('.');
    end;
    i := i + 1;
  end
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
  if on_horizontal_button = 1 then
    enterTextFormat := enterNameOfTheInstitution
  else if (InputField.getText() = '') or (readkey <> #13) then
  begin
    deleteText(InputField.getText(), length(InputField.getText()));
    InputField.setText('');
    case on_horizontal_button of
        2: enterTextFormat := enterSpecialtyCode;
        3: enterTextFormat := enterNumberOfSeats;
        4: enterTextFormat := enterNumberOfSeats;
      end;
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
  Result[0] := 'ÍÀÇÂÀÍÈÅ ÄÅÂÅËÎÏÅĞÀ';
  Result[1] := 'ÃÎÄÎÂÎÉ ÄÎÕÎÄ';
  Result[2] := 'ÀÄĞÅÑ';
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

function Table3.enterDatePart(): string;
begin
  result := '';
  while (result = '') do
  begin
    deleteText(result, 2);
    result := enterNumber(2);
  end;
end;

function Table3.enterDurationOfLearning: string;
var
  monthNumber: integer;
begin
  result := '';
  result := result + enterDatePart;
  write(' ãîä(à)/ëåò ');
  result := result + ' ãîä(à)/ëåò ';

  monthNumber := strToInt(enterDatePart);
  while (monthNumber > 11) do
  begin
    result := result + intToStr(monthNumber);
    result := deleteText(result, 2);
    monthNumber := strToInt(enterDatePart);
  end;

  result := result + intToStr(monthNumber);
  write(' ìåñÿö(à/åâ)');
  result := result + ' ìåñÿö(à/åâ)';
end;

function Table3.enterTextFormat(InputField: TextButton): string;
begin
  inherited enterTextFormat(InputField);
  if on_horizontal_button = 2 then
    enterTextFormat := enterName
  else if (InputField.getText() = '') or (readkey <> #13) then
  begin
    InputField.setText(deleteText(InputField.getText(), length(InputField.getText())));
    case on_horizontal_button of
      1: enterTextFormat := enterNumberOfSpeciality;
      3: enterTextFormat := enterDurationOfLearning;
    end;
  end;
  InputField.border.Destroy;
  InputField.Destroy;
end;

begin
end.
