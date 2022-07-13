unit db_representation;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Crt, base_graphic;

type
    Menu = class sealed
      x, y, x_border, y_border, background: integer;
      buttons: array[1..10] of TextButton;
      menu_border: Border;
      countButtons: byte;
    private
      procedure Show_menu;
      function Key_UP(on_button: integer): integer;
      function Key_DOWN(on_button: integer): integer;
    public
      procedure Main(var result: integer);
      constructor Init(start_x, start_y, border_x , border_y, abs_background: integer);
      {procedure paint_background;}
      destructor del;
  end;

  generic ViewTable<T> = class
      table: T;
    public
      procedure Main(var menu: Menu);
      procedure DeleteMode;
      procedure WriteMode;
      destructor Destroy; override;
  end;

implementation
constructor Menu.Init(start_x, start_y, border_x , border_y, abs_background: integer);
  begin
    x := start_x;
    y := start_y;
    x_border := border_x;
    y_border := border_y;
    countButtons := 3;
    background := abs_background;
  end;

  procedure Menu.Show_menu();
  const
    base_count = 3;
    spaceBetweenButtons = 2;
    text_size = 10;
  var
    text: string;
    cord_x, cord_y, i: integer;
    //allert: TextButton;
  begin
    Window(x, y, x_border, y_border);
    {x и y определяются относительно окна. То есть если я ввожу x=10 и y=10 то это значения становятся начальными. К ограничению конца строки это правило вроде как не действует}
    {Paint_Background();}
    //cord_x := (x_border div 2) - (text_size div 2);
    //cord_y := (y_border div 2) + spaceBetweenButtons;
    cord_x := x;
    cord_y := y;

    for i:= 1 to base_count do
      begin
        text := 'Таблица №' + inttostr(i);
        buttons[i] := TextButton.Init(text_size, spaceBetweenButtons, cord_x, cord_y, background, text);
        buttons[i].show();
        cord_y := cord_y + spaceBetweenButtons;
      end;
    menu_border := border.Init('~', 9, buttons[1].x_pos, buttons[1].y_pos, buttons[countButtons].y_pos, text_size);
    menu_border.show;
  end;

  function Menu.Key_UP(on_button: integer): integer;
  begin
    buttons[on_button].background := 0;
    buttons[on_button].show();
    if on_button = 1 then
      on_button := countButtons
    else
      on_button := on_button - 1;
    Key_UP := on_button;
  end;

  function Menu.Key_DOWN(on_button: integer): integer;
  begin
    buttons[on_button].background := 0;
    buttons[on_button].show();
    if on_button = countButtons then
      on_button := 1
    else
      on_button := on_button + 1;
    Key_DOWN := on_button;
  end;

  procedure Menu.Main(var result: integer);
  var
    run: boolean;
    on_button: integer;
    key: char;
  begin
    Show_menu;
    window(x, y, x_border, y_border);
    run := true;
    on_button := 1;
    while run do
    begin
      buttons[on_button].background := 5;
      gotoxy(buttons[on_button].x_pos, buttons[on_button].y_pos);
      buttons[on_button].show();
      key := readkey;
      if key = #0 then
      begin
        case readkey of
        #72: begin
            on_button := Key_UP(on_button);
          end;
        #80: begin
            on_button := Key_DOWN(on_button);
          end;
        end
      end
      else if key = #13 then
      begin
        result := on_button;
        run := false;
        del;
      end
      else if key = #27 then
        run := false;
    end
  end;

  {procedure Menu.paint_background();
  var
    i: integer;
  begin
    TextBackground(background);

    for i := 1 to y_border do
    begin
      gotoxy(1, i);
      write('1');
    end;
  end;  }

  destructor Menu.Del;
  var
    i: integer;
  begin
    for i := 1 to countButtons do
      buttons[i].del;
    menu_border.del;
    self := nil;
  end;

  procedure ViewTable.Main(var menu: Menu);
var
  key: char;
begin
  textbackground(7);
  table := T.Init(2, 2, 56, 8, 1);
  menu.x := table.head_buttons[table.countColumn-1].x_pos + length(table.head_buttons[table.countColumn-1].text) + 12;
  menu.y := table.head_buttons[table.countColumn-1].y_pos + 18;
  menu.x_border := table.head_buttons[table.countColumn-1].x_pos + 30;
  menu.y_border := table.head_buttons[table.countColumn-1].y_pos + 30; {Костыль. Надо отслеживать координаты подсказки}
  menu.show_menu;
  table.showPage;
  key := ' ';
  table.line := table.lineList.getNode(table.getFirstLineNumber(table.pageNumber) + (table.on_vertical_button-1));
  gotoxy(table.line^.data[1].x_pos, table.line^.data[1].y_pos);
  repeat
  key := readkey;
  case key of
    #1: WriteMode;
    #4: DeleteMode;
  end;
  table.switchPage(key);
  until (key = #27);
  //Destroy;
end;

procedure ViewTable.WriteMode; { Временно main}
var
  key: char;
begin
  table.showPositionHint;
  window(table.x, table.y, table.x_border, table.y_border);
  table.line := table.lineList.getNode(table.getFirstLineNumber(table.pageNumber) + (table.on_vertical_button-1));
  gotoxy(table.line^.data[table.on_horizontal_button].x_pos, table.line^.data[table.on_horizontal_button].y_pos);
  repeat
    key := readkey;
    if key = #0 then
    begin
      case readkey of
        #72: table.Key_UP;
        #80: table.Key_DOWN;
        #75: table.Key_LEFT;
        #77: table.Key_RIGHT;
      end;
      table.showPositionHint;
      window(table.x, table.y, table.x_border, table.y_border);
      table.line := table.lineList.getNode(table.getFirstLineNumber(table.pageNumber) + (table.on_vertical_button-1));
      gotoxy(table.line^.data[table.on_horizontal_button].x_pos, table.line^.data[table.on_horizontal_button].y_pos);
    end
    else if key = #13 then
    begin
      table.writeInCell;
    end;
  until key = #27;
end;

procedure ViewTable.DeleteMode;
var
  key: char;
begin
  table.showPositionHint;
  key := ' ';
  table.on_horizontal_button := 1;
  table.on_vertical_button := 1;
  table.LineLighting(table.getFirstLineNumber(table.pageNumber) + (table.on_vertical_button-1), 7);
  repeat
  key := readkey;
  if key = #0 then
  begin
    case readkey of
      #72: table.DelKey_UP;
      #80: table.DelKey_DOWN;
    end;
    table.showPositionHint;
  end
  else if key = #4 then
  begin
    table.deleteLine(table.getFirstLineNumber(table.pageNumber) + (table.on_vertical_button-1));
  end;
  until (key = #27);
  table.turnOffDeleteLight;
end;

destructor ViewTable.Destroy;
var
  y: integer;
begin
  cursoroff;
  window(table.x, table.y, table.x_border, table.y_border);
  for y := 1 to table.y_border do
  begin
    gotoxy(1, y);
    clreol;
    sleep(1);
  end;
  cursoron;
  table.destroy;
  self := nil
end;

end.

