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
      borderFreeSpace, start_x, top_y, bottom_y, text_size, dif_y, last_x: integer;
      symbol: char;

    constructor Init(fsymbol: char; freeSpace, std_x, start_y, last_y, t_size: integer);
    procedure Create;
  end;

  TextButton = class
    public
      button_width, button_height, x_pos, y_pos: integer;
      background: integer;
      text: string;
      Border: Border;

      constructor Init(width, height, x_cord, y_cord, abs_background: integer; abs_text: string);
      function Create: TextButton;
      destructor del;
  end;

  Cell = class(TextButton)

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
  end;

  destructor TextButton.Del;
  begin
  end;

  function TextButton.Create(): TextButton;
  begin
    Window(x_pos, y_pos, x_pos + button_width, y_pos + button_height);
    TextBackground(background);
    gotoxy(x_pos, y_pos);
    write(text);

    Create := Self;
  end;

  constructor Border.Init(fsymbol: char; freeSpace, std_x, start_y, last_y, t_size: integer);
  begin
    borderFreeSpace := freeSpace;
    start_x := std_x;
    last_x := start_x + t_size + borderFreeSpace;
    top_y := start_y;
    dif_y := last_y;
    text_size := t_size + (borderFreeSpace * 2);
    symbol := fsymbol;
  end;

  procedure Border.Create;
  var
    horizontal_text: string;
    i: integer;
  begin
    start_x := start_x - borderFreeSpace;
    dif_y := dif_y - top_y;
    top_y := top_y - borderFreeSpace;
    window(start_x, top_y, last_x, dif_y); {Дописать}

    start_x := 1;
    top_y := 1;
    horizontal_text := '';
    for i := 1 to text_size do
      horizontal_text := horizontal_text + symbol;

    gotoxy(start_x, top_y);
    write(horizontal_text);
    for i := top_y + 1 to dif_y - 1 do
      begin
        gotoxy(start_x, i);
        write('|');
        gotoxy(last_x, i);
        write('|');
      end;
    gotoxy(start_x, dif_y);
    write(horizontal_text);
  end;

  begin
  end.
