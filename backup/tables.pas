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

  Table2 = class sealed (InheritedTableCls)
    public
      constructor Init(start_x, start_y, border_y, width, height: integer);
      function setHeadOfColumns(): Header; override;
      function enterTextFormat(InputField: TextButton): string; override;
  end;

  Table3 = class sealed (InheritedTableCls)
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
  if on_horizontal_button <> 3 then
  begin
    case on_horizontal_button of
      1: enterTextFormat := enterOrganizationName(InputField.text);
      2: enterTextFormat := enterAddress;
      4: enterTextFormat := enterYear;
      5: enterTextFormat := enterLicence;
      6: enterTextFormat := enterAccreditation;
      7: enterTextFormat := enterDateForm;
    end;
    InputField.border.Destroy;
    InputField.Destroy;
  end
  else
  begin
    InputField.Border.Destroy;
    InputField.Destroy;
    enterTextFormat := enterTypeOfSubordination;
  end;
    {enterTextFormat := ;}
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
var
  int_day: integer;
begin
  if isInteger(day) then
  begin
    int_day := strtoint(day);
    if ((int_day < 32) and (int_day > 0)) then
      result := true
    else
      result := false;
  end
  else
    result := false;
end;

function Table1.checkMonthFormat(month: string): boolean;
var
  int_month: integer;
begin
  if isInteger(month) then
  begin
    int_month := strtoint(month);
    if ((int_month < 13) and (int_month > 0)) then
      result := true
    else
      result := false;
  end
  else
    result := false;
end;

function Table1.checkYearFormat(year: string): boolean;
var
  int_year: integer;
begin
  if isinteger(year) then
  begin
    int_year := strtoint(year);
    if ((int_year > 1990) and (int_year < 2023)) then
      result := true
    else
      result := false;
  end
  else
    result := false;
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
begin
  write('óë.');
  enterStreetName := 'óë.' + enterText(result, 34);
end;

function Table1.enterHomeNumber: string;
begin
  write('ä.');
  enterHomeNumber := 'ä.' + enterNumber(4);
end;

function Table1.enterTownName: string;
begin
  write('ã.');
  enterTownName := enterText(result, 25);
end;

function Table1.enterFlatNumber: string;
begin
  write('ê.');
  enterFlatNumber := 'ê.' + enterNumber(2);
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
  MaxOrgNameSize = 100;
begin
  enterOrganizationName := text;
  enterOrganizationName := enterText(result, MaxOrgNameSize);
end;

function Table1.enterYear: string;
begin
  repeat
    enterYear := enterNumber(4);
    if (strtoint(enterYear) < 1400) or (strtoint(enterYear) > 2022) then
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
  i: integer;
begin
  mmenu := Menu.Init(x_border div 2, y_border div 2, (x_border div 2) + 8, (y_border div 2) + 15, 0);
  mmenu.addButton('Ôåäåğàëüíûé');
  mmenu.addButton('Ğåãèîíàëüíûé');
  mmenu.main;
  result := mmenu.buttons[mmenu.on_button].text;
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
  Result[0] := 'Ó÷ğåæäåíèå';
  Result[1] := 'Ñïåöèàëüíîñòü';
  Result[2] := 'Êîëè÷åñòâî áşäæåòíûõ ìåñò';
  Result[3] := 'Êîëè÷åñòâî êîììåğ÷åñêèõ ìåñò';
end;

function Table2.enterTextFormat(InputField: TextButton): string;
begin
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
  Result[2] := 'Äëèòåëüñíîñòü îáó÷åíèÿ';
end;

function Table3.enterTextFormat(InputField: TextButton): string;
begin
  InputField.border.Destroy;
  InputField.Destroy;
end;
end.

