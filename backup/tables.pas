unit tables;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Crt, table_manipulation;

type
  Header = array of string;

  { Table1 }

  Table1 = class sealed (InheritedTableCls)
  private
    function enterDateForm: string;
    function enterFlatNumber: string;
    function enterLicence: string;
    function enterTownName: string;
    function enterYear: string;
    public
      constructor Init(start_x, start_y, border_y, width, height: integer);
      procedure showPage;
      procedure showLine(lineNumber: integer);
      procedure showHead;
      function enterStreetName: string;
      function enterTextFormat: string; override;
      function setHeadOfColumns(): Header; override;
      {function enterDateForm: string;}
      function checkDayFormat(day: string): boolean;
      function checkMonthFormat(month: string): boolean;
      function checkYearFormat(year: string): boolean;
      function checkOrganizationName(text: string): boolean;
      function enterOrganizationName: string;
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
      function enterTextFormat: string; override;
  end;

  Table3 = class sealed (InheritedTableCls)
    public
      constructor Init(start_x, start_y, border_y, width, height: integer);
      function setHeadOfColumns(): Header; override;
      function enterTextFormat: string; override;
  end;

implementation
constructor Table1.Init(start_x, start_y, border_y, width, height: integer);
begin
  countColumn := 7;
  inherited Init(start_x, start_y, border_y, width, height, countColumn);
end;

procedure Table1.showPage;
begin
  inherited;
end;

procedure Table1.showLine(lineNumber: integer);
begin
  inherited;
end;

procedure Table1.showHead;
begin
  inherited;
end;

function Table1.enterTextFormat: string;
begin
  case on_horizontal_button of
    1: enterTextFormat := enterOrganizationName;
    2: enterTextFormat := enterAddress;
    {3: ;}
    4: enterTextFormat := enterYear;
    {5: ;
    6: ;                       }
    7: enterTextFormat := enterDateForm;
  end;
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
  enterStreetName := 'óë.' + enterText(34);
end;

function Table1.enterHomeNumber: string;
begin
  write('ä.');
  enterHomeNumber := 'ä.' + enterNumber(4);
end;

function Table1.enterTownName: string;
begin
  write('ã.');
  enterTownName := enterText(25);
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

function Table1.enterOrganizationName: string;
const
  MaxOrgNameSize = 100;
begin
  enterOrganizationName := enterText(MaxOrgNameSize);
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
begin
  enterLicence := '¹' + enterNumber(8);
end;

constructor Table2.Init(start_x, start_y, border_y, width, height: integer);
begin
  countColumn := 4;
  setBackground(8);
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

function Table2.enterTextFormat: string;
begin

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

function Table3.enterTextFormat: string;
begin
end;
end.

