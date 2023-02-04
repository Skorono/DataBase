unit base_graphic;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Crt, GeneralTypes;
type

  { Border } // добавление обрамления для текста
  Border = class
  public
    XborderFreeSpace, // расстояние от обрамления до текста по x
    YborderFreeSpace, // расстояние от обрамления до текста по y
    start_x, top_y, bottom_y, text_size, last_x, border_color, background: integer;
    symbol: char;

    // конструктор нужен для инициализации и передачи параметров в объект
    constructor Init(fsymbol: char; XfreeSpace, YfreeSpace, std_x, start_y, last_y, t_size: integer);  // инициализация обрамления
    // метод удаляющий объект из памяти
    destructor Destroy; override; // меняет логику выполнения destroy: стирает объект с экрана
    procedure Show;
    procedure ChangeColor(color: integer);
    procedure ChangeBackground(color: integer);
    procedure clearBorder;
  end;

  TextButton = class { Сделать так чтобы параметры для рамки передавались из параметров текста}
    protected // почитать ВЕРНИСЬ СЮДА
      text: string;
    public
      button_width, button_height, x_pos, y_pos, text_color: integer;
      background: integer;
      Border: Border;

      constructor Init(width, height, x_cord, y_cord, abs_background: integer; abs_text: string);
      procedure Show;
      procedure clearButton;
      procedure ChangeColor(color: integer);
      procedure ChangeBackground(color: integer);
      procedure setText(newText: string); virtual;
      function getText: string; virtual;
      destructor Destroy; override;
  end;

  { Cell }
  // Наследник TextButton
  Cell = class(TextButton)
    strict private
      STD_VISION: string;  // стандартный вид ячейки
    public
      constructor Init(width, height, x_cord, y_cord, abs_background: integer; abs_text: string);
      procedure Show;
      procedure setText(newText: string);
      function getText: string; override;
      procedure clearCell;
  end;

  { WindowManager }

  WindowManager = class
    activeWindows: byte;
    windows: array[1..10] of ObjOnScreenInf;
    constructor Init;
    procedure createNewWindow(start_x, start_y, last_x, last_y, background: byte);
    procedure changeWindowColor(number, color: byte);
    procedure showWindow(number: byte);
    destructor Destroy; override;
  private
    procedure changeWindowSize(start_x, start_y, last_x, last_y, number: byte);
  end;

implementation
  constructor TextButton.Init(width, height, x_cord, y_cord, abs_background: integer; abs_text: string);
  var
    i: integer;
  begin
    button_width := width;
    button_height := height;
    x_pos := x_cord;
    y_pos := y_cord;
    background := abs_background;
    text := abs_text;
    text_color := 15;
    for i := length(text) to width-1 do
      text := text + ' ';
  end;

  destructor TextButton.Destroy;
  begin
    clearButton;
  end;

  procedure TextButton.ChangeColor(color: integer);
  begin
    text_color := color;
    show;
  end;

  procedure TextButton.ChangeBackground(color: integer);
  begin
    background := color;
    show;
  end;

  // стирает кнопку с экрана
  procedure TextButton.clearButton;
  begin
    Window(x_pos, y_pos, x_pos + (button_width-1), y_pos);
    TextBackground(background);
    ClrScr;
  end;

  procedure TextButton.Show();
  begin
    clearButton;
    Window(x_pos, y_pos, x_pos + (button_width-1), y_pos);
    TextColor(text_color);
    gotoxy(x_pos, y_pos);
    write(text);
  end;

  // установка значения text
  procedure TextButton.setText(newText: string);
  begin
    text := newText;
  end;

  function TextButton.getText(): string;
  begin
      result := text;
  end;

  constructor Cell.Init(width, height, x_cord, y_cord, abs_background: integer; abs_text: string);
  var
    i: integer;
  begin
    STD_VISION := '';
    // TextButton - родитель
    inherited Init(width, height, x_cord, y_cord, abs_background, abs_text);
    for i := 1 to width do
      STD_VISION := STD_VISION + ' '; // форматирует ячейку по ширине с + в конце
    STD_VISION := STD_VISION[1..length(STD_VISION)-2] + '+';

    if (abs_text = '') then
      text := STD_VISION
    else
      text := abs_text
  end;

  procedure Cell.clearCell;
  begin
    inherited clearButton;
  end;

  procedure Cell.Show;
  var
    visible_text: string;
  begin
    clearCell;
    Window(x_pos, y_pos, x_pos + (button_width-1), y_pos); // создает окно (область) в котором меняется цвет background и text
    TextBackground(background);
    TextColor(text_color);

    gotoxy(1, 1);
    if length(text) > button_width then
      visible_text := copy(text, 1, button_width-3) + '...' // если длинна текста больше ширины ячейки то текст в ячейке обрезается
    else if length(text) <= button_width then
      visible_text := text;
    write(visible_text);
  end;

  procedure Cell.setText(newText: string);
  begin
    text := newText;
    if (newText = '') then
        text := STD_VISION;
  end;

  function Cell.getText(): string;
  begin
    if text = STD_VISION then
      result := ''
    else
      result := text;
  end;

  constructor Border.Init(fsymbol: char; XfreeSpace, YfreeSpace, std_x, start_y, last_y, t_size: integer);
  begin
    XborderFreeSpace := XfreeSpace;
    YborderFreeSpace := YfreeSpace;
    start_x := std_x;
    last_x := start_x + t_size + XborderFreeSpace;
    top_y := start_y;
    bottom_y := last_y + YborderFreeSpace;
    text_size := (t_size + (XborderFreespace * 2)) - 2;
    symbol := fsymbol;
    border_color := 3;
    background := 0;
  end;

  procedure Border.ChangeColor(color: integer);
  begin
    border_color := color;
    show;
  end;

  procedure Border.Changebackground(color: integer);
  begin
    background := color;
    show;
  end;

  procedure Border.Show;
  var
    horizontal_text: string;
    _start_x, _top_y, _last_x, _bottom_y, char, pos: byte;
  begin
    _start_x := start_x - XborderFreeSpace;
    _top_y := top_y - YborderFreeSpace;
    Window(_start_x, _top_y, last_x, bottom_y);

    _last_x := last_x - _start_x;
    _start_x := 1;
    _bottom_y := bottom_y - _top_y;
    _top_y := 2;

    TextColor(border_color);
    TextBackground(background);
    horizontal_text := '';
    for char := 1 to text_size do
      horizontal_text := horizontal_text + symbol;
    gotoxy(_start_x, _top_y-1);
    write(' ' + horizontal_text + ' ');
    for pos := _top_y to _bottom_y do
    begin
      gotoxy(_start_x, pos);
      write('|');
      gotoxy(_last_x, pos);
      write('|');
    end;
    gotoxy(_start_x, _bottom_y+1);
    write(' ' + horizontal_text + ' ');
  end;

  procedure Border.clearBorder;
  begin
    start_x := start_x - XborderFreeSpace;
    top_y := top_y - YborderFreeSpace;
    window(start_x-1, top_y, last_x, bottom_y);
    TextBackground(0);
    ClrScr;
  end;

  destructor Border.Destroy;
  begin
    clearBorder;
  end;

  constructor WindowManager.Init;
  begin
    activeWindows := 0;
  end;

  procedure WindowManager.createNewWindow(start_x, start_y, last_x, last_y, background: byte);
  begin
    activeWindows := activeWindows + 1;
    windows[activeWindows].x := start_x;
    windows[activeWindows].y := start_y;
    windows[activeWindows].last_x := last_x;
    windows[activeWindows].last_y := last_y;
    windows[activeWindows].background := background;
  end;

  procedure WindowManager.showWindow(number: byte);
  begin
    window(windows[number].x, windows[number].y, windows[number].last_x, windows[number].last_y);
    TextBackground(windows[number].background);
    ClrScr;
  end;

  procedure WindowManager.changeWindowColor(number, color: byte);
  begin
    windows[number].background := color;
  end;

  procedure WindowManager.changeWindowSize(start_x, start_y, last_x, last_y, number: byte);
  begin
    windows[number].x := start_x;
    windows[number].y := start_y;
    windows[number].last_x := last_x;
    windows[number].last_y := last_y;
  end;

  destructor WindowManager.Destroy;
  var
    i: integer;
  begin
  for i := 1 to activeWindows do
  begin
    changeWindowColor(i, 0);
    showWindow(i);
  end;
  end;

  end.
