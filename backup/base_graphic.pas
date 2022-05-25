unit base_graphic;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Crt;

type
  Menu = class
    private
      x, y, width, height, background: integer;
    public
      procedure Create;
      constructor Init(start_x, start_y, abs_background: integer);
  end;

  TextButton = class
    public
      procedure Create(x, y, x1, y1, abs_background: integer; abs_text: string);
  end;

implementation
  constructor Menu.Init(start_x, start_y, abs_background: integer);
  begin
    x := start_x;
    y := start_y;
    background := abs_background;
    width := 800;
    height := 600;
  end;

  procedure Menu.Create();
  const
    base_count = 3;
  var
    obj_button: TextButton;
    button_width, button_height, i: integer;
  begin

    button_width := 30 + x;
    button_height := 15 + y;
    Window(x, y, button_width, button_height);

    for i:= 1 to base_count do
      begin
        obj_button.Create(x, y, button_width, button_height, background, 'База {i}!');
        y := y + 10;
      end;
  end;

  procedure TextButton.Create(x, y, x1, y1, abs_background: integer; abs_text: string);
  begin
    Window(x, y, x1, y1);
    TextBackground(abs_background);
    gotoxy(x, y);
    writeln(abs_text);
  end;

  begin
  end.
