unit base_graphic;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Crt, GeneralTypes;
type

  { GraphicPrimitive }
  {Класс-родитель всех графических объектов.
  Он имеет в себе все общие методы и свойства граф.объектов}
  GraphicPrimitive = class
  private
    start_x, last_x, top_y, bottom_y: byte;
    width, height: byte;
    color, background: byte;
  public
      procedure ChangePos(new_start_x, new_top_y, new_last_x, new_bottom_y: byte); virtual;
      procedure ChangeSize(new_width, new_height: byte); virtual; abstract;
      procedure ChangeBackground(new_color: byte); virtual;
      procedure ChangeColor(new_color: byte); virtual;
      function GetStartX(): byte;
      function GetLastX(): byte;
      function GetTopY(): byte;
      function GetBottomY(): byte;
      function GetWidth(): byte;
      function GetHeight(): byte;
      function GetTextColor: byte;
      function GetBackgroundColor: byte;
      procedure clear; virtual; abstract;
      procedure Show; virtual; abstract;
  end;

  { Border } // добавление обрамления для текста
  Border = class(GraphicPrimitive)
  strict protected
    XborderFreeSpace, // расстояние от обрамления до текста по x
    YborderFreeSpace: byte; // расстояние от обрамления до текста по y
  public
    text_size: byte;
    symbol: char;

    // конструктор нужен для инициализации и передачи параметров в объект
    constructor Init(fsymbol: char; XfreeSpace, YfreeSpace, std_x, start_y, last_y, t_size: integer);  // инициализация обрамления
    // метод удаляющий объект из памяти
    destructor Destroy; override; // меняет логику выполнения destroy: стирает объект с экрана
    procedure Show; override;
    procedure ChangeSize(new_width_offset, new_height_offset: byte); override;
    procedure ChangePos(new_start_x, new_top_y, new_bottom_y: byte); reintroduce;
    function GetXOffsetFromText: byte;
    function GetYOffsetFromText: byte;
    procedure Clear; override;
  end;

  { TextButton }

  TextButton = class(GraphicPrimitive) { Сделать так чтобы параметры для рамки передавались из параметров текста}
    protected // почитать ВЕРНИСЬ СЮДА
      text: string;
    public
      Border: Border;

      constructor Init(button_width, button_height, x_cord, y_cord, abs_background: byte; abs_text: string);
      procedure Show; override;
      procedure Clear; override;
      procedure ChangeSize(new_width, new_height: byte); override;
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
      constructor Init(button_width, button_height, x_cord, y_cord, abs_background: byte; abs_text: string);
      procedure Show; override;
      procedure setText(newText: string); override;
      function getText: string; override;
      //procedure clearCell;
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

  { GraphicPrimitive }

  procedure GraphicPrimitive.ChangeColor(new_color: byte);
  const
    colorN = 15;
    additionColorN = 128;
  begin
    if (new_color >= 0) and ((new_color <= colorN)
                        or (new_color = additionColorN)) then
      color := new_color;
    show;
  end;

  function GraphicPrimitive.GetStartX: byte;
  begin
    result := start_x;
  end;

  function GraphicPrimitive.GetLastX: byte;
  begin
    result := last_x;
  end;

  function GraphicPrimitive.GetTopY: byte;
  begin
    result := top_y;
  end;

  function GraphicPrimitive.GetBottomY: byte;
  begin
    result := bottom_y;
  end;

  function GraphicPrimitive.GetWidth: byte;
  begin
    result := width;
  end;

  function GraphicPrimitive.GetHeight: byte;
  begin
    result := height;
  end;

  function GraphicPrimitive.GetTextColor: byte;
  begin
    result := color;
  end;

  function GraphicPrimitive.GetBackgroundColor: byte;
  begin
    result := background;
  end;

  procedure GraphicPrimitive.ChangePos(new_start_x, new_top_y, new_last_x, new_bottom_y: byte);
  begin
    if ((new_start_x > 0) and (new_top_y > 0))
        and ((new_last_x > 0) and (new_bottom_y > 0)) then
    begin
        start_x := new_start_x;
        top_y := new_top_y;
        last_x := new_last_x;
        bottom_y := bottom_y;
    end;
    show;
  end;

  procedure GraphicPrimitive.ChangeBackground(new_color: byte);
  begin
    if (new_color >= 0) then
      background := new_color;
    show;
  end;

  constructor TextButton.Init(button_width, button_height, x_cord, y_cord, abs_background: byte; abs_text: string);
  var
    i: integer;
  begin
    width := button_width;
    height := button_height;
    start_x := x_cord;
    top_y := y_cord;
    last_x := start_x + (width-1); // учитывая что 1 это стандартная высота кнопки
    bottom_y := top_y + (height-1);
    background := abs_background;
    text := abs_text;
    color := 15;
    for i := length(text) to width-1 do
      text := text + ' ';
  end;

  destructor TextButton.Destroy;
  begin
    Clear;
  end;

  procedure TextButton.ChangeSize(new_width, new_height: byte);
  begin
    if (new_width > 0) and (new_height > 0) then
    begin
        width := new_width;
        height := new_height;
    end;
    show;
  end;

  // стирает кнопку с экрана
  procedure TextButton.Clear;
  begin
    Window(start_x, top_y, last_x, top_y);
    TextBackground(background);
    ClrScr;
  end;

  procedure TextButton.Show();
  begin
    Clear;
    Window(start_x, top_y, last_x, top_y);
    TextColor(color);
    gotoxy(start_x, top_y);
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

  constructor Cell.Init(button_width, button_height, x_cord, y_cord, abs_background: byte; abs_text: string);
  var
    i: integer;
  begin
    STD_VISION := '';
    // TextButton - родитель
    inherited Init(button_width, button_height, x_cord, y_cord, abs_background, abs_text);
    for i := 1 to width do
      STD_VISION := STD_VISION + ' '; // форматирует ячейку по ширине с + в конце
    STD_VISION := STD_VISION[1..length(STD_VISION)-2] + '+';

    if (abs_text = '') then
      text := STD_VISION
    else
      text := abs_text
  end;

  procedure Cell.Show;
  var
    visible_text: string;
  begin
    Clear;
    Window(start_x, top_y, last_x, bottom_y); // создает окно (область) в котором меняется цвет background и text
    TextBackground(background);
    TextColor(color);

    gotoxy(1, 1);
    if length(text) > width then
      visible_text := copy(text, 1, width-3) + '...' // если длинна текста больше ширины ячейки то текст в ячейке обрезается
    else if length(text) <= width then
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
    text_size := t_size; // граница не касается текста
    ChangePos(std_x, start_y, last_y);
    symbol := fsymbol;
    color := 3;
    background := 0;
  end;

  // изменяет расстояние границы от текста
  procedure Border.ChangeSize(new_width_offset, new_height_offset: byte);
  begin
    if (new_width_offset > 0) and (new_height_offset > 0) then
    begin
      XborderFreeSpace := new_width_offset;
      YborderFreeSpace := new_height_offset;
    end;
    show;
  end;

procedure Border.ChangePos(new_start_x, new_top_y, new_bottom_y: byte);
begin
  start_x := new_start_x - XfreeSpace;
  last_x := start_x + text_size + (XfreeSpace * 2);
  top_y := new_top_y - YborderFreeSpace;
  bottom_y := new_bottom_y + YborderFreeSpace;
end;

  function Border.GetXOffsetFromText: byte;
  begin
    result := XborderFreeSpace
  end;

  function Border.GetYOffsetFromText: byte;
  begin
    result := YborderFreeSpace;
  end;

  procedure Border.Show;
  var
    horizontal_text: string;
    _start_x, _top_y, _last_x, _bottom_y, char, pos: byte;
  begin
    Window(start_x, top_y, last_x, bottom_y); // При создании окна координатой (1, 1) становиться  (_start_x, _top_y)

    _start_x := 1;
    _top_y := 1;
    _last_x := last_x - start_x;
    _bottom_y := bottom_y - top_y;

    TextColor(color);
    TextBackground(background);
    horizontal_text := '';
    for char := 1 to _last_x - 2 do
      horizontal_text := horizontal_text + symbol;
    gotoxy(_start_x, _top_y);
    write(' ' + horizontal_text + ' ');
    for pos := _top_y + 1 to _bottom_y do
    begin
      gotoxy(_start_x, pos);
      write('|');
      gotoxy(_last_x, pos);
      write('|');
    end;
    gotoxy(_start_x, _bottom_y+1);
    write(' ' + horizontal_text + ' ');
  end;

  // BUG
  procedure Border.Clear;
  begin
    window(start_x, top_y, last_x, bottom_y);
    TextBackground(0);
    ClrScr;
  end;

  destructor Border.Destroy;
  begin
    Clear;
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
