unit base_graphic;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Crt, Windows;

type
  TextButton = class
    button_width, button_height: integer;
    public
      constructor Init(width, height: integer);
      function Create(x_cord, y_cord, abs_background: integer; abs_text: string): TextButton;
  end;

  Menu = class sealed
      x, y, background: integer;
      buttons: array[1..10] of TextButton;

      countButtons: integer;
    public
      procedure Create;
      procedure Main;
      constructor Init(start_x, start_y, abs_background: integer);
  end;

implementation
  constructor Menu.Init(start_x, start_y, abs_background: integer);
  begin
    x := start_x;
    y := start_y;
    countButtons := 0;
    background := abs_background;
  end;

  procedure Menu.Create();
  const
    base_count = 3;

  var
    obj_button: TextButton;
    i: integer;
    cord_x, cord_y: integer;

  begin
    obj_button := TextButton.Init(40, 20);
    Window(x, y, WindowWidth, WindowHeight);
    cord_x := WindowWidth/2;
    cord_y := WindowHeight/2;

    for i:= 1 to base_count do
      begin
        if WhereY = y then
          background := 2;
        buttons[i] := obj_button.Create(cord_x - button_width, cord_y, background, 'База Данных №' + inttostr(i));
        cord_y := cord_y + 20;
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

  function TextButton.Create(x_cord, y_cord, abs_background: integer; abs_text: string): TextButton;
  const
    width = 256;
    height = 256;
  begin
    Window(x_cord, y_cord, x_cord - button_width, y_cord + button_height);
    TextBackground(abs_background);
    gotoxy(x_cord, y_cord);
    write(abs_text);
    Create := Self;
  end;

  begin
  end.
