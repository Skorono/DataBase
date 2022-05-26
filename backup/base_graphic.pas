unit base_graphic;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Crt;

type
  Border = class
    public
      borderFreeSpace, x, high_y, end_y, text_size: integer;
      symbol: char;

    {Размер текста внутри, координаты начала откуда идёт текст, координаты конца по y, символ который будет в горизонтальной строке}
    constructor Init(fsymbol: char; freeSpace, std_x, start_y, last_y, t_size: integer);
    procedure Create;
  end;

  TextButton = class
    public
      button_width, button_height, x_pos, y_pos: integer;
      background: integer;

      constructor Init(width, height: integer);
      function Create(x_cord, y_cord, abs_background: integer; abs_text: string): TextButton;
      //function DeepCopy(obj: TextButton): TextButton;
  end;

  Menu = class sealed
      x, y, x_border, y_border, background: integer;
      buttons: array[1..10] of TextButton;

      countButtons: integer;
    public
      procedure Create;
      procedure Main;
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
    obj_button := TextButton.Init(text_size, spaceBetweenButtons);
    Window(x, y, x_border, y_border);
    cord_x := x_border div 2;
    cord_y := y_border div 2;

    for i:= 1 to base_count do
      begin
        text := 'База Данных №' + inttostr(i);
        buttons[i] := obj_button.Create(cord_x - (text_size div 2), cord_y, background, text);
        cord_y := cord_y + spaceBetweenButtons;
      end;
  end;

  procedure Menu.Main;
  {var
    run: boolean;}
  begin
    {run := true;
    while run do
    begin
      case readkey of
      #80:
        begin

        end;
      #72:
        begin

        end;
      #13:
        begin

        end;
      end;
    end;}
  end;

  constructor TextButton.Init(width, height: integer);
  begin
    button_width := width;
    button_height := height;
  end;

  //function TextButton.DeepCopy(obj: TextButton): TextButton;
  //begin
  //  obj := obj.Init(button_width, button_height);
  //  obj.x_pos := x_pos;
  //  obj.y_pos := y_pos;
  //  obj.background := background;
  //  DeepCopy := obj;
  //end;
  //
  function TextButton.Create(x_cord, y_cord, abs_background: integer; abs_text: string): TextButton;
  var
    DeepCopyObj: TextButton;
  begin
    Window(x_cord, y_cord, x_cord + button_width, y_cord + button_height);
    x_pos := x_cord;
    y_pos := y_cord;
    background := abs_background;
    TextBackground(background);
    gotoxy(x_cord, y_cord);
    write(abs_text);

    {Желательно что-то с этим сделать}
    //Create := DeepCopy(DeepCopyObj);
    Create := Self;
  end;

  constructor Border.Init(fsymbol: char; std_x, start_y, last_y, t_size: integer);
  begin
    borderFreeSpace := FreeSpace;
    framedPos_x := framed_x;
    framedPos_y := framed_y;
    symbol := fsymbol;
  end;

  procedure Border.Create;
  var
    horizontal_text: string;
  begin
    horizontal_text := symbol * (framed_x + (borderFreeSpace * 2));
    gotoxy(framedPos_x - borderFreeSpace, framedPos_y - borderFreeSpace);
    write(horizontal_text);

    gotoxy()
  end;

  begin
  end.
