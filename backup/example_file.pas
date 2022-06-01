unit example_file;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Storage, Crt, base_graphic;

type
  SArray = array[1..7] of string;

  ViewTable = class
    background, countColumn, head_width, head_height, on_vertical_button, on_horizontal_button: integer;
    x, y, x_border, y_border, y_line_pos: integer;
    Cells: array[1..7] of Cell;
    head_buttons: array[1..7] of TextButton;
    List: Cls_List;
    line: PLine; {�� ������ �������������}
    borderFreeSpace: integer;

    constructor Init(start_x, start_y, border_y, width, height, abs_background: integer);
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

constructor ViewTable.Init(start_x, start_y, border_y, width, height, abs_background: integer);
begin
  countColumn := 7;
  borderFreeSpace := 2;
  on_horizontal_button := 1;
  on_vertical_button := 1;
  head_width := width;
  head_height := height;
  x := start_x;
  y := start_y;
  y_border := border_y;
  background := abs_background;
  List := Cls_List.Init;
end;

function ViewTable.setHeadOfColumns(): SArray;
begin
  Result[1] := '��������';
  Result[2] := '�����';
  Result[3] := '��� ����������';
  Result[4] := '��� ���������';
  Result[5] := '����� ��������';
  Result[6] := '����� ������������';
  Result[7] := '���� ��������� �������� ������������';
end;

procedure ViewTable.show_head;
var
  i: integer;
  columnHeader: SArray;
  x_pos, y_pos: integer;
begin
  x_pos := x + borderFreeSpace;
  y_pos := y + borderFreeSpace ;
  columnHeader := setHeadOfColumns;
  for i := 1 to countColumn do
  begin
    head_width := length(columnHeader[i]);
    head_buttons[i] := TextButton.Init(head_width, head_height, x_pos, y_pos, background, columnHeader[i]);
    head_buttons[i].Border := border.Init('-', borderFreeSpace, x_pos, y_pos, y_pos, head_width);
    head_buttons[i].Border.ChangeColor(1);
    head_buttons[i].Create;
    x_pos := x_pos + length(columnHeader[i]) + borderFreeSpace;
  end;
  x_border := head_buttons[countColumn].x_pos + head_buttons[countColumn].button_width + head_buttons[countColumn].border.borderFreeSpace;
end;

procedure ViewTable.show_line();
var
  i: integer;
  s_text: string;
begin
  //borderFreeSpace := 1;
  line := List.getNode(List.nodeCount);
  if List.nodeCount > 1 then
  begin
    y_line_pos := line^.data[1].y_pos;
    y_line_pos := y_line_pos + ((borderFreeSpace * 2) - 2);
  end
  else
  begin
    y_line_pos := head_buttons[1].y_pos;
    y_line_pos := y_line_pos + ((borderFreeSpace * 2) - 1)
  end;
  for i := 1 to countColumn do
  begin
    s_text := '';
    Cells[i] := Cell.Init(length(head_buttons[i].text), head_height, head_buttons[i].x_pos, y_line_pos, background, s_text);
    Cells[i].Border := Border.Init('-', borderFreeSpace-1, head_buttons[i].x_pos, y_line_pos, y_line_pos, length(head_buttons[i].text));
    Cells[i].Border.ChangeColor(1);
    Cells[i].Border.Create;
    Cells[i].Show;
  end;
  List.add_line(Cells);
end;

procedure ViewTable.show_table1();
begin
  show_head();
  while y_line_pos < y_border do
    show_line();
end;

procedure ViewTable.writeInCell;
const
  height = 1;
var
  x_, y_, width: integer;
  input_field: TextButton;
begin
  x_ := line^.data[1].x_pos;
  y_ := y_border + borderFreeSpace + 1;
  width := line^.data[countColumn].x_pos + line^.data[countColumn].button_width - borderFreeSpace;
  window(x_, y_, x_ + width, y_ + (borderFreeSpace * 2));

  input_field := TextButton.Init(width, height, x_, y_, 0, '');
  input_field.Border := Border.Init('-', borderFreeSpace-1, x_, y_, y_, width);
  input_field.create;
  input_field.Border.ChangeColor(15);

  gotoxy(borderFreeSpace, borderFreeSpace);
  read(line^.data[on_horizontal_button].text);

  input_field.del;
  input_field.border.del;

  line^.data[on_horizontal_button].show;
end;

procedure ViewTable.main; { �������� main}
var
  run: boolean;
begin
  show_table1;
  window(x, y, x_border, y_border);
  line := List.getNode(1);
  gotoxy(line^.data[1].x_pos, line^.data[1].y_pos);

  run := true;
  while run do
  begin
    if readkey = #0 then
    begin
      case readkey of
        #72: begin
          Key_UP;
        end;
        #80: begin
          Key_DOWN;
        end;
        #75: begin
          Key_LEFT;
        end;
        #77: begin
          Key_RIGHT;
        end;
      end;
      line := List.getNode(on_vertical_button);
      gotoxy(line^.data[on_horizontal_button].x_pos, line^.data[on_horizontal_button].y_pos);
    end
    else if readkey = #13 then
      writeInCell;
  end;
end;

procedure ViewTable.Key_UP();
begin
  if on_vertical_button = 1 then
    on_vertical_button := List.nodeCount
  else
    on_vertical_button := on_vertical_button - 1;
end;

procedure ViewTable.Key_DOWN();
begin
  if on_vertical_button = List.nodeCount then
    on_vertical_button := 1
  else
    on_vertical_button := on_vertical_button + 1;
end;

procedure ViewTable.Key_RIGHT();
begin
  if on_horizontal_button = countColumn then
    on_horizontal_button := 1
  else
    on_horizontal_button := on_horizontal_button + 1;
end;

procedure ViewTable.Key_LEFT();
begin
  if on_horizontal_button = 1 then
    on_horizontal_button := countColumn
  else
    on_horizontal_button := on_horizontal_button - 1;
end;

begin
end.

