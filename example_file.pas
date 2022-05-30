unit example_file;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Storage, Crt, base_graphic;

type
  SArray = array[1..7] of string;

  ViewTable = class
    background, countColumn, head_width, head_height: integer;
    x, y, x_border, y_border: integer;
    Cells: array[1..7] of Cell;
    head_buttons: array[1..7] of TextButton;
    List: Cls_List;
    borderFreeSpace: integer;

    constructor Init(start_x, start_y, border_x, border_y, width, height, abs_background: integer);
    procedure show_table1;
    procedure show_head;
    procedure show_line;
    procedure writeInCell;
    procedure Key_UP;
    procedure Key_DOWN;
    procedure Key_RIGHT;
    procedure Key_Left;
    procedure main;
    function setHeadOfColumns(): SArray;
  end;

implementation

constructor ViewTable.Init(start_x, start_y, border_x, border_y, width, height, abs_background: integer);
begin
  countColumn := 7;
  borderFreeSpace := 2;
  head_width := width;
  head_height := height;
  x := start_x;
  y := start_y;
  x_border := border_x;
  y_border := border_y;
  background := abs_background;
  List := Cls_List.Init;
end;

function ViewTable.setHeadOfColumns(): SArray;
begin
  Result[1] := 'Название';
  Result[2] := 'Адрес';
  Result[3] := 'Тип подчинения';
  Result[4] := 'Год основания';
  Result[5] := 'Номер лицензии';
  Result[6] := 'Номер аккредитации';
  Result[7] := 'Дата окончания действия аккредитации';
end;

procedure ViewTable.show_head;
var
  i: integer;
  columnHeader: SArray;
begin
  columnHeader := setHeadOfColumns;
  for i := 1 to countColumn do
  begin
    head_width := length(columnHeader[i]);
    head_buttons[i] := TextButton.Init(head_width, head_height, x, y, background, columnHeader[i]);
    head_buttons[i].Border := border.Init('-', borderFreeSpace, x, y, y, head_width);
    head_buttons[i].Border.ChangeColor(1);
    head_buttons[i].Border.create;
    head_buttons[i].Create;
    x := x + length(columnHeader[i]) + borderFreeSpace;
  end;
  y := y + ((borderFreeSpace * 2)-1);
end;

procedure ViewTable.show_line();
var
  i: integer;
  s_text: string;
begin
  //borderFreeSpace := 1;

  for i := 1 to countColumn do
  begin
    s_text := '';
    Cells[i] := Cell.Init(length(head_buttons[i].text), head_height, head_buttons[i].x_pos, y, background, s_text);
    Cells[i].Border := Border.Init('-', borderFreeSpace-1, head_buttons[i].x_pos, y, y, length(head_buttons[i].text));
    Cells[i].Border.ChangeColor(1);
    Cells[i].Border.Create;
    Cells[i].Create;
  end;
  List.add_line(Cells);

  y := y + ((borderFreeSpace * 2)-2);
end;

procedure ViewTable.show_table1();
begin
  show_head();
  while y < y_border do
    show_line(); {Изменить}
end;

procedure ViewTable.writeInCell;
var
  center_x, center_y: integer;
  input_field: TextButton;
begin
  center_x := (x_border - x) div 2;
  center_y := (y_border - y) div 2;

  input_field := TextButton.Init(10, 1, center_x - 10, center_y, background, '');
  input_field.Border := Border.Init('-', borderFreeSpace, center_x - 10, center_y, center_y, 10);
  input_field.Border.ChangeColor(1);

  gotoxy(center_x - 10, center_y);
  read(input_field.text);
end;

procedure ViewTable.main;
var
  run: boolean;
begin
  show_table1;
  List.Line := List.getNode(1);
  gotoxy(List.Line^.data[1].x_pos, List.Line^.data[1].y_pos);

  run := true;
  while run do
  begin
    case readkey of
      #72: begin

      end;
      #80: begin

      end;
      #13: begin
        writeInCell;
      end;
    end;
  end;
end;

procedure ViewTable.Key_UP;
begin

end;

procedure ViewTable.Key_DOWN;
begin

end;

procedure ViewTable.Key_RIGHT;
begin

end;

procedure ViewTable.Key_Left;
begin

end;

begin
end.

