unit base_graphic;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Crt;
type
  Border = class
    public
      borderFreeSpace, start_x, top_y, bottom_y, text_size, last_x, border_color, background: integer;
      symbol: char;

    constructor Init(fsymbol: char; freeSpace, std_x, start_y, last_y, t_size: integer);
    destructor del;
    procedure Show;
    procedure ChangeColor(color: integer);
    procedure ChangeBackground(color: integer);
  end;

  TextButton = class { Сделать так чтобы параметры для рамки передавались из параметров текста}
    public
      button_width, button_height, x_pos, y_pos, text_color: integer;
      background: integer;
      text: string;
      Border: Border;

      constructor Init(width, height, x_cord, y_cord, abs_background: integer; abs_text: string);
      procedure Show;
      procedure clearButton;
      procedure ChangeColor(color: integer);
      procedure ChangeBackground(color: integer);
      destructor del;
  end;

  Cell = class(TextButton)
    private
      visibleTextSize: integer;
    public
      constructor Init(width, height, x_cord, y_cord, abs_background: integer; abs_text: string);
      procedure Show;
      procedure write_info;
      procedure clearCell;
  end;

implementation
  constructor TextButton.Init(width, height, x_cord, y_cord, abs_background: integer; abs_text: string);
  begin
    button_width := width;
    button_height := height;
    x_pos := x_cord;
    y_pos := y_cord;
    background := abs_background;
    text := abs_text;
    text_color := 15;
  end;

  destructor TextButton.Del;
  begin
    window(x_pos, y_pos, x_pos + button_width, y_pos + button_height);
    TextBackground(0);
    ClrScr;
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

  procedure TextButton.clearButton;
  var
    i: integer;
  begin
    Window(x_pos, y_pos, x_pos + button_width, y_pos + button_height);
    gotoxy(1, 1);
    for i := 1 to button_width do
      write(' ')
  end;

  procedure TextButton.Show();
  begin
    clearButton;
    Window(x_pos, y_pos, x_pos + button_width, y_pos + button_height);
    TextBackground(background);
    TextColor(text_color);

    gotoxy(x_pos, y_pos);
    write(text);
  end;

  constructor Cell.Init(width, height, x_cord, y_cord, abs_background: integer; abs_text: string);
  begin
    inherited Init(width, height, x_cord, y_cord, abs_background, abs_text);
    visibleTextSize := 6;
  end;

  procedure Cell.clearCell;
  begin
    inherited TextButton.clearButton;
  end;

  procedure Cell.Show;
  var
    visible_text: string;
  begin
    clearCell;
    Window(x_pos, y_pos, x_pos + button_width, y_pos + button_height);
    TextBackground(background);
    TextColor(text_color);

    gotoxy(1, 1);
    if length(text) > button_width then
      visible_text := text[length(text) - button_width]
    else if length(text) = button_width then
      visible_text := text
    else if text <> '' then
      visible_text := text;
    write(visible_text);
  end;

  procedure Cell.write_info;
  begin

  end;

  constructor Border.Init(fsymbol: char; freeSpace, std_x, start_y, last_y, t_size: integer);
  begin
    borderFreeSpace := freeSpace;
    start_x := std_x;
    last_x := start_x + t_size + borderFreeSpace;
    top_y := start_y;
    bottom_y := last_y + borderFreeSpace;
    text_size := (t_size + (borderFreespace * 2)) - 2;
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
    _start_x, _top_y, _last_x, _bottom_y, i: integer;
  begin
    _start_x := start_x - borderFreeSpace;
    _top_y := top_y - borderFreeSpace;
    Window(_start_x, _top_y, last_x, bottom_y);

    _last_x := last_x - _start_x;
    _start_x := 1;
    _bottom_y := bottom_y - _top_y;
    _top_y := 2;

    TextColor(border_color);
    TextBackground(background);
    horizontal_text := '';
    for i := 1 to text_size do
      horizontal_text := horizontal_text + symbol;
    gotoxy(_start_x, _top_y-1);
    write(' ' + horizontal_text + ' ');
    for i := _top_y to _bottom_y do
    begin
      gotoxy(_start_x, i);
      write('|');
      gotoxy(_last_x, i);
      write('|');
    end;
    gotoxy(_start_x, _bottom_y + 1);
    write(' ' + horizontal_text + ' ');
  end;

  destructor Border.del;
  begin
    start_x := start_x - borderFreeSpace;
    top_y := top_y - borderFreeSpace;
    window(start_x, top_y, last_x, bottom_y);
    TextBackground(0);
    ClrScr;
  end;

  begin
  end.
