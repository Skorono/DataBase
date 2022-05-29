unit base_graphic;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Crt;
type
  Base = class
    {procedure add_line;}

  end;

  Border = class
    public
      borderFreeSpace, start_x, top_y, bottom_y, text_size, last_x, border_color: integer;
      symbol: char;

    constructor Init(fsymbol: char; freeSpace, std_x, start_y, last_y, t_size: integer);
    procedure Create;
    procedure ChangeColor(color: integer);
  end;

  TextButton = class
    public
      button_width, button_height, x_pos, y_pos, text_color: integer;
      background: integer;
      text: string;
      Border: Border;

      constructor Init(width, height, x_cord, y_cord, abs_background: integer; abs_text: string);
      procedure Create;
      procedure ChangeColor(color: integer);
      destructor del;
  end;

  Cell = class(TextButton)
    private
      visibleTextSize: integer;
    public
      constructor Init(width, height, x_cord, y_cord, abs_background: integer; abs_text: string);
      procedure Create();
      procedure write_info;

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
  end;

  procedure TextButton.ChangeColor(color: integer);
  begin
    text_color := color;
  end;

  procedure TextButton.Create();
  begin
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

  procedure Cell.Create;
  var
    visible_text: string[6];
  begin
    Window(x_pos, y_pos, x_pos + button_width, y_pos + button_height);
    TextBackground(background);
    TextColor(text_color);

    gotoxy(x_pos, y_pos);
    if button_width < visibleTextSize then
      visible_text := text
    else if text <> '' then
      visible_text := text[visibleTextSize] + '...';
    write(text);
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
  end;

  procedure Border.ChangeColor(color: integer);
  begin
    border_color := color;
  end;

  procedure Border.Create;
  var
    horizontal_text: string;
    i: integer;
  begin
    start_x := start_x - borderFreeSpace;
    top_y := top_y - borderFreeSpace;
    Window(start_x, top_y, last_x, bottom_y);

    last_x := last_x - start_x;
    start_x := 1;
    bottom_y := bottom_y - top_y;
    top_y := 2;

    TextColor(border_color);
    horizontal_text := '';
    for i := 1 to text_size do
      horizontal_text := horizontal_text + symbol;
    gotoxy(start_x+1, top_y-1);
    write(horizontal_text);
    for i := top_y to bottom_y do
    begin
      gotoxy(start_x, i);
      write('|');
      gotoxy(last_x, i);
      write('|');
    end;
    gotoxy(start_x + 1, bottom_y + 1);
    write(horizontal_text);
  end;

  begin
  end.
