unit example_file;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Storage, Crt, base_graphic;

type
  ViewTable = class
    background, countColumn, head_width, head_height: integer;
    x, y, x_border, y_border: integer;
    head_buttons: array [1..7] of TextButton;
    List: PNode;

    constructor Init(start_x, start_y, border_x, border_y, width, height, abs_background: integer);
    procedure show_table1;
    procedure show_head;
  end;

implementation

constructor ViewTable.Init(start_x, start_y, border_x, border_y, width, height, abs_background: integer);
begin
  countColumn := 7;
  head_width := width;
  head_height := height;
  x := start_x;
  y := start_y;
  x_border := border_x;
  y_border := border_y;
  background := abs_background;
end;

procedure ViewTable.show_head;
var
  i: integer;
  x_width: integer;
begin
  window(x, y, x_border, y_border);
  x_width := head_width;


  for i := 1 to countColumn do
  begin
    head_buttons[i] := TextButton.Init(x_width, head_height, 1, 1, background, 'Head');
    head_buttons[i].Create;
    x_width := x_width + head_width;
  end;
end;

procedure show_table1;
begin
end;

begin

end.

