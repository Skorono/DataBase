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

  Menu = class sealed
      x, y, x_border, y_border, background: integer;
      buttons: array[1..10] of TextButton;
      menu_border: Border;

      countButtons: integer;
    private
      function Key_UP(on_button: integer): integer;
      function Key_DOWN(on_button: integer): integer;
      procedure press_enter;

    public
      procedure Show_menu;
      procedure Main;
      constructor Init(abs_background: integer);
      destructor del;
  end;


implementation
  constructor Menu.Init(abs_background: integer);
  begin
    x := 1;
    y := 1;
    x_border := 80;
    y_border := 25;
    countButtons := 3;
    background := abs_background;
  end;

  procedure Menu.Show_menu();
  const
    base_count = 3;
    text_size = 14;
    spaceBetweenButtons = 2;

  var
    text: string[text_size];
    cord_x, cord_y, i: integer;

  begin
    Window(x, y, x_border, y_border);
    cord_x := (x_border div 2) - (text_size div 2);
    cord_y := y_border div 2;

    for i:= 1 to base_count do
      begin
        text := 'База Данных №' + inttostr(i);
        buttons[i] := TextButton.Init(text_size, spaceBetweenButtons, cord_x, cord_y, background, text);
        buttons[i].Create();
        cord_y := cord_y + spaceBetweenButtons;
      end;
    //menu_border := border.Init('~', 2, buttons[1].x_pos, buttons[1].y_pos, buttons[countButtons].y_pos, text_size);
    //menu_border.create;
  end;

  function Menu.Key_UP(on_button: integer): integer;
  begin
    buttons[on_button].background := 0;
    buttons[on_button].Create();
    if on_button = 1 then
      on_button := countButtons
    else
      on_button := on_button - 1;
    Key_UP := on_button;
  end;

  function Menu.Key_DOWN(on_button: integer): integer;
  begin
    buttons[on_button].background := 0;
    buttons[on_button].Create();
    if on_button = countButtons then
      on_button := 1
    else
      on_button := on_button + 1;
    Key_DOWN := on_button;
  end;

  procedure Menu.press_enter;
  begin
    Window(1, 1, x_border, y_border);
    TextBackground(0);
    ClrScr;
  end;

  procedure Menu.Main;
  var
    run: boolean;
    on_button: integer;
  begin
    Show_menu();

    run := true;
    on_button := 1;
    window(x, y, x_border, y_border);
    gotoxy(buttons[on_button].x_pos, buttons[on_button].y_pos);
    while run do
    begin
      case readkey of
      #72:
        begin
          on_button := Key_UP(on_button);
        end;
      #80:
        begin
          on_button := Key_DOWN(on_button);
        end;
      #13:
        begin
          press_enter;
          del;

          run := false;
        end;
      end;
      if run then
      begin
        buttons[on_button].background := 2;
        gotoxy(buttons[on_button].x_pos, buttons[on_button].y_pos);
        ClrEol;
        buttons[on_button].Create();
      end;
    end;
  end;

  destructor Menu.Del;
  var
    i: integer;
  begin
    for i := 1 to countButtons do
      buttons[i].del;
  end;

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
