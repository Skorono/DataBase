unit tables;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, db_representation, SysUtils, Crt, GeneralTypes, table_manipulation, base_graphic;

type
  { Table1 }
  Table1 = class sealed (InheritedTableCls)
  private
    //function enterAccreditation: string;
    //function enterDateForm: string;
    //function enterDayInDate: string;
    //function enterFlatNumber: string;
    //function enterLicence: string;
    //function enterMonthInDate: string;
    //function enterTownName: string;
    //function enterTypeOfSubordination: string;
    //function enterYear: string;
    //function enterYearInDate: string;
    //function checkDayFormat(day: string): boolean;
    //function checkMonthFormat(month: string): boolean;
    //function checkYearFormat(year: string): boolean;
    //function checkVillageName(text: string): boolean;
    function enterVillageName(text: string): string;
    function enterArea: string;
    function enterInhabitantsCount: string;
    //function enterAddress: string;
    //function enterHomeNumber: string;
    //function enterStreetName: string;
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
    function enterFloorCount: string;
    function enterHouseNumber: string;
    function enterHouseArea: string;
    //function enterNameOfTheInstitution: string;
    //function enterNumberOfSeats: string;
    //function enterSpecialtyCode: string;
    public
      constructor Init(start_x, start_y, border_y, width, height: integer);
      function setHeadOfColumns(): Header; override;
      function enterTextFormat(InputField: TextButton): string; override;
  end;

  { Table3 }

  Table3 = class sealed (InheritedTableCls)
  private
    function enterAddress: string;
    function enterFlatNumber: string;
    function enterHomeNumber: string;
    function enterStreetName: string;
    function enterTownName: string;
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
  Result[0] := 'НАЗВАНИЕ';
  Result[1] := 'ДЕВЕЛОПЕР';
  Result[2] := 'ПЛОЩАДЬ';
  Result[3] := 'КОЛИЧЕСТВО ЖИТЕЛЕЙ';
end;

//function Table1.checkDayFormat(day: string): boolean;
//const
//  lowerBoundOfTheDay = 0;
//  highestBoundOfTheDay = 32;
//var
//  int_day: integer;
//begin
//  if isInteger(day) then
//  begin
//    int_day := strtoint(day);
//    if ((int_day < highestBoundOfTheDay) and (int_day > lowerBoundOfTheDay)) then
//      result := true
//    else
//      result := false;
//  end
//  else
//    result := false;
//end;

//function Table1.checkMonthFormat(month: string): boolean;
//const
//  lowerBoundOfTheMonth = 0;
//  highestBoundOfTheMonth = 13;
//var
//  int_month: integer;
//begin
//  if isInteger(month) then
//  begin
//    int_month := strtoint(month);
//    if ((int_month < highestBoundOfTheMonth) and (int_month > lowerBoundOfTheMonth)) then
//      result := true
//    else
//      result := false;
//  end
//  else
//    result := false;
//end;

//function Table1.checkYearFormat(year: string): boolean;
//const
//  lowerBoundOfTheYear = 1723;
//  highestBoundOfTheYear = 2023;
//var
//  int_year: integer;
//begin
//  result := false;
//  if isInteger(year) then
//  begin
//    int_year := strtoint(year);
//    if ((int_year > lowerBoundOfTheYear) and (int_year < highestBoundOfTheYear)) then
//      result := true
//  end
//end;

//function Table1.checkVillageName(text: string): boolean;
//const
//  acceptSize = 100;
//begin
//  begin
//    if length(text) <= acceptSize then
//      result := true
//    else
//      result := false;
//  end;
//end;

//function Table1.enterDayInDate: string;
//const
//  countNumbersBeforeDot = 2;
//begin
//  enterDayInDate := enterNumber(countNumbersBeforeDot);
//  while not checkDayFormat(enterDayInDate) do
//  begin
//    enterDayInDate := deleteText(enterDayInDate, countNumbersBeforeDot);
//    enterDayInDate := enterNumber(countNumbersBeforeDot);
//  end;
//  enterDayInDate := enterDayInDate + '.';
//  write('.');
//end;

//function Table1.enterMonthInDate: string;
//const
//  countNumbersBeforeDot = 2;
//begin
//  enterMonthInDate := enterNumber(countNumbersBeforeDot);
//  while not checkMonthFormat(enterMonthInDate) do
//  begin
//    enterMonthInDate := deleteText(enterMonthInDate, countNumbersBeforeDot);
//    enterMonthInDate := enterNumber(countNumbersBeforeDot);
//  end;
//  enterMonthInDate := enterMonthInDate + '.';
//  write('.');
//end;

//function Table1.enterYearInDate: string;
//const
//  countDigitsInYear = 4;
//begin
//  enterYearInDate := enterNumber(countDigitsInYear);
//  while not checkYearFormat(enterYearInDate) do
//  begin
//    enterYearInDate := deleteText(enterYearInDate, countDigitsInYear);
//    enterYearInDate := enterNumber(countDigitsInYear);
//  end;
//end;

//function Table1.enterDateForm: string;
//begin
//  result := result + enterDayInDate;
//  result := result + enterMonthInDate;
//  result := result + enterYearInDate;
//end;
//

function Table1.enterVillageName(text: string): string;
const
  MaxOrgNameSize = 25; // Самое длинное название без пробелов среди населенных пунктов в России носит село Кременчуг-Константиновское в Кабардино-Балкарской республике, в нем 25 букв, сообщил «Яндекс». =)
begin
  enterVillageName := enterText(text, MaxOrgNameSize);
end;

function Table1.enterArea(): string;
begin
  result := enterNumber(2) + '.';
  write('.');
  result := result + enterNumber(2) + 'км2';
  write('км2');
end;

function Table1.enterInhabitantsCount: string;
const
  maxThousandsCount = 12;
  minThousandsCount = 3;
var
  thousands: string[2];
  hundreds: string[3];
begin
  thousands := '';
  repeat
    thousands := deleteText(thousands, 2);
    thousands := enterNumber(2);
  until (strToInt(thousands) >= minThousandsCount) and (strToInt(thousands) < maxThousandsCount); // меньше - село, больше - город
  write('тыс. ');

  hundreds := enterNumber(3); // TODO: Поменять название переменной
  write(' чел.');
  result := Format('%s тыс. %s чел.', [thousands, hundreds]);
end;

//function Table1.enterYear: string;
//const
//  countNumberInYear = 4;
//begin
//  repeat
//    enterYear := enterNumber(countNumberInYear);
//    if not checkYearFormat(enterYear) then
//      enterYear := deleteText(enterYear, length(enterYear));
//  until length(enterYear) > 0;
//  enterYear := enterYear + ' г.';
//end;

//function Table1.enterLicence: string;
//const
//  licenseType = 'ЛО1';
//begin
//  enterLicence := enterNumber(2) + licenseType + '-№';
//  write(licenseType + '-№');
//  enterLicence := enterLicence + enterNumber(7);
//end;

//function Table1.enterAccreditation: string;
//const
//  accreditationType = 'АО1';
//begin
//  enterAccreditation := enterNumber(2) + accreditationType + '-№';
//  write(accreditationType + '-№');
//  enterAccreditation := enterAccreditation + enterNumber(7);
//end;

//function Table1.enterTypeOfSubordination: string;
//var
//  mmenu: Menu;
//begin
//  mmenu := Menu.Init(x_border div 2, y_border div 2, (x_border div 2) + 8, (y_border div 2) + 15, 0);
//  mmenu.addButton('Федеральный');
//  mmenu.addButton('Региональный');
//  mmenu.main;
//  result := mmenu.buttons[mmenu.on_button].getText;
//  mmenu.Destroy;
//  showPage;
//end;

constructor Table2.Init(start_x, start_y, border_y, width, height: integer);
begin
  countColumn := 5;
  inherited Init(start_x, start_y, border_y, width, height, countColumn);
end;

function Table2.setHeadOfColumns(): Header;
begin
  setlength(result, countColumn);
  Result[0] := 'ПОСЕЛОК'; // пока хз чё тут
  Result[1] := 'НОМЕР ДОМА';
  Result[2] := 'ПЛОЩАДЬ ДОМА';
  Result[3] := 'КОЛИЧЕСТВО ЭТАЖЕЙ';
  Result[4] := 'ТИП ДОМА'; // и тут хз
end;

function Table2.enterFloorCount: string;
const
  maxFloorCount = 59;
var
  floorCount: string;
begin
  floorCount := '';
  repeat
    floorCount := deleteText(floorCount, 2);
    floorCount := enterNumber(2);
  until (strToInt(floorCount) <= maxFloorCount ); // Интересный факт: самое высокое здание в Московской области находится в Химках и в нём 59 этажей)
  write(' этаж(ей)');
  result := Format('%s этаж(ей)', [floorCount]);
end;

function Table2.enterHouseNumber: string;
const
  homeNumberLength = 4;
begin
  write('д.');
  enterHouseNumber := 'д.' + enterNumber(homeNumberLength);
end;

function Table2.enterHouseArea: string;
var
  area: string[3];
begin
  area := enterNumber(3);
  write('м2');
  result := Format('%sм2', [area])
end;

//function Table2.enterNameOfTheInstitution: string;
//const
//  theLongestInstitutionName = 80;
//begin
//  result := '';
//  while result = '' do
//  begin
//    result := enterText(result, theLongestInstitutionName);
//    if isString(result) and isInteger(result) then
//      result := deleteText(result, length(result));
//  end;
//end;

//function Table2.enterSpecialtyCode: string;
//const
//  numberCount = 3;
//  numbersLength = 2;
//var
//  i: byte = 0;
//begin
//  result := '';
//  while i < numberCount do
//  begin
//    result := result + enterNumber(numbersLength);
//    if i < numberCount - 1 then
//    begin
//      result := result + '.';
//      write('.');
//    end;
//    i := i + 1;
//  end
//end;

//function Table2.enterNumberOfSeats: string;
//const
//  postscript = ' мест(о/a)';
//  digitsCountInNumber = 3;
//begin
//  result := enterNumber(digitsCountInNumber) + postscript;
//  write(postscript);
//end;

function Table2.enterTextFormat(InputField: TextButton): string;
begin
  inherited enterTextFormat(InputField);
  if on_horizontal_button = 1 then
    //enterTextFormat :=
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
end;

constructor Table3.Init(start_x, start_y, border_y, width, height: integer);
begin
  countColumn := 3;
  inherited Init(start_x, start_y, border_y, width, height, countColumn);
end;

function Table3.setHeadOfColumns(): Header;
begin
  setlength(result, countColumn);
  Result[0] := 'НАЗВАНИЕ ДЕВЕЛОПЕРА';
  Result[1] := 'ГОДОВОЙ ДОХОД';
  Result[2] := 'АДРЕС';
end;

function Table3.enterTextFormat(InputField: TextButton): string;
begin
  inherited enterTextFormat(InputField);
  if on_horizontal_button = 1 then
    //enterTextFormat :=
  else if (InputField.getText() = '') or (readkey <> #13) then
  begin
    InputField.setText(deleteText(InputField.getText(), length(InputField.getText())));
    case on_horizontal_button of
      //1: enterTextFormat := enterNumberOfSpeciality;
      3: enterTextFormat := enterAddress;
    end;
  end;
  InputField.border.Destroy;
  InputField.Destroy;
end;

function Table3.enterStreetName: string;
const
  theLongestStreetName = 34;
begin
  write('ул.');
  enterStreetName := 'ул.' + enterText(result, theLongestStreetName);
end;

function Table3.enterHomeNumber: string;
const
  homeNumberLength = 4;
begin
  write('д.');
  enterHomeNumber := 'д.' + enterNumber(homeNumberLength);
end;

function Table3.enterTownName: string;
const
  theLongestTownName = 25;
begin
  write('г.');
  enterTownName := 'г.' + enterText(result, theLongestTownName);
end;

function Table3.enterFlatNumber: string;
const
  flatNumber = 2;
begin
  write('к.');
  enterFlatNumber := 'к.' + enterNumber(flatNumber);
end;

function Table3.enterAddress: string;
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

end.
