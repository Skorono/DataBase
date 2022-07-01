unit tables;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, table_manipulation, base_graphic;

type
  SArray = array[1..7] of string;

  Table1 = class sealed (InheritedTableCls)
    constructor Init(start_x, start_y, border_y, width, height, abs_background: integer);
    procedure showPage;
    procedure showLine(lineNumber: integer);
    procedure showHead;
    function enterTextFormat: string;
    function setHeadOfColumns(): SArray;
    {function enterDateForm: string;}
    function checkDayFormat(day: string): boolean;
    function checkMonthFormat(month: string): boolean;
    function checkYearFormat(year: string): boolean;
    function checkOrganizationName(text: string): boolean;
    function enterOrganizationName: string;
    {procedure enterSubmissionForm;
    procedure enterNumberForm;
    procedure enterAddressForm;}
  end;

  Table2 = class sealed (InheritedTableCls)
    constructor Init(start_x, start_y, border_y, width, height, abs_background: integer);
    function setHeadOfColumns(): SArray;
    function enterTextFormat: string;
  end;

  Table3 = class sealed (InheritedTableCls)
    constructor Init(start_x, start_y, border_y, width, height, abs_background: integer);
    function setHeadOfColumns(): SArray;
    function enterTextFormat: string;
  end;

implementation
constructor Table1.Init(start_x, start_y, border_y, width, height, abs_background: integer);
begin
  inherited Init(start_x, start_y, border_y, width, height, abs_background);
end;

procedure Table1.showPage;
begin
  inherited showPage;
end;

procedure Table1.showLine(lineNumber: integer);
begin
  inherited showLine(lineNumber);
end;

procedure Table1.showHead;
begin
  inherited showHead;
end;

function Table1.enterTextFormat: string;
begin
  case on_horizontal_button of
    1: enterTextFormat := enterOrganizationName;
    {2: ;
    3: ;
    4: ;
    5: ;
    6: ;
    7: text := enterDateForm;}
  end;
end;

function Table1.setHeadOfColumns(): SArray;
begin
  Result[1] := 'Название';
  Result[2] := 'Адрес';
  Result[3] := 'Тип подчинения';
  Result[4] := 'Год основания';
  Result[5] := 'Номер лицензии';
  Result[6] := 'Номер аккредитации';
  Result[7] := 'Дата окончания действия аккредитации';
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

{procedure Table1.enterDateForm;
const
  otherLen = 2; { переименовать }
  yearLen = 4;
var
  x_, y_: integer;
  text: string;
begin
  x_ := 1;
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
  until (checkYearFormat(text));
end;                    }

function Table1.enterOrganizationName: string;
const
  MaxOrgNameSize = 100;
begin
  enterOrganizationName := enterText(MaxOrgNameSize);
end;

constructor Table2.Init(start_x, start_y, border_y, width, height, abs_background: integer);
begin
  inherited Init(start_x, start_y, border_y, width, height, abs_background);
end;

function Table2.setHeadOfColumns(): SArray;
begin
  Result[1] := 'Название';
  Result[2] := 'Адрес';
  Result[3] := 'Тип подчинения';
  Result[4] := 'Год основания';
  Result[5] := 'Номер лицензии';
  Result[6] := 'Номер аккредитации';
  Result[7] := 'Дата окончания действия аккредитации';
end;

function Table2.enterTextFormat: string;
begin

end;

constructor Table3.Init(start_x, start_y, border_y, width, height, abs_background: integer);
begin
  inherited Init(start_x, start_y, border_y, width, height, abs_background);
end;

function Table3.setHeadOfColumns(): SArray;
begin
  Result[1] := 'Название';
  Result[2] := 'Адрес';
  Result[3] := 'Тип подчинения';
  Result[4] := 'Год основания';
  Result[5] := 'Номер лицензии';
  Result[6] := 'Номер аккредитации';
  Result[7] := 'Дата окончания действия аккредитации';
end;

function Table3.enterTextFormat: string;
begin
end;
end.

