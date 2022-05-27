unit base_graphic;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Crt;

type
  Border = class
    public
      borderFreeSpace, start_x, top_y, bottom_y, text_size, dif_y, last_x: integer;
      symbol: char;

    {Размер текста внутри, координаты начала откуда идёт текст, координаты конца по y, символ который будет в горизонтальной строке}
    constructor Init(fsymbol: char; freeSpace, std_x, start_y, last_y, t_size: integer);
    procedure Create;
  end;

  TextButton = class
    public
      button_width, button_height, x_pos, y_pos: integer;
      background: integer;
      text: string;
      text_border: Border;

      constructor Init(width, height: integer);
      function Create(x_cord, y_cord, abs_background: integer; abs_text: string): TextButton;
      destructor del;
  end;

  Menu = class sealed
      x, y, x_border, y_border, background: integer;
      buttons: array[1..10] of TextButton;
      menu_border: Border;

      countButtons: integer;
    public
      procedure Create;
      procedure Main;
      procedure Destroy_screen;
      constructor Init(abs_background: integer);
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

  procedure Menu.Create();
  const
    base_count = 3;
    text_size = 14;
    spaceBetweenButtons = 2;

  var
    obj_button: TextButton;
    text: string[text_size];
    cord_x, cord_y, i: integer;

  begin
   // obj_button := TextButton.Init(text_size, spaceBetweenButtons);
    Window(x, y, x_border, y_border);
    cord_x := x_border div 2;
    cord_y := y_border div 2;

    for i:= 1 to base_count do
      begin
        text := 'База Данных №' + inttostr(i);
        buttons[i] := TextButton.Init(text_size, spaceBetweenButtons);
        buttons[i].Create(cord_x - (text_size div 2), cord_y, background, text);
        cord_y := cord_y + spaceBetweenButtons;
      end;
    menu_border := border.Init('~', 2, buttons[1].x_pos, buttons[1].y_pos, buttons[countButtons].y_pos, text_size);
    menu_border.create;
  end;

  procedure Menu.Main;
  var
    run: boolean;
    on_button: integer;
  begin
    create();

    run := true;
    on_button := 1;
    window(x, y, x_border, y_border);
    gotoxy(buttons[on_button].x_pos, buttons[on_button].y_pos);
    while run do
    begin
      case readkey of
      #72:
        begin
          buttons[on_button].background := 0;
          buttons[on_button].Create(buttons[on_button].x_pos, buttons[on_button].y_pos, buttons[on_button].background, buttons[on_button].text);
          if on_button = 1 then
              on_button := countButtons
          else
              on_button := on_button - 1;
        end;
      #80:
        begin
          buttons[on_button].background := 0;
          buttons[on_button].Create(buttons[on_button].x_pos, buttons[on_button].y_pos, buttons[on_button].background, buttons[on_button].text);
          if on_button = countButtons then
            on_button := 1
          else
            on_button := on_button + 1;
        end;
      #13:
        begin
          Destroy_screen;
          ClrScr;
          TextBackground(0);
        end;
      end;
      buttons[on_button].background := 2;
      gotoxy(buttons[on_button].x_pos, buttons[on_button].y_pos);
      ClrEol;
      buttons[on_button].Create(buttons[on_button].x_pos, buttons[on_button].y_pos, buttons[on_button].background, buttons[on_button].text);
    end;
  end;

  procedure Menu.Destroy_screen;
  var
    i: integer;
  begin
    for i := 1 to countButtons do
      {if buttons[i] then}
      buttons[i].del;
  end;

  constructor TextButton.Init(width, height: integer);
  begin
    button_width := width;
    button_height := height;
  end;

  destructor TextButton.Del;
  begin
  end;

  function TextButton.Create(x_cord, y_cord, abs_background: integer; abs_text: string): TextButton;
  begin
    Window(x_cord, y_cord, x_cord + button_width, y_cord + button_height);
    x_pos := x_cord;
    y_pos := y_cord;
    text := abs_text;
    background := abs_background;
    TextBackground(background);
    gotoxy(x_cord, y_cord);
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
