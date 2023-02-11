unit example_file;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Storage, Crt, base_graphic;

type
  SArray = array[1..7] of string;
  InheritedBaseCls = class
    background, countColumn, head_width, head_height, on_vertical_button, on_horizontal_button, pageNumber, pageCount, elementsNumber: integer;
    x, y, x_border, y_border, y_line_pos, lineCount,on_page: integer;
    Cells: array[1..7] of Cell;
    head_buttons: array[1..7] of TextButton;
    Pages: array of Cls_List;
    line: PLine; {Не забыть переименовать}
    borderFreeSpace: integer;

    constructor Init(start_x, start_y, border_y, width, height, abs_background: integer);
    procedure showPage;
    procedure show_head;
    procedure createNewPage;
    procedure setCellPosition(lineNum: integer);
    {procedure createPage;}
    procedure writeInCell;
    procedure DeleteMode;
    procedure WriteMode;
    procedure switchPage(key: char);
    procedure deleteLine(lineNumber: integer);
    procedure LineLighting(lineNumber, color: integer);
    procedure turnOffDeleteLight();
    procedure showPosition;
    procedure showLine(lineNumber: integer);
    procedure nextPage;
    procedure previousPage;
    procedure createInputField(width, height, x_, y_: integer);
    {procedure enterDateForm;}
    procedure positional_hint;
    function enterOrganizationName: string;
    {procedure enterSubmissionForm;
    procedure enterNumberForm;
    procedure enterAddressForm;}
    procedure Key_UP;
    procedure Key_DOWN;
    procedure Key_RIGHT;
    procedure Key_Left;
    procedure DelKey_UP;
    procedure DelKey_DOWN;
    procedure main;
    function getFirstLineNumber: integer;
    //function enterDateForm: string;
    function deleteText(text: string; delCount: integer): string;
    function calculationLineCount: integer;
    function enterTextFormat: string;
    function enterText(symbolsCount: integer): string;
    function isInteger(text: string): boolean;
    function isString(text: string): boolean;
    function checkDayFormat(day: string): boolean;
    function checkMonthFormat(month: string): boolean;
    function checkYearFormat(year: string): boolean;
    function checkOrganizationName(text: string): boolean;
    function setHeadOfColumns(): SArray;
  end;

  ViewTable = class

  end;

implementation

constructor InheritedBaseCls.Init(start_x, start_y, border_y, width, height, abs_background: integer);
begin
  countColumn := 7;
  borderFreeSpace := 2;
  on_horizontal_button := 1;
  on_vertical_button := 1;
  head_width := width;
  head_height := height;
  x := start_x;
  y := start_y;
  y_border := border_y;
  background := abs_background;
  elementsNumber := 100;
  pageNumber := 1;
  pageCount := 0;
  lineCount := calculationLineCount;
  show_head;
  createNewPage;
  positional_hint;
end;

function InheritedBaseCls.calculationLineCount: integer;
var
  lineSize, headSize: integer;
begin
  headSize := head_height + (borderFreeSpace*2);
  lineSize := head_height + borderFreeSpace;
  result := (y_border - ((borderFreeSpace div 2) + headSize)) div lineSize;
end;

procedure InheritedBaseCls.positional_hint;
const
  height = 1;
var
  text: string;
  hint: TextButton;
  pos_x, pos_y: integer;
begin
  text := 'ESC - выход из программы/выход из режима';
  line := Pages[pageNumber-1].getNode(1);
  pos_x := line^.data[countColumn].x_pos + line^.data[countColumn].button_width + (borderFreeSpace * 2);
  pos_y := line^.data[countColumn].y_pos;
  hint := TextButton.Init(length(text), height, pos_x, pos_y, 0, text);
  hint.show;
  inc(pos_y);
  text := 'Ctrl + A - EditMode';
  hint := TextButton.Init(length(text), height, pos_x, pos_y, 0, text);
  hint.show;
  inc(pos_y);
  text := 'Ctrl + D - DeleteMode';
  hint := TextButton.Init(length(text), height, pos_x, pos_y, 0, text);
  hint.show;
  inc(pos_y);
  text := 'Ctrl + <- / -> - Переключение между страницами';
  hint := TextButton.Init(length(text), height, pos_x, pos_y, 0, text);
  hint.show;
end;

function InheritedBaseCls.setHeadOfColumns(): SArray;
begin
  Result[1] := 'Название';
  Result[2] := 'Адрес';
  Result[3] := 'Тип подчинения';
  Result[4] := 'Год основания';
  Result[5] := 'Номер лицензии';
  Result[6] := 'Номер аккредитации';
  Result[7] := 'Дата окончания действия аккредитации';
end;

procedure InheritedBaseCls.showPosition;
const
  MAX_TEXT_SIZE = 35;
var
  inf_button: TextButton;
  position: string;
  x_pos, y_pos: integer;
  last_line: PLine;
begin
  position := 'страница: ' + inttostr(pageNumber) + ' строка: ' + inttostr(on_vertical_button) + ' ячейка: ' + inttostr(on_horizontal_button);
  last_line := Pages[pageNumber-1].getNode(Pages[pageNumber-1].nodeCount);
  x_pos := (last_line^.data[countColumn].x_pos + last_line^.data[countColumn].button_width + borderFreeSpace) - MAX_TEXT_SIZE;
  y_pos := last_line^.data[countColumn].y_pos + borderFreeSpace;
  inf_button := TextButton.Init(MAX_TEXT_SIZE, 1, x_pos, y_pos, 0, position);
  inf_button.Show;
end;

procedure InheritedBaseCls.show_head;
var
  i: integer;
  columnHeader: SArray;
  x_pos, y_pos: integer;
begin
  x_pos := x + borderFreeSpace;
  y_pos := y + borderFreeSpace ;
  columnHeader := setHeadOfColumns;
  for i := 1 to countColumn do
  begin
    head_width := length(columnHeader[i]);
    head_buttons[i] := TextButton.Init(head_width, head_height, x_pos, y_pos, background, columnHeader[i]);
    head_buttons[i].Border := border.Init('-', borderFreeSpace, x_pos, y_pos, y_pos, head_width);
    head_buttons[i].Border.ChangeColor(1);
    head_buttons[i].Show;
    x_pos := x_pos + length(columnHeader[i]) + borderFreeSpace;
  end;
  x_border := head_buttons[countColumn].x_pos + head_buttons[countColumn].button_width + head_buttons[countColumn].border.borderFreeSpace;
end;

procedure InheritedBaseCls.setCellPosition(lineNum: integer);
begin
  line := Pages[pageNumber-1].getNode(lineNum);
  if lineNum > 1 then
  begin
    y_line_pos := line^.data[1].y_pos;
    y_line_pos := y_line_pos + ((borderFreeSpace * 2) - 2);
  end
  else
  begin
    y_line_pos := head_buttons[1].y_pos;
    y_line_pos := y_line_pos + ((borderFreeSpace * 2) - 1)
  end;
end;

function InheritedBaseCls.getFirstLineNumber: integer;
begin
  if pageCount <> 1 then
    result := Pages[pageCount-1].nodeCount
  else
    result := 1;
end;

procedure InheritedBaseCls.createNewPage();
var
  i, j: integer;
  s_text: string;
  lineNum: integer;
begin
  pageCount := pageCount + 1;
  lineNum := 1;
  setlength(Pages, pageCount);
  Pages[pageCount-1] := Cls_List.Init;
  Pages[pageCount-1].nodeCount := getFirstLineNumber;
  for i := 1 to lineCount do
  begin
    setCellPosition(lineNum);
    lineNum := lineNum + 1;
    for j := 1 to countColumn do
    begin
      s_text := '';
      Cells[j] := Cell.Init(length(head_buttons[j].text), head_height, head_buttons[j].x_pos, y_line_pos, background, s_text);
      Cells[j].Border := Border.Init('-', borderFreeSpace-1, head_buttons[j].x_pos, y_line_pos, y_line_pos, length(head_buttons[j].text));
    end;
    Pages[pageCount-1].add_line(Cells);
  end;
end;

procedure InheritedBaseCls.showLine(lineNumber: integer);
var
  i: integer;
begin
  window(x, y, x_border, y_border);
  line := Pages[pageCount-1].getNode(lineNumber);
  for i := 1 to countColumn do
  begin
      line^.data[i].show;
      line^.data[i].Border.ChangeColor(1);
  end;
end;

procedure InheritedBaseCls.showPage();
var
  lineNumber: integer;
begin
  lineNumber := 0;
  while LineNumber <= lineCount do
  begin
    lineNumber := lineNumber + 1;
    showLine(lineNumber);
  end;
end;

procedure InheritedBaseCls.nextPage; { Написать удалеие предыдущей строки }
begin
  if pageNumber <> pageCount then
    pageCount := pageCount + 1;
  pageNumber := pageNumber + 1;
  createNewPage;
  showPage();
  showPosition;
end;

procedure InheritedBaseCls.previousPage;
begin
  if pageNumber <> 1 then
  begin
    pageNumber := pageNumber - 1;
    showPage();
    showPosition;
  end;
end;

function InheritedBaseCls.isInteger(text: string): boolean;
var
  i: integer;
begin
  result := true;
  for i := 1 to length(text) do
  begin
    if not (text[i] in ['0'..'9']) then
      result := false;
  end;
end;

function InheritedBaseCls.checkDayFormat(day: string): boolean;
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

function InheritedBaseCls.checkMonthFormat(month: string): boolean;
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

function InheritedBaseCls.checkYearFormat(year: string): boolean;
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

function InheritedBaseCls.checkOrganizationName(text: string): boolean;
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

{procedure InheritedBaseCls.enterDateForm;
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

function InheritedBaseCls.enterOrganizationName: string;
const
  MaxOrgNameSize = 100;
begin
  enterOrganizationName := enterText(MaxOrgNameSize);
end;

procedure InheritedBaseCls.switchPage(key: char);
begin
  if key = #116 then
    nextPage()
  else if key = #115 then
    previousPage();
end;

function InheritedBaseCls.isString(text: string): boolean;
var
  i: integer;
begin
  result := false;
  for i := 1 to length(text) do
  begin
    if (text[i] in ['A'..'Z']) or (text[i] in ['a'..'z']) or (text[i] in ['А'..'Я']) or (text[i] in ['а'..'я']) or (text[i] in ['0'..'9'])  then
      result := true;
  end;
end;

function InheritedBaseCls.enterText(symbolsCount: integer): string;
var
  key: char;
  text: string;
begin
  key := ' ';
  text := '';
  while key <> #13 do
  begin
    key := readkey;
    if isString(key) and (symbolsCount > length(text)) then
    begin
      text := text + key;
      write(key);
    end
    else if key = #8 then
      text := deleteText(text, 1)
    else if key = #32 then
    begin
      text := text + ' ';
      write(' ');
    end;
  end;
  enterText := text;
end;

function InheritedBaseCls.deleteText(text: string; delCount: integer): string;
var
  x_, y_, stepDel, count: integer;
begin
  x_ := whereX;
  y_ := whereY;
  stepDel := 1;
  repeat
    count := delCount;
    x_ := x_ - stepDel;
    gotoxy(x_, y_);
    write(' ');
    count := count - 1;
  until count = 0;
  gotoxy(x_, y_);
  deleteText := copy(text, 1, length(text) - delCount);
end;

function InheritedBaseCls.enterTextFormat: string;
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

procedure InheritedBaseCls.createInputField(width, height, x_, y_: integer);
var
  input_field: TextButton;
begin
  line := Pages[pageNumber-1].getNode(on_vertical_button);
  input_field := TextButton.Init(width, height, x_, y_, 0, '');
  input_field.Border := Border.Init('-', borderFreeSpace-1, x_, y_, y_, width);
  input_field.show;
  input_field.Border.ChangeColor(15);
  gotoxy(1 + borderFreeSpace, 1 + (borderFreeSpace-1));
  line^.data[on_horizontal_button].text := enterTextFormat;
  input_field.del;
  input_field.border.del;
end;

procedure InheritedBaseCls.writeInCell;
const
  height = 1;
var
  x_, y_, width: integer;
begin
  line := Pages[pageNumber-1].getNode(lineCount);
  x_ := line^.data[1].x_pos;
  y_ := line^.data[countColumn].y_pos + (borderFreeSpace * 2);
  width := line^.data[countColumn].x_pos + line^.data[countColumn].button_width - borderFreeSpace;
  createInputField(width, height, x_, y_);

  line^.data[on_horizontal_button].show;
  window(x, y, x_border, y_border);
  gotoxy(line^.data[on_horizontal_button].x_pos, line^.data[on_horizontal_button].y_pos);
end;

procedure InheritedBaseCls.Main;
var
  key: char;
begin
  showPage;
  showPosition;
  key := ' ';
  window(x, y, x_border, y_border);
  line := Pages[pageCount-1].getNode(getFirstLineNumber);
  gotoxy(line^.data[1].x_pos, line^.data[1].y_pos);
  repeat
  key := readkey;
  case key of
    #1: WriteMode;
    #4: DeleteMode;
  end;
  switchPage(key);
  until (key = #27);
end;

procedure InheritedBaseCls.WriteMode; { Временно main}
var
  key: char;
begin
  showPosition;
  window(x, y, x_border, y_border);
  line := Pages[pageCount-1].getNode(on_vertical_button);
  gotoxy(line^.data[on_horizontal_button].x_pos, line^.data[on_horizontal_button].y_pos);
  repeat
    key := readkey;
    if key = #0 then
    begin
      case readkey of
        #72: Key_UP;
        #80: Key_DOWN;
        #75: Key_LEFT;
        #77: Key_RIGHT;
      end;
      showPosition;
      window(x, y, x_border, y_border);
      line := Pages[pageCount-1].getNode(on_vertical_button);
      gotoxy(line^.data[on_horizontal_button].x_pos, line^.data[on_horizontal_button].y_pos);
    end
    else if key = #13 then
    begin
      writeInCell;
    end;
  until key = #27;
end;

procedure InheritedBaseCls.LineLighting(lineNumber, color: integer);
var
  i: integer;
begin
  line := Pages[pageCount-1].getNode(lineNumber);
  for i := 1 to countColumn do
    line^.data[i].border.ChangeBackground(color);
end;

procedure InheritedBaseCls.turnOffDeleteLight();
begin
  line := Pages[pageNumber-1].getNode(on_vertical_button);
  LineLighting(on_vertical_button, 0);
  window(x, y, x_border, y_border);
  gotoxy(line^.data[1].x_pos, line^.data[1].y_pos);
end;

procedure InheritedBaseCls.deleteLine(lineNumber: integer);
var
  i: integer;
begin
  line := Pages[pageCount].getNode(lineNumber);
  for i := 1 to countColumn do
  begin
    line^.data[i].text := '';
    line^.data[i].show;
  end;
end;

procedure InheritedBaseCls.DeleteMode;
var
  key: char;
begin
  showPosition;
  key := ' ';
  on_horizontal_button := 1;
  on_vertical_button := 1;
  LineLighting(on_vertical_button, 7);
  repeat
  key := readkey;
  if key = #0 then
  begin
    case readkey of
      #72: DelKey_UP;
      #80: DelKey_DOWN;
    end;
    showPosition;
  end
  else if key = #4 then
  begin
    deleteLine(on_vertical_button);
  end;
  until (key = #27);
  turnOffDeleteLight()
end;

procedure InheritedBaseCls.DelKey_UP;
begin
  LineLighting(on_vertical_button, 0);
  Key_UP;
  LineLighting(on_vertical_button, 7);
end;

procedure InheritedBaseCls.DelKey_DOWN;
begin
  LineLighting(on_vertical_button, 0);
  Key_DOWN;
  LineLighting(on_vertical_button, 7);
end;

procedure InheritedBaseCls.Key_UP();
begin
  if on_vertical_button = 1 then
    on_vertical_button := Pages[pageNumber-1].nodeCount
  else
    on_vertical_button := on_vertical_button - 1;
end;

procedure InheritedBaseCls.Key_DOWN();
begin
  if on_vertical_button = Pages[pageNumber-1].nodeCount then
    on_vertical_button := 1
  else
    on_vertical_button := on_vertical_button + 1;
end;

procedure InheritedBaseCls.Key_RIGHT();
begin
  if on_horizontal_button = countColumn then
    on_horizontal_button := 1
  else
    on_horizontal_button := on_horizontal_button + 1;
end;

procedure InheritedBaseCls.Key_LEFT();
begin
  if on_horizontal_button = 1 then
    on_horizontal_button := countColumn
  else
    on_horizontal_button := on_horizontal_button - 1;
end;

begin
end.

