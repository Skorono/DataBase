unit table_manipulation;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Storage, Crt, base_graphic;

type
  SArray = array[1..7] of string;
  InheritedTableCls = class
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
    procedure switchPage(key: char);
    procedure deleteLine(lineNumber: integer);
    procedure LineLighting(lineNumber, color: integer);
    procedure turnOffDeleteLight();
    procedure showPosition;
    procedure showLine(lineNumber: integer);
    procedure nextPage;
    procedure previousPage;
    procedure createInputField(width, height, x_, y_: integer);
    procedure positional_hint;
    procedure Key_UP;
    procedure Key_DOWN;
    procedure Key_RIGHT;
    procedure Key_Left;
    procedure DelKey_UP;
    procedure DelKey_DOWN;
    function getFirstLineNumber: integer;
    function isInteger(text: string): boolean;
    function isString(text: string): boolean;
    function deleteText(text: string; delCount: integer): string;
    function enterText(symbolsCount: integer): string;
    function calculationLineCount: integer;
    function setHeadOfColumns(): SArray;
    function enterTextFormat: string;
  end;

  generic ViewTable<_T> = class
    strict private
      table: _T;
    public
      constructor Init(start_x, start_y, border_y, width, height, abs_background: integer);
      procedure main;
      procedure DeleteMode;
      procedure WriteMode;
  end;

implementation

constructor InheritedTableCls.Init(start_x, start_y, border_y, width, height, abs_background: integer);
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

function InheritedTableCls.calculationLineCount: integer;
var
  lineSize, headSize: integer;
begin
  headSize := head_height + (borderFreeSpace*2);
  lineSize := head_height + borderFreeSpace;
  result := (y_border - ((borderFreeSpace div 2) + headSize)) div lineSize;
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

function InheritedTableCls.setHeadOfColumns(): SArray;
begin
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
  last_line := Pages[pageNumber-1].getNode(Pages[pageNumber-1].nodeCount);
  x_pos := (last_line^.data[countColumn].x_pos + last_line^.data[countColumn].button_width + borderFreeSpace) - MAX_TEXT_SIZE;
  y_pos := last_line^.data[countColumn].y_pos + borderFreeSpace;
  inf_button := TextButton.Init(MAX_TEXT_SIZE, 1, x_pos, y_pos, 0, position);
  inf_button.Show;
end;

procedure InheritedTableCls.show_head;
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

procedure InheritedTableCls.setCellPosition(lineNum: integer);
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

function InheritedTableCls.getFirstLineNumber: integer;
begin
  if pageCount <> 1 then
    result := Pages[pageCount-1].nodeCount
  else
    result := 1;
end;

procedure InheritedTableCls.createNewPage();
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

procedure InheritedTableCls.showLine(lineNumber: integer);
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

procedure InheritedTableCls.showPage();
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

procedure InheritedTableCls.nextPage; { Написать удалеие предыдущей строки }
begin
  if pageNumber <> pageCount then
    pageCount := pageCount + 1;
  pageNumber := pageNumber + 1;
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

function InheritedTableCls.enterText(symbolsCount: integer): string;
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

function InheritedTableCls.enterTextFormat: string;
begin
end;

procedure InheritedTableCls.createInputField(width, height, x_, y_: integer);
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

procedure InheritedTableCls.writeInCell;
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

procedure InheritedTableCls.LineLighting(lineNumber, color: integer);
var
  i: integer;
begin
  line := Pages[pageCount-1].getNode(lineNumber);
  for i := 1 to countColumn do
    line^.data[i].border.ChangeBackground(color);
end;

procedure InheritedTableCls.turnOffDeleteLight();
begin
  line := Pages[pageNumber-1].getNode(on_vertical_button);
  LineLighting(on_vertical_button, 0);
  window(x, y, x_border, y_border);
  gotoxy(line^.data[1].x_pos, line^.data[1].y_pos);
end;

procedure InheritedTableCls.deleteLine(lineNumber: integer);
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

procedure InheritedTableCls.DelKey_UP;
begin
  LineLighting(on_vertical_button, 0);
  Key_UP;
  LineLighting(on_vertical_button, 7);
end;

procedure InheritedTableCls.DelKey_DOWN;
begin
  LineLighting(on_vertical_button, 0);
  Key_DOWN;
  LineLighting(on_vertical_button, 7);
end;

procedure InheritedTableCls.Key_UP();
begin
  if on_vertical_button = 1 then
    on_vertical_button := Pages[pageNumber-1].nodeCount
  else
    on_vertical_button := on_vertical_button - 1;
end;

procedure InheritedTableCls.Key_DOWN();
begin
  if on_vertical_button = Pages[pageNumber-1].nodeCount then
    on_vertical_button := 1
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

constructor ViewTable.Init(start_x, start_y, border_y, width, height, abs_background: integer);
begin
  table := table.Init(start_x, start_y, border_y, width, height, abs_background);
end;

procedure ViewTable.Main;
var
  key: char;
begin
  table.showPage;
  table.showPosition;
  key := ' ';
  window(table.x, table.y, table.x_border, table.y_border);
  table.line := table.Pages[table.pageCount-1].getNode(table.getFirstLineNumber);
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
  table.line := table.Pages[table.pageCount-1].getNode(table.on_vertical_button);
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
      table.line := table.Pages[table.pageCount-1].getNode(table.on_vertical_button);
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
  table.LineLighting(table.on_vertical_button, 7);
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
    table.deleteLine(table.on_vertical_button);
  end;
  until (key = #27);
  table.turnOffDeleteLight;
end;

begin
end.

