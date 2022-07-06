unit table_manipulation;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Storage, Crt, base_graphic;

type
  Header = array of string;
  InheritedTableCls = class
    strict protected
      countColumn: integer;
    private
      procedure Key_UP;
      procedure Key_DOWN;
      procedure Key_RIGHT;
      procedure Key_Left;
      procedure DelKey_UP;
      procedure DelKey_DOWN;

    public
      background, head_width, head_height, on_vertical_button, on_horizontal_button, elementsNumber: integer;
      x, y, x_border, y_border, lineCount: integer;
      pageNumber, pageCount: word;
      head_buttons: array of TextButton;
      lineList: Cls_List;
      line: PLine; {Не забыть переименовать}
      borderFreeSpace: integer;

      constructor Init(start_x, start_y, border_y, width, height, columnCount: integer);
      procedure showPage;
      procedure showPosition;
      procedure showLine(lineNumber: integer);
      procedure showHead;
      procedure createNewPage;
      {procedure createPage;}
      procedure writeInCell;
      procedure switchPage(key: char);
      procedure deleteLine(lineNumber: integer);
      procedure LineLighting(lineNumber, color: integer);
      procedure turnOffDeleteLight;
      procedure nextPage;
      procedure previousPage;
      procedure positional_hint;
      procedure SetBackground(abs_background: integer);
      function createInputField(): TextButton;
      function getFirstLineNumber(page: word): word;
      function isInteger(text: string): boolean;
      function isString(text: string): boolean;
      function deleteText(text: string; delCount: integer): string;
      function enterText(symbolsCount: integer): string;
      function enterNumber(digitsCount: integer): string;
      function calculationLineCount: integer;
      function setHeadOfColumns(): Header; virtual;
      function enterTextFormat: string; virtual;
      function getLineYPosition(lineNum: integer): integer;
  end;

  generic ViewTable<T> = class
      table: T;
    public
      procedure Main;
      procedure DeleteMode;
      procedure WriteMode;
  end;

implementation

constructor InheritedTableCls.Init(start_x, start_y, border_y, width, height, columnCount: integer);
begin
  countColumn := columnCount;
  borderFreeSpace := 2;
  on_horizontal_button := 1;
  on_vertical_button := 1;
  head_width := width;
  head_height := height;
  x := start_x;
  y := start_y;
  y_border := border_y;
  elementsNumber := 100;
  pageNumber := 1;
  pageCount := 0;
  lineCount := calculationLineCount;
  lineList := Cls_List.Init;
  setlength(head_buttons, countColumn);
  showHead;
  createNewPage;
  positional_hint;
end;

procedure InheritedTableCls.SetBackground(abs_background: integer);
begin
  background := abs_background;
end;

function InheritedTableCls.calculationLineCount: integer;
var
  lineSize, headSize: integer;
begin
  headSize := head_height + (borderFreeSpace*2);
  lineSize := head_height + borderFreeSpace;
  result := (y_border - headSize - (x-1)) div lineSize;
end;

procedure InheritedTableCls.positional_hint;
const
  height = 1;
var
  text: string;
  hint: TextButton;
  pos_x, pos_y: integer;
begin
  text := 'ESC - выход из программы/выход из режима';
  line := lineList.getNode(1);
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

procedure InheritedTableCls.showPosition;
const
  MAX_TEXT_SIZE = 35;
var
  inf_button: TextButton;
  position: string;
  x_pos, y_pos: integer;
  last_line: PLine;
begin
  position := 'страница: ' + inttostr(pageNumber) + ' строка: ' + inttostr(on_vertical_button) + ' ячейка: ' + inttostr(on_horizontal_button);
  last_line := lineList.getNode(lineCount);
  x_pos := (last_line^.data[countColumn].x_pos + last_line^.data[countColumn].button_width + borderFreeSpace) - MAX_TEXT_SIZE;
  y_pos := last_line^.data[countColumn].y_pos + borderFreeSpace;
  inf_button := TextButton.Init(MAX_TEXT_SIZE, 1, x_pos, y_pos, 0, position);
  inf_button.Show;
end;

procedure InheritedTableCls.showHead;
var
  i: integer;
  columnHeader: Header;
  x_pos, y_pos: integer;
begin
  x_pos := x + borderFreeSpace;
  y_pos := y + borderFreeSpace ;
  setlength(columnHeader, countColumn);
  columnHeader := setHeadOfColumns;
  for i := 0 to countColumn-1 do
  begin
    head_width := length(columnHeader[i]);
    head_buttons[i] := TextButton.Init(head_width, head_height, x_pos, y_pos, background, columnHeader[i]);
    head_buttons[i].Border := border.Init('-', borderFreeSpace, x_pos, y_pos, y_pos, head_width);
    head_buttons[i].Border.ChangeColor(1);
    head_buttons[i].Show;
    x_pos := x_pos + length(columnHeader[i]) + borderFreeSpace;
  end;
  x_border := head_buttons[countColumn-1].x_pos + head_buttons[countColumn-1].button_width + head_buttons[countColumn-1].border.borderFreeSpace;
end;

function InheritedTableCls.getLineYPosition(lineNum: integer): integer;
begin
  result := (head_buttons[1].y_pos + (borderFreeSpace+1)) + ((lineNum-1) mod lineCount) * borderFreeSpace;
end;

function InheritedTableCls.getFirstLineNumber(page: word): word;
begin
    result := (lineCount * (page-1)) + 1;
end;

procedure InheritedTableCls.createNewPage();
var
  i, j: integer;
  lineNum, y_line_pos: integer;
  Cells: array of Cell;
begin
  lineNum := 1;
  pageCount := pageCount + 1;
  setlength(Cells, countColumn);
  for i := 1 to lineCount do
  begin
    y_line_pos := getLineYPosition(lineNum);
    lineNum := lineNum + 1;
    for j := 0 to countColumn-1 do
    begin
      Cells[j] := Cell.Init(length(head_buttons[j].text), head_height, head_buttons[j].x_pos, y_line_pos, background, '');
      Cells[j].Border := Border.Init('-', borderFreeSpace-1, head_buttons[j].x_pos, y_line_pos, y_line_pos, length(head_buttons[j].text));
    end;
    lineList.add_line(Cells);
  end;
end;

procedure InheritedTableCls.showLine(lineNumber: integer);
var
  i: integer;
begin
  line := lineList.getNode(getFirstLineNumber(pageNumber) + (lineNumber-1));
  for i := 1 to countColumn do
  begin
      line^.data[i].show;
      line^.data[i].Border.ChangeColor(1);
  end;
end;


function InheritedTableCls.setHeadOfColumns: Header;
begin
end;

procedure InheritedTableCls.showPage();
var
  lineNumber: integer;
begin
  cursoroff;
  lineNumber := 1;
  while lineNumber <= lineCount do
  begin
    showLine(lineNumber);
    lineNumber := lineNumber + 1;
  end;
  cursoron;
end;

procedure InheritedTableCls.nextPage; { Написать удалеие предыдущей строки }
begin
  pageNumber := pageNumber + 1;
  if pageNumber > pageCount then
    createNewPage;
  showPage();
  showPosition;
end;

procedure InheritedTableCls.previousPage;
begin
  if pageNumber <> 1 then
  begin
    pageNumber := pageNumber - 1;
    showPage();
    showPosition;
  end;
end;

function InheritedTableCls.isInteger(text: string): boolean;
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

procedure InheritedTableCls.switchPage(key: char);
begin
  if key = #116 then
    nextPage()
  else if key = #115 then
    previousPage();
end;

function InheritedTableCls.isString(text: string): boolean;
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

function InheritedTableCls.enterTextFormat: string;
begin
end;

function InheritedTableCls.enterText(symbolsCount: integer): string;
var
  key: char;
begin
  key := ' ';
  result := '';
  while key <> #13 do
  begin
    key := readkey;
    if isString(key) and (symbolsCount > length(result)) then
    begin
      result := result + key;
      write(key);
    end
    else if key = #8 then
      result := deleteText(result, 1)
    else if key = #32 then
    begin
      result := result + ' ';
      write(' ');
    end;
  end;
end;

function InheritedTableCls.enterNumber(digitsCount: integer): string;
var
  key: char;
begin
  key := ' ';
  while key <> #13 do
  begin
    key := readkey;
    if isInteger(key) and (digitsCount > length(result)) then
    begin
      result := result + key;
      write(key);
    end
    else if key = #8 then
      result := deleteText(result, 1)
    else if key = #32 then
    begin
      result := result + ' ';
      write(' ');
    end;
  end;
  if result = nil then
    result := ' ';
  while (result[1] = '0') and (result <> '') and (length(result) > 1) do
    result := result[2..length(result)];
end;

function InheritedTableCls.deleteText(text: string; delCount: integer): string;
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

function InheritedTableCls.createInputField(): TextButton;
const
  height = 1;
var
  x_, y_, width: integer;
begin
  line := lineList.getNode(lineCount);
  x_ := line^.data[1].x_pos;
  y_ := line^.data[countColumn].y_pos + (borderFreeSpace * 2);
  width := line^.data[countColumn].x_pos + line^.data[countColumn].button_width - borderFreeSpace;
  createInputField := TextButton.Init(width, height, x_, y_, 0, '');
  createInputField.Border := Border.Init('-', borderFreeSpace-1, x_, y_, y_, width);
  createInputField.show;
  createInputField.Border.ChangeColor(15);
end;

procedure InheritedTableCls.writeInCell;
var
  input_field: TextButton;
begin
  input_field := createInputField;
  gotoxy(1 + borderFreeSpace, 1 + (borderFreeSpace-1));
  line := lineList.getNode(getFirstLineNumber(pageNumber) + (on_vertical_button-1));
  line^.data[on_horizontal_button].text := enterTextFormat;
  line^.data[on_horizontal_button].show;
  input_field.del;
  input_field.border.del;

  window(x, y, x_border, y_border);
  gotoxy(line^.data[on_horizontal_button].x_pos, line^.data[on_horizontal_button].y_pos);
end;

procedure InheritedTableCls.LineLighting(lineNumber, color: integer);
var
  i: integer;
begin
  line := lineList.getNode(lineNumber);
  for i := 1 to countColumn do
    line^.data[i].border.ChangeBackground(color);
end;

procedure InheritedTableCls.turnOffDeleteLight();
begin
  line := lineList.getNode(getFirstLineNumber(pageNumber) + (on_vertical_button-1));
  LineLighting(getFirstLineNumber(pageNumber) + (on_vertical_button-1), 0);
  window(x, y, x_border, y_border);
  gotoxy(line^.data[1].x_pos, line^.data[1].y_pos);
end;

procedure InheritedTableCls.deleteLine(lineNumber: integer);
var
  i: integer;
begin
  line := lineList.getNode(lineNumber);
  for i := 1 to countColumn do
  begin
    line^.data[i].text := '';
    line^.data[i].show;
  end;
end;

procedure InheritedTableCls.DelKey_UP;
begin
  LineLighting(getFirstLineNumber(pageNumber) + (on_vertical_button-1), 0);
  Key_UP;
  LineLighting(getFirstLineNumber(pageNumber) + (on_vertical_button-1), 7);
end;

procedure InheritedTableCls.DelKey_DOWN;
begin
  LineLighting(getFirstLineNumber(pageNumber) + (on_vertical_button-1), 0);
  Key_DOWN;
  LineLighting(getFirstLineNumber(pageNumber) + (on_vertical_button-1), 7);
end;

procedure InheritedTableCls.Key_UP();
begin
  if on_vertical_button = getFirstLineNumber(pageNumber) then
    on_vertical_button := getFirstLineNumber(pageNumber) + (lineCount-1)
  else
    on_vertical_button := on_vertical_button - 1;
end;

procedure InheritedTableCls.Key_DOWN();
begin
  if on_vertical_button = getFirstLineNumber(pageNumber) + (lineCount-1) then
    on_vertical_button := getFirstLineNumber(pageNumber)
  else
    on_vertical_button := on_vertical_button + 1;
end;

procedure InheritedTableCls.Key_RIGHT();
begin
  if on_horizontal_button = countColumn then
    on_horizontal_button := 1
  else
    on_horizontal_button := on_horizontal_button + 1;
end;

procedure InheritedTableCls.Key_LEFT();
begin
  if on_horizontal_button = 1 then
    on_horizontal_button := countColumn
  else
    on_horizontal_button := on_horizontal_button - 1;
end;

procedure ViewTable.Main;
var
  key: char;
begin
  table := T.Init(2, 2, 56, 8, 1);
  table.showPage;
  table.showPosition;
  key := ' ';
  window(table.x, table.y, table.x_border, table.y_border);
  table.line := table.lineList.getNode(table.getFirstLineNumber(table.pageNumber) + (table.on_vertical_button-1));
  gotoxy(table.line^.data[1].x_pos, table.line^.data[1].y_pos);
  repeat
  key := readkey;
  case key of
    #1: WriteMode;
    #4: DeleteMode;
  end;
  table.switchPage(key);
  until (key = #27);
end;

procedure ViewTable.WriteMode; { Временно main}
var
  key: char;
begin
  table.showPosition;
  window(table.x, table.y, table.x_border, table.y_border);
  table.line := table.lineList.getNode(table.getFirstLineNumber(table.pageNumber) + (table.on_vertical_button-1));
  gotoxy(table.line^.data[table.on_horizontal_button].x_pos, table.line^.data[table.on_horizontal_button].y_pos);
  repeat
    key := readkey;
    if key = #0 then
    begin
      case readkey of
        #72: table.Key_UP;
        #80: table.Key_DOWN;
        #75: table.Key_LEFT;
        #77: table.Key_RIGHT;
      end;
      table.showPosition;
      window(table.x, table.y, table.x_border, table.y_border);
      table.line := table.lineList.getNode(table.getFirstLineNumber(table.pageNumber) + (table.on_vertical_button-1));
      gotoxy(table.line^.data[table.on_horizontal_button].x_pos, table.line^.data[table.on_horizontal_button].y_pos);
    end
    else if key = #13 then
    begin
      table.writeInCell;
    end;
  until key = #27;
end;

procedure ViewTable.DeleteMode;
var
  key: char;
begin
  table.showPosition;
  key := ' ';
  table.on_horizontal_button := 1;
  table.on_vertical_button := 1;
  table.LineLighting(table.getFirstLineNumber(table.pageNumber) + (table.on_vertical_button-1), 7);
  repeat
  key := readkey;
  if key = #0 then
  begin
    case readkey of
      #72: table.DelKey_UP;
      #80: table.DelKey_DOWN;
    end;
    table.showPosition;
  end
  else if key = #4 then
  begin
    table.deleteLine(table.getFirstLineNumber(table.pageNumber) + (table.on_vertical_button-1));
  end;
  until (key = #27);
  table.turnOffDeleteLight;
end;

begin
end.

