unit table_manipulation;

{$mode ObjFPC}{$H+}

interface

uses
  base_graphic, Classes, Crt, GeneralTypes, SysUtils, Storage;

type
  CellArray = array of Cell;

  { InheritedTableCls }
  InheritedTableCls = class
      procedure Key_UP;
      procedure Key_DOWN;
      procedure Key_RIGHT;
      procedure Key_Left;
      procedure DelKey_UP;
      procedure DelKey_DOWN;
      procedure SwitchHeadButton_Left(var on_headButton: byte);
      procedure SwitchHeadButton_Right(var on_headButton: byte);
      procedure PutButtonOnEachOther(number: byte);
      procedure PutButtonsOnEachOther(fromButton, toButton: byte);
  private
    procedure additionalTextDelete;
    procedure cellsDelete;
    procedure createPositionHint;
    procedure headerDelete;
  public
    countColumn: byte; { вернуть в strict protected }
    on_vertical_button, on_horizontal_button,
    background, head_width, head_height, elementsNumber,
    x, y, x_border, y_border, lineCount, borderFreeSpace: byte;
    pageNumber, pageCount: word;
    head_buttons: array of Cell;
    additional_textbutton: array of TextButton;
    lineList: Cls_List;

    constructor Init(start_x, start_y, border_y, width, height, columnCount: byte;
      abs_background: byte=0; addaptive: boolean=false);
    destructor Destroy; override;
    procedure showPage;
    procedure showPositionHint;
    procedure showLine(lineNumber: word);
    procedure showHead;
    procedure createNewPage;
    procedure clearHeadButtons;
    {procedure createPage;}
    procedure writeInCell;
    procedure switchPage(key: char);
    procedure deleteLine(lineNumber: byte);
    procedure LineLighting(lineNumber, color: byte);
    procedure turnOffDeleteLight;
    procedure nextPage;
    procedure previousPage;
    procedure positional_hint;
    procedure addaptiveToSize(Xborder: byte);
    procedure SetBackground(abs_background: byte);
    procedure SortTable(column: byte);
    procedure Save(fName: string);
    procedure enterSavePath(field: TextButton);
    function createInputField(x_, y_, last_y: word): TextButton;
    function getFirstLineNumber(page: word): word;
    function deleteText(text: string; delCount: byte): string;
    function enterText(text: string; symbolsCount: byte): string;
    function enterNumber(digitsCount: byte): string;
    function calculationLineCount: byte;
    function setHeadOfColumns(): Header; virtual;
    function getLineYPosition(lineNum: word): word;
    function enterTextFormat(InputField: TextButton): string; virtual;
  end;

implementation

constructor InheritedTableCls.Init(start_x, start_y, border_y, width, height, columnCount: byte; abs_background: byte = 0; addaptive: boolean=false);
begin
  countColumn := columnCount;
  borderFreeSpace := 2;
  on_horizontal_button := 1;
  on_vertical_button := 1;
  head_height := height;
  x := start_x;
  y := start_y;
  background := abs_background;
  y_border := border_y;
  elementsNumber := 100;
  pageNumber := 1;
  pageCount := 0;
  lineCount := calculationLineCount;
  lineList := Cls_List.Init;
  setlength(head_buttons, countColumn);
  if addaptive then
    addaptiveToSize(75)
  else
    head_width := width;
  showHead;
  //SetBackground(background);
  createNewPage;
  positional_hint;
  createPositionHint;
  showPositionHint;
end;

procedure InheritedTableCls.clearHeadButtons;
var
  button: byte;
begin
  for button := 0 to countColumn - 1 do
    head_buttons[button].border.clearBorder;
end;

procedure InheritedTableCls.SetBackground(abs_background: byte);
begin
  window(x, y, x_border, y_border);
  TextBackground(abs_background);
  background := abs_background;
  ClrScr;
end;

function InheritedTableCls.calculationLineCount: byte;
var
  lineSize, headSize: integer;
begin
  headSize := head_height + (borderFreeSpace*2);
  lineSize := head_height + (borderFreeSpace div 2);
  result := (y_border - headSize - (x-1)) div lineSize;
end;

procedure InheritedTableCls.positional_hint;
const
  height = 1;
  hintCount = 4;
var
  hint: TextButton;
  text: array[1..hintCount] of string = ('ESC - выход из программы/выход из режима', 'Ctrl + A - EditMode',
                                          'Ctrl + D - DeleteMode', 'Ctrl + <- / -> - Переключение между страницами');
  line: PLine;
  i, pos_x, pos_y: integer;
begin
  line := lineList.getNode(1);
  pos_x := line^.data[countColumn].x_pos + line^.data[countColumn].button_width + (borderFreeSpace * 2);
  pos_y := line^.data[countColumn].y_pos;
  for i := 1 to hintCount do
  begin
    setlength(additional_textbutton, length(additional_textbutton) + 1);
    hint := TextButton.Init(length(text[i]), height, pos_x, pos_y, background, text[i]);
    hint.show;
    additional_textbutton[length(additional_textbutton)-1] := hint;
    inc(pos_y);
  end;
end;

procedure InheritedTableCls.createPositionHint;
const
  MAX_TEXT_SIZE = 35;
var
  last_line: PLine;
  x_pos, y_pos: byte;
  inf_button: TextButton;
begin
  last_line := lineList.getNode(lineCount);
  x_pos := abs((last_line^.data[countColumn].x_pos + last_line^.data[countColumn].button_width + borderFreeSpace) - MAX_TEXT_SIZE);
  y_pos := last_line^.data[countColumn].y_pos + borderFreeSpace;
  inf_button := TextButton.Init(MAX_TEXT_SIZE, 1, x_pos, y_pos, background, '');
  setlength(additional_textbutton, length(additional_textbutton) + 1);
  additional_textbutton[length(additional_textbutton) - 1] := inf_button;
end;

procedure InheritedTableCls.showPositionHint;
begin
  additional_textbutton[length(additional_textbutton) - 1].text := 'страница: ' + inttostr(pageNumber) + ' строка: ' + inttostr(on_vertical_button) + ' ячейка: ' + inttostr(on_horizontal_button);
  additional_textbutton[length(additional_textbutton) - 1].Show;
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
    head_buttons[i] := Cell.Init(head_width, head_height, x_pos, y_pos, background, columnHeader[i]);
    head_buttons[i].Border := border.Init('-', borderFreeSpace, borderFreeSpace, x_pos, y_pos, y_pos, head_width);
    head_buttons[i].Border.ChangeColor(1);
    head_buttons[i].Border.ChangeBackground(background);
    head_buttons[i].Show;
    x_pos := x_pos + head_width + borderFreeSpace;
  end;
  x_border := head_buttons[countColumn-1].x_pos + head_buttons[countColumn-1].button_width + head_buttons[countColumn-1].border.XborderFreeSpace;
end;

function InheritedTableCls.getLineYPosition(lineNum: word): word;
begin
  result := (head_buttons[1].y_pos + (borderFreeSpace+1)) + ((lineNum-1) mod lineCount) * borderFreeSpace;
end;

function InheritedTableCls.getFirstLineNumber(page: word): word;
begin
    result := (lineCount * (page-1)) + 1;
end;

procedure InheritedTableCls.addaptiveToSize(Xborder: byte);
begin
  head_width := trunc(Xborder * 1/countColumn);
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
      Cells[j] := Cell.Init(head_width, head_height, head_buttons[j].x_pos, y_line_pos, background, '');
      Cells[j].Border := Border.Init('-', borderFreeSpace-1, borderFreeSpace-1, head_buttons[j].x_pos, y_line_pos, y_line_pos, head_width);
    end;
    lineList.add_line(Cells);
  end;
end;

procedure InheritedTableCls.showLine(lineNumber: word);
var
  i: integer;
  line: PLine;
begin
  line := lineList.getNode(getFirstLineNumber(pageNumber) + (lineNumber-1));
  for i := 1 to countColumn do
  begin
      line^.data[i].Border.ChangeColor(1);
      line^.data[i].Border.ChangeBackground(background);
      line^.data[i].show;
  end;
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
  showPositionHint;
end;

procedure InheritedTableCls.previousPage;
begin
  if pageNumber <> 1 then
  begin
    pageNumber := pageNumber - 1;
    showPage();
    showPositionHint;
  end;
end;

procedure InheritedTableCls.switchPage(key: char);
begin
  if key = #116 then
    nextPage()
  else if key = #115 then
    previousPage();
end;

function InheritedTableCls.enterText(text: string; symbolsCount: byte): string;
var
  key: char;
begin
  key := ' ';
  result := '';
  while key <> #13 do
  begin
    key := readkey;
    if (isString(key) or (key in ['-', '/', '\'])) and (symbolsCount > length(text)) then
    begin
      text := text + key;
      write(key);
    end
    else if (key = #8) and (text <> '')then
      text := deleteText(text, 1)
    else if key = #32 then
    begin
      text := text + ' ';
      write(' ');
    end;
  end;
  result := text;
end;

function InheritedTableCls.enterNumber(digitsCount: byte): string;
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
    else if (key = #8) and (result <> '') then
      result := deleteText(result, 1)
    else if key = #32 then
    begin
      result := result + ' ';
      write(' ');
    end;
  end;
  if result = '' then
    result := ' ';
  while (result[1] = '0') and (result <> '') and (length(result) > 1) do
    result := result[2..length(result)];
end;

function InheritedTableCls.deleteText(text: string; delCount: byte): string;
const
  stepDel = 1;
var
  x_, y_, count: integer;
begin
  x_ := whereX;
  y_ := whereY;
  count := delCount;
  repeat
    x_ := x_ - stepDel;
    gotoxy(x_, y_);
    write(' ');
    count := count - 1;
  until count = 0;
  gotoxy(x_, y_);
  deleteText := copy(text, 1, length(text) - delCount);
end;

function InheritedTableCls.createInputField(x_, y_, last_y: word): TextButton;
const
  height = 1;
begin
  createInputField := TextButton.Init(last_y, height, x_, y_, 0, '');
  createInputField.Border := Border.Init('-', borderFreeSpace-1, borderFreeSpace-1, x_, y_, y_, last_y);
  createInputField.show;
  createInputField.Border.ChangeColor(15);
  gotoxy(1 + borderFreeSpace, 1 + (borderFreeSpace-1));
end;

procedure InheritedTableCls.writeInCell;
var
  line, lastLineInTable: PLine;
  x_, y_, width: integer;
  InputField: TextButton;
begin
  lastLineInTable := lineList.getNode(lineCount);
  x_ := lastLineInTable^.data[1].x_pos;
  y_ := lastLineInTable^.data[countColumn].y_pos + (borderFreeSpace * 2);
  width := lastLineInTable^.data[countColumn].x_pos + lastLineInTable^.data[countColumn].button_width - borderFreeSpace;
  line := lineList.getNode(getFirstLineNumber(pageNumber) + (on_vertical_button-1));
  InputField := createInputField(x_, y_, width);
  InputField.text := line^.data[on_horizontal_button].text;
  line^.data[on_horizontal_button].text := enterTextFormat(InputField);
  line^.data[on_horizontal_button].show;
  gotoxy(line^.data[on_horizontal_button].x_pos, line^.data[on_horizontal_button].y_pos);
end;

procedure InheritedTableCls.LineLighting(lineNumber, color: byte);
var
  i: integer;
  line: PLine;
begin
  line := lineList.getNode(lineNumber);
  for i := 1 to countColumn do
    line^.data[i].border.ChangeBackground(color);
end;

procedure InheritedTableCls.turnOffDeleteLight();
var
  line: PLine;
begin
  line := lineList.getNode(getFirstLineNumber(pageNumber) + (on_vertical_button-1));
  LineLighting(getFirstLineNumber(pageNumber) + (on_vertical_button-1), 0);
  window(x, y, x_border, y_border);
  gotoxy(line^.data[1].x_pos, line^.data[1].y_pos);
end;

procedure InheritedTableCls.deleteLine(lineNumber: byte);
var
  i: integer;
  line: PLine;
begin
  Linelist.delete(lineNumber);
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
    on_vertical_button := getFirstLineNumber(pageNumber) + (lineCount-1)   {баг с номером строки}
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

procedure InheritedTableCls.Key_Left;
begin
  if on_horizontal_button = 1 then
    on_horizontal_button := countColumn
  else
    on_horizontal_button := on_horizontal_button - 1;
end;

procedure InheritedTableCls.headerDelete;
var
  cell: byte;
begin
  for cell := 0 to countColumn-1 do
  begin
    head_buttons[cell].Border.Destroy;
    head_buttons[cell].Destroy;
  end;

end;

procedure InheritedTableCls.cellsDelete;
var
  cell, linenum: byte;
  page: word;
  line: PLine;
begin
  for page := 1 to pageCount do
  begin
    for linenum := 0 to lineCount-1 do
    begin
      line := lineList.getNode(getFirstLineNumber(page) + linenum);
      for cell := 1 to countColumn do
      begin
        line^.data[cell].Border.Destroy;
        line^.data[cell].Destroy;
      end;
    end;
  end;
end;

procedure InheritedTableCls.additionalTextDelete;
var
  cell: byte;
begin
  for cell := 0 to length(additional_textbutton) - 1 do
    additional_textbutton[cell].Destroy;
end;

function InheritedTableCls.setHeadOfColumns: Header;
begin
end;

function InheritedTableCls.enterTextFormat(InputField: TextButton): string;
begin
  write(InputField.text);
end;

procedure InheritedTableCls.SortTable(column: byte);
var
  j, i: integer;
  line: PLine;
begin
  for j := 0 to lineList.nodeCount - 1 do
  begin
    line := lineList.getNode(1);
    for i := 2 to lineList.nodeCount - j do
    begin
      line := line^.next;
      if (line^.data[column].text[1] < line^.previous^.data[column].text[1]) and (isString(line^.previous^.data[column].text[1])) then
      begin
        lineList.insert(line, line^.previous);
        line := line^.next;
      end;
    end;
  end;
end;


procedure InheritedTableCls.PutButtonOnEachOther(number: byte);
begin
  if (number <> 0) and (number < countColumn) then
  begin
    head_buttons[number].x_pos := (head_buttons[number-1].x_pos + head_buttons[number-1].button_width) div 2;
    head_buttons[number].border.start_x := head_buttons[number].x_pos - 1;
  end;
end;

procedure InheritedTableCls.PutButtonsOnEachOther(fromButton, toButton: byte);
var
  button: byte;
begin
  if (fromButton >= 0) and (fromButton < countColumn) then
  begin
    for button := fromButton to toButton do
      PutButtonOnEachOther(button);
  end;
end;

procedure InheritedTableCls.SwitchHeadButton_Right(var on_headButton: byte);
begin
  clearHeadButtons;
  if on_headButton <> countColumn-1 then
  begin
    on_headButton := on_headButton + 1;
    PutButtonOnEachOther(on_headButton);
    head_buttons[on_headButton].show;
    head_buttons[on_headButton].border.show;
    PutButtonsOnEachOther(on_headButton+2, countColumn);
  end;
end;

procedure InheritedTableCls.SwitchHeadButton_Left(var on_headButton: byte);
begin
  clearHeadButtons;
  if on_headButton <> 0 then
  begin
    PutButtonsOnEachOther(on_headButton + 1, countColumn);
    on_headButton := on_headButton - 1;
    head_buttons[on_headButton].show;
    head_buttons[on_headButton].border.show;
    //PutButtonOnEachOther(on_headButton+1);
  end;
end;

procedure InheritedTableCls.enterSavePath(field: TextButton);
var
  flag: boolean;
begin
  flag := false;
  while not flag do
  begin
    field.text := readkey;
    if (field.text[1] in ['C'..'z']) and not (field.text[1] in ['a', 'b']) then
    begin
      //if field.text[1] in ['a'..'z'] then
      //  field.text := chr(ord(field.text[1]) - 32);
      field.text := UpCase(field.text[1]);
      write(field.text + ':\');
      field.text := field.text + ':\';
      flag := true;
    end
    else
      field.text := '';
  end;
  field.text := enterText(field.text, trunc(field.button_width - (field.button_width/3)));
end;

procedure InheritedTableCls.Save(fName: string);
begin
  lineList.save(fName);
end;

destructor InheritedTableCls.Destroy;
begin
  headerDelete;
  cellsDelete;
  additionalTextDelete;
  lineList.Destroy;
end;

begin
end.

