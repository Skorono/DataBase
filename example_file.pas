unit example_file;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Storage, base_graphic;

type
  ViewTable = class
    background: integer;
    List: ;

    constructor Init(abs_background: integer);
    procedure show_table1;
    procedure show_head;
  end;

implementation
procedure show_head;
const
  countClumn = 7;
  head_width = 10;
  head_height = 3;

var
  i: integer;
  head_buttons: array of [1..countColumn] of TextButtons;
begin
  for i := 1 to countColumn do
  begin
    head_buttons[i] := TextButtons.Init(head_width, head_height, 1, 1, background, 'Head');
    head_buttons[i].Create;
  end;
end

begin

end.

