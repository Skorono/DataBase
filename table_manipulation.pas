unit table_manipulation;

{$mode ObjFPC}{$H+}

interface

uses
  base_graphic, Classes, Crt, db_representation, GeneralTypes, SysUtils, Storage;

type
  CellArray = array of Cell;

  { InheritedTableCls }

  // класс описывает логику работы таблицы
  InheritedTableCls = class
      procedure Key_UP;
      procedure Key_DOWN;
      procedure Key_RIGHT;
      procedure Key_Left;
      procedure DelKey_UP;
      procedure DelKey_DOWN;
      //procedure SwitchHeadButton_Left(var on_headButton: byte);
      //procedure SwitchHeadButton_Right(var on_headButton: byte);
      //procedure PutButtonOnEachOther(number: byte);
      //procedure PutButtonsOnEachOther(fromButton, toButton: byte);
  private
    procedure additionalTextDelete;
    procedure cellsDelete;
    procedure createPositionHint;
    function getCoordsOfTheLastLineOffset: Coords;
    procedure headerDelete;
  public
    countColumn: byte; { вернуть в strict protected }
    on_vertical_button, on_horizontal_button,
    background, head_width, head_height, elementsNumber,
    x, y, x_border, y_border, lineCount, borderFreeSpace: byte;
    pageNumber, pageCount: word;
    head_buttons: array of Cell;
    additional_textbutton: array of TextButton; // массив подсказок
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
    procedure deleteLine(lineNumber: word);
    procedure LineLighting(lineNumber, color: word);
    procedure turnOffDeleteLight;
    procedure nextPage;
    procedure previousPage;
    procedure positional_hint;
    procedure addaptiveToSize(Xborder: byte);
    procedure SetBackground(abs_background: byte);
    procedure SortTable(column: byte);
    procedure Save(fName: string);
    procedure Load(fName: string);
    procedure Search(text: string; column: byte);
    procedure enterSavePath(field: TextButton);
    function createInputField(x_, y_, width: word): TextButton;
    function createSelectionMenu: SwitchMenu;
    function getFirstLineNumber(page: word): word;
    function getCellCoords(lineNumber: word; cellNumber: byte): Coords;
    function getHeadCellCoords(cellNumber: byte): Coords;
    function deleteText(text: string; delCount: byte): string;
    function enterText(text: string; symbolsCount: byte): string;
    function enterNumber(digitsCount: byte): string;
    function calculationLineCount: byte;
    // устанавливает названия столбцов
    function setHeadOfColumns(): Header; virtual;
    // определяет формат ввода по столбцу
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
  lineList := Cls_List.Init(countColumn);   // инициализация списка с определенным количеством столбцов
  setlength(head_buttons, countColumn);     // устанавливаем размер динамическому массиву
  if addaptive then                         // адаптирует размер таблицы под экран устройства
    addaptiveToSize(35)
  else
    head_width := width;
  showHead;
  createNewPage;
  positional_hint;                          // создает подсказки по управлению БД
  createPositionHint;                       // создает подсказку о позиции на странице
  showPositionHint;                         // отрисовываем подсказку
end;

procedure InheritedTableCls.clearHeadButtons;
var
  button: byte;
begin
  for button := 0 to countColumn - 1 do
    head_buttons[button].border.clear;
end;

procedure InheritedTableCls.SetBackground(abs_background: byte);
begin
  window(x, y, x_border, y_border);
  TextBackground(abs_background);
  background := abs_background;
  ClrScr;
end;

// считает количество линий на странице
function InheritedTableCls.calculationLineCount: byte;
var
  lineSize, headSize: integer;
begin
  headSize := head_height + (borderFreeSpace*2);   // высота шапки
  lineSize := head_height + (borderFreeSpace div 2); // высота линии
  result := (y_border - headSize - (x-1)) div lineSize;  // отнимаем от количества символов высоту шапки и x (координата положения таблицы) и делим на высоту одной линии
end;

procedure InheritedTableCls.positional_hint;
const
  height = 1;
  hintCount = 8;
var
  hint: TextButton;
  text: array[1..hintCount] of string = ('ESC - выход из режима/выход из программы', 'Ctrl + A - EditMode',
                                          'Ctrl + P - SortMode', 'Ctrl + F - Search',
                                          'Ctrl + D - DeleteMode', 'Ctrl + S - Save',
                                          'Ctrl + L - Load', 'Ctrl + <- / -> - Переключение между страницами');
  line: PLine;
  i, pos_x, pos_y: integer;
begin
  line := lineList.getNode(1);
  pos_x := line^.data[countColumn].GetStartX + line^.data[countColumn].GetWidth + (borderFreeSpace * 2);
  pos_y := line^.data[countColumn].GetTopY;
  for i := 1 to hintCount do
  begin
    setlength(additional_textbutton, length(additional_textbutton) + 1);
    hint := TextButton.Init(length(text[i]), height, pos_x, pos_y, background, text[i]);
    hint.show;
    additional_textbutton[length(additional_textbutton)-1] := hint;
    inc(pos_y);
  end;
end;

// получение координат клетки
function InheritedTableCls.getCellCoords(lineNumber: word; cellNumber: byte): Coords;
var
  lineNode: PLine;
begin
  lineNode := lineList.getNode(lineNumber); // получаем строку по её номеру из списка
  result[1] := lineNode^.data[cellNumber].GetStartX; // получаем координаты ячейки из строки по её номеру.
  result[2] := lineNode^.data[cellNumber].GetTopY;
end;

function InheritedTableCls.getHeadCellCoords(cellNumber: byte): Coords; // возвращает координаты заголовочного столбца
begin
  result[1] := head_buttons[cellNumber].GetStartX;
  result[2] := head_buttons[cellNumber].GetTopY;
end;

function InheritedTableCls.getCoordsOfTheLastLineOffset: Coords; // возвращает координаты последней строки со сдвигом от неё
begin
  result := getCellCoords(lineCount, countColumn);
  result[1] := result[1] + head_width + borderFreeSpace;
  result[2] := result[2] + borderFreeSpace;
end;

procedure InheritedTableCls.createPositionHint;
const
  MAX_TEXT_SIZE = 35;
var
  offSetCoords: Coords;
  x_pos, y_pos: byte;
  inf_button: TextButton;
begin
  offSetCoords := getCoordsOfTheLastLineOffset;
  x_pos := abs(offSetCoords[1] - MAX_TEXT_SIZE);
  y_pos := offSetCoords[2];
  inf_button := TextButton.Init(MAX_TEXT_SIZE, 1, x_pos, y_pos, background, '');
  setlength(additional_textbutton, length(additional_textbutton) + 1);
  additional_textbutton[length(additional_textbutton) - 1] := inf_button;
end;

procedure InheritedTableCls.showPositionHint;
begin
  additional_textbutton[length(additional_textbutton) - 1].setText('страница: ' + inttostr(pageNumber) + ' строка: ' + inttostr(on_vertical_button) + ' ячейка: ' + inttostr(on_horizontal_button));
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
  setlength(columnHeader, countColumn);   // устанавливаем размер массива под количество столбцов
  columnHeader := setHeadOfColumns;       // передаем названия столбцов
  for i := 0 to countColumn-1 do
  begin
    head_buttons[i] := Cell.Init(head_width, head_height, x_pos, y_pos, background, columnHeader[i]);
    head_buttons[i].Border := border.Init('-', borderFreeSpace, borderFreeSpace, x_pos, y_pos, y_pos, head_width);
    head_buttons[i].Border.ChangeColor(1);
    head_buttons[i].Border.ChangeBackground(background);
    head_buttons[i].Show;
    x_pos := x_pos + head_width + borderFreeSpace;
  end;
  x_border := head_buttons[countColumn-1].GetStartX + head_buttons[countColumn-1].GetWidth + head_buttons[countColumn-1].border.GetXOffsetFromText;
end;

function InheritedTableCls.getFirstLineNumber(page: word): word;    // Номер первой строки на странице в списке
begin
    result := (lineCount * (page-1)) + 1;
end;

procedure InheritedTableCls.addaptiveToSize(Xborder: byte);
begin
  head_width := trunc(Xborder * 1/countColumn);
end;

procedure InheritedTableCls.createNewPage();
var
  i: word;
  j: byte;
  headCoords: Coords;
  y_line_pos: byte;
  Cells: array of Cell;
begin
  pageCount := pageCount + 1;
  headCoords := getHeadCellCoords(1);
  setlength(Cells, countColumn);
  for i := 0 to lineCount-1 do
  begin
    y_line_pos := headCoords[2] + (borderFreeSpace + 1) + (i * borderFreeSpace);
    for j := 0 to countColumn-1 do
    begin
      Cells[j] := Cell.Init(head_width, head_height, head_buttons[j].GetStartX, y_line_pos, background, '');
      Cells[j].Border := Border.Init('-', borderFreeSpace-1, borderFreeSpace-1, head_buttons[j].GetStartX, y_line_pos, y_line_pos, head_width); // инициализируем обрамление
    end;
    lineList.add_line(Cells);
  end;
end;

procedure InheritedTableCls.showLine(lineNumber: word);
var
  i: integer;
  line: PLine;
begin
  line := lineList.getNode(lineNumber);
  for i := 1 to countColumn do
  begin
      line^.data[i].Border.ChangeColor(1);
      line^.data[i].Border.ChangeBackground(background);
      line^.data[i].show;
  end;
end;

procedure InheritedTableCls.showPage();
var
  pageHeadNumber, lineNumber: integer;
begin
  cursoroff;
  lineNumber := 1;
  pageHeadNumber := getFirstLineNumber(pageNumber); // получаем номер первой строки страницы в списке
  while lineNumber <= lineCount do
  begin
    showLine(pageHeadNumber + (lineNumber - 1));
    lineNumber := lineNumber + 1;
  end;
  cursoron;
end;

procedure InheritedTableCls.nextPage;
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
  if key = #116 then // Сtrl + ->
    nextPage()
  else if key = #115 then // Сtrl + <-
    previousPage();
end;

// ввод текста с клавиатуры
function InheritedTableCls.enterText(text: string; symbolsCount: byte): string;
var
  key: char = ' ';
begin
  result := '';
  while key <> #13 do
  begin
    key := readkey;
    if (symbolsCount > length(text)) then
    begin
      if isString(key) or (key in ['-', '/', '\']) then // проверка символа на принадлежность к букве или числу или к ['-', '/', '\']
      begin
        text := text + key;
        write(key);
      end
      else if key = #32 then // SPACE
      begin
        text := text + ' ';
        write(' ');
      end;
    end;
    if (key = #8) and (text <> '') then // DEL
      text := deleteText(text, 1)
  end;
  result := text;
end;

// ввод числа
function InheritedTableCls.enterNumber(digitsCount: byte): string;
var
  key: char;
begin
  result := '';
  key := ' ';
  while key <> #13 do
  begin
    key := readkey;
    if digitsCount > length(result) then
    begin
      if isInteger(key) then // если число
      begin
        result := result + key;
        write(key);
      end
    end;
    if key = #8 then
      result := deleteText(result, 1);
  end;
  while (result <> '') and (result[1] = '0') and (length(result) > 1) do // убираем нули в начале числа
    result := result[2..length(result)]; // result := '01'; result[2] = '1';
end;

// удаление текста
function InheritedTableCls.deleteText(text: string; delCount: byte): string;
const
  stepDel = 1;
var
  x_, y_, count: integer;
begin
  deleteText := '';
  if text <> '' then
  begin
    x_ := whereX;
    y_ := whereY;
    count := 0;
    repeat
      x_ := x_ - stepDel;
      count := count + 1;
      gotoxy(x_, y_);
      write(' ');
      gotoxy(x_, y_);                         // 'abc' 4 => ''
      deleteText := copy(text, 1, length(text) - count); // удаляет count символов из строки
    until ((count = delCount) or (deleteText = '')); // пока не удалится нужное количество символов или пока не закончится строка.
  end;
end;

// создает поля для ввода текста
function InheritedTableCls.createInputField(x_, y_, width: word): TextButton;
const
  height = 1;
begin
  createInputField := TextButton.Init(width, height, x_, y_, 0, ''); // создаем текстовое поле без текста
  createInputField.Border := Border.Init('-', borderFreeSpace-1, borderFreeSpace-1, x_, y_, y_, width); // создаем границу для текстового поля
  createInputField.show; // отрисовываем текстовое поле
  createInputField.Border.ChangeColor(15);  // меняем цвет границы
  gotoxy(1 + borderFreeSpace, 1 + (borderFreeSpace-1)); // переводим курсор к вводу.
end;

// запись в ячейку
procedure InheritedTableCls.writeInCell;
var
  line, lastLineInTable: PLine;
  x_, y_, width: integer;
  InputField: TextButton;
begin
  lastLineInTable := lineList.getNode(lineCount); // получаем узел списка с последней линией в таблице
  x_ := lastLineInTable^.data[1].GetStartX;           // получаем координату по x последней линии
  y_ := lastLineInTable^.data[countColumn].GetTopY + (borderFreeSpace * 2); // получаем координату по y последней ячейки, последней линии со сдвигом
  width := lastLineInTable^.data[countColumn].GetStartX + lastLineInTable^.data[countColumn].GetWidth - borderFreeSpace; // считаем ширину поля ввода из координаты последней ячейки последний строки
  line := lineList.getNode(getFirstLineNumber(pageNumber) + (on_vertical_button-1)); // получаем строку в которую мы вводим текст
  InputField := createInputField(x_, y_, width);                                     // создаем поле для ввода
  InputField.setText(line^.data[on_horizontal_button].getText);                      // устанавливаем текст который сейчас находится в ячейке полю для ввода
  line^.data[on_horizontal_button].setText(enterTextFormat(InputField));             // после ввода текста устанавливаем введенный текст ячейке (получаем из enterTextFormat)
  line^.data[on_horizontal_button].show;                                             // отрисовываем ячейки
  gotoxy(line^.data[on_horizontal_button].GetStartX, line^.data[on_horizontal_button].GetStartX); // переводим курсор к ячейке
end;

// включает подсветку линии
procedure InheritedTableCls.LineLighting(lineNumber, color: word);
var
  i: integer;
  line: PLine;
begin
  line := lineList.getNode(lineNumber);
  for i := 1 to countColumn do
    line^.data[i].border.ChangeBackground(color);
end;

// отключает подсветку
procedure InheritedTableCls.turnOffDeleteLight();
var
  line: Coords;
  lineNumber: word;
begin
  lineNumber := getFirstLineNumber(pageNumber) + (on_vertical_button-1);   // получаем номер строки (получаем номер первой строки на странице )
  line := getCellCoords(lineNumber, 1);
  LineLighting(lineNumber, 0);
  window(x, y, x_border, y_border);
  gotoxy(line[1], line[2]);
end;

// удаление и создание новой линии
procedure InheritedTableCls.deleteLine(lineNumber: word);
begin
  Linelist.delete(lineNumber);
end;

// обрабатывает перемещение вверх в режиме удаления
procedure InheritedTableCls.DelKey_UP;
begin
  LineLighting(getFirstLineNumber(pageNumber) + (on_vertical_button-1), 0);
  Key_UP;
  LineLighting(getFirstLineNumber(pageNumber) + (on_vertical_button-1), 7);
end;

// обрабатывает перемещение ввниз в режиме удаления
procedure InheritedTableCls.DelKey_DOWN;
begin
  LineLighting(getFirstLineNumber(pageNumber) + (on_vertical_button-1), 0);
  Key_DOWN;
  LineLighting(getFirstLineNumber(pageNumber) + (on_vertical_button-1), 7);
end;

// ------------------Обработчики события нажатия клавиши-----------------------
procedure InheritedTableCls.Key_UP();
begin
  if on_vertical_button = 1 then
    on_vertical_button := lineCount   {баг с номером строки}
  else
    on_vertical_button := on_vertical_button - 1;
end;

procedure InheritedTableCls.Key_DOWN();
begin
  if on_vertical_button = lineCount then
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

procedure InheritedTableCls.Key_Left;
begin
  if on_horizontal_button = 1 then
    on_horizontal_button := countColumn
  else
    on_horizontal_button := on_horizontal_button - 1;
end;
//-----------------------------------------------------------------------------

// удаляет шапку таблицы
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

// удаление ячеек из таблицы
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

// удаление дополнительного текста (подсказки)
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
  write(InputField.getText);
end;

procedure InheritedTableCls.SortTable(column: byte);
var
  j, i: integer;
  line: PLine;
  currentText, previousText: string;
begin
  for j := 0 to lineList.nodeCount - 1 do
  begin
    line := lineList.getNode(1);
    for i := 2 to lineList.nodeCount - j do // i=2 потому что проверяем текущую строку с предыдущей. Вычитаем количество отсортированных элементов при каждой иттерации
    begin
      line := line^.next;
      currentText := line^.data[column].getText;  // получает текст из текущей ячейки
      previousText := line^.previous^.data[column].getText;
      if ((currentText <> '') and (previousText <> '')) then
        if ((currentText[1] < previousText[1])             // если номер элемента в сортировке выше предыдущего то он идёт в вверх в таблице (например: a < b, то a будет выше)
                                          and (isString(previousText[1]))
                                          and (isString(currentText[1]))) then
        begin
          lineList.insert(line, line^.previous);
          line := line^.next;
        end;
    end;
  end;
end;

// -----------------------------ТЕХНИЧЕСКИЕ РАБОТЫ!-----------------------------
//procedure InheritedTableCls.PutButtonOnEachOther(number: byte);
//var
//  newButtonXPos, newBorderXPos: byte;
//begin
//  if (number <> 0) and (number < countColumn) then
//  begin
//    newButtonXPos := (head_buttons[number-1].GetStartX + head_buttons[number-1].GetWidth) div 2;
//    //head_buttons[number].GetStartX := ;
//    //head_buttons[number].border.GetStartX := head_buttons[number].GetStartX - 1;
//  end;
//end;
//
//procedure InheritedTableCls.PutButtonsOnEachOther(fromButton, toButton: byte);
//var
//  button: byte;
//begin
//  if (fromButton >= 0) and (fromButton < countColumn) then
//  begin
//    for button := fromButton to toButton do
//      PutButtonOnEachOther(button);
//  end;
//end;
//
//procedure InheritedTableCls.SwitchHeadButton_Right(var on_headButton: byte);
//begin
//  clearHeadButtons;
//  if on_headButton <> countColumn-1 then
//  begin
//    on_headButton := on_headButton + 1;
//    PutButtonOnEachOther(on_headButton);
//    head_buttons[on_headButton].show;
//    head_buttons[on_headButton].border.show;
//    PutButtonsOnEachOther(on_headButton+2, countColumn);
//  end;
//end;
//
//procedure InheritedTableCls.SwitchHeadButton_Left(var on_headButton: byte);
//begin
//  clearHeadButtons;
//  if on_headButton <> 0 then
//  begin
//    PutButtonsOnEachOther(on_headButton + 1, countColumn);
//    on_headButton := on_headButton - 1;
//    head_buttons[on_headButton].show;
//    head_buttons[on_headButton].border.show;
//    //PutButtonOnEachOther(on_headButton+1);
//  end;
//end;
//------------------------------------------------------------------------------

// создает меню выбора
function InheritedTableCls.createSelectionMenu: SwitchMenu;
const
  MAX_TEXT_SIZE = 24;
var
  offSetCoords: Coords;
  x_pos, y_pos: byte;
begin
  offSetCoords := getCellCoords(lineCount, countColumn);
  x_pos := abs(offSetCoords[1] - MAX_TEXT_SIZE);
  y_pos := offSetCoords[2] + + borderFreeSpace;
  result := SwitchMenu.Init(x_pos, y_pos, x_pos + MAX_TEXT_SIZE, y_pos, 0);
end;

procedure InheritedTableCls.enterSavePath(field: TextButton);
var
  flag: boolean;
  fieldText: string;
begin
  flag := true;
  while flag do // выполняем пока не будет введёна корректная буква диска
  begin
    field.setText(readkey);  // вводим символ с клавиатуры и устанавливаем его текстовому полю
    fieldText := field.getText; // получаем текст из текстового поля
    if (fieldText[1] in ['C'..'z']) and not (fieldText[1] in ['a', 'b']) then // Проверяем к названию какого диска относится символ.
    begin
      //if field.text[1] in ['a'..'z'] then
      //  field.text := chr(ord(field.text[1]) - 32);
      write(UpCase(fieldText) + ':\');  // выводим букву диска
      field.setText(fieldText + ':\');  // устанавливаем выведенный текст текстовому полю
      flag := false;
    end
  end;
  field.setText(enterText(field.getText, trunc(field.GetWidth * 0.66))); // вызываем процедуру для ввода текста 2/3 строки
end;

procedure InheritedTableCls.Save(fName: string);
begin
  lineList.save(fName);
end;

procedure InheritedTableCls.Load(fName: string);
begin
  lineList.Load(fName);
end;

procedure InheritedTableCls.Search(text: string; column: byte);
var
  node: integer;
  line: PLine;
begin
  if column <> 0 then
    for node := 1 to lineList.nodeCount do
    begin
      line := lineList.getNode(node); // получаем узел
      if line^.data[column].getText() = text then // поиск текста по столбцу в таблице
      begin
        pageNumber := (node div lineCount) + 1; // номер страницы на которой мы сейчас находимся
        showpage();                             // показываем страницу
      end;
    end;
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

