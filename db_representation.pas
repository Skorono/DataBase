unit db_representation;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Crt, Storage, base_graphic;

type
    { Menu }
    Menu = class sealed
      x, y, x_border, y_border, on_button, background: byte;
      buttons: array[1..10] of TextButton;
      menu_border: Border;
      countButtons: byte;
    private
      procedure changePos(x_pos, y_pos: byte);
      procedure clearMenu;
      procedure showMenu;
      procedure SetBackground;
      function Key_UP: integer;
      function Key_DOWN: integer;
    public
      procedure Main(var result: integer);
      constructor Init(start_x, start_y, border_x , border_y, abs_background: integer);
      procedure addButton(text: string);
      {procedure paint_background;}
      destructor Destroy; override;
  end;

  { ViewTable }

  generic ViewTable<T> = class
      table: T;
  private
    procedure SortMode;
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
    countButtons := 0;
    on_button := 1;
    background := abs_background;
  end;

  procedure Menu.SetBackground;
  var
    window: WindowManager;
  begin
    window := WindowManager.Init;
    window.createNewWindow(x - 5, y - 6, x_border, y_border, background);
    window.showWindow(1);
  end;

  procedure Menu.showMenu();
  const
    text_size = 24;
  var
    i: integer;
  begin
    Window(x, y, x_border, y_border);
    {x и y определяются относительно окна. То есть если я ввожу x=10 и y=10 то это значения становятся начальными. К ограничению конца строки это правило вроде как не действует}
    {Paint_Background();}
    //cord_x := (x_border div 2) - (text_size div 2);
    //cord_y := (y_border div 2) + spaceBetweenButtons;

    for i:= 1 to countButtons do
      buttons[i].show();
    menu_border := border.Init('~', 5, 6, buttons[1].x_pos, buttons[1].y_pos, buttons[countButtons].y_pos, text_size);
    menu_border.show;
  end;

  procedure Menu.changePos(x_pos, y_pos: byte);
  const
    spaceBetweenButtons = 2;
  var
    i: integer;
  begin
    x := x_pos;
    y := y_pos;
    for i := 1 to countButtons do
    begin
      buttons[i].x_pos := x;
      if i = 1 then
        buttons[i].y_pos := y
      else
        buttons[i].y_pos := buttons[i-1].y_pos + spaceBetweenButtons;
    end;
  end;

  procedure Menu.addButton(text: string);
  const
    spaceBetweenButtons = 2;
  var
    cord_x, cord_y: integer;
  begin
    cord_x := x;
    if countButtons > 0 then
      cord_y := buttons[countButtons].y_pos + spaceBetweenButtons
    else
      cord_y := y;
    countButtons := countButtons + 1;
    buttons[countButtons] := TextButton.Init(length(text)+1, spaceBetweenButtons, cord_x, cord_y, background, text);
  end;

  function Menu.Key_UP: integer;
  begin
    //buttons[on_button].background := 0;
    buttons[on_button].text_color := 15;
    buttons[on_button].show();
    if on_button = 1 then
      on_button := countButtons
    else
      on_button := on_button - 1;
    Key_UP := on_button;
  end;

  function Menu.Key_DOWN: integer;
  begin
    buttons[on_button].text_color := 15;
    buttons[on_button].show();
    if on_button = countButtons then
      on_button := 1
    else
      on_button := on_button + 1;
    Key_DOWN := on_button;
  end;

  {Достойно рефакторинга}
  procedure Menu.Main(var result: integer);
  var
    run: boolean;
    key: char;
  begin
    buttons[on_button].text_color := 15;
    //SetBackground;
    cursoroff;
    showMenu;
    window(x, y, x_border, y_border);
    run := true;
    on_button := 1;
    while run do
    begin
      //buttons[on_button].background := 2;
      buttons[on_button].text_color := 2;
      buttons[on_button].show();
      key := readkey;
      if key = #0 then
      begin
        case readkey of
        #72: begin
            on_button := Key_UP;
          end;
        #80: begin
            on_button := Key_DOWN;
          end;
        end;
      end
      else if key = #13 then
      begin
        result := on_button;
        run := false;
      end
      else if key = #27 then
      begin
        result := 0;
        run := false;
      end;
    end;
    clearMenu;
    cursoron;
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
  procedure Menu.clearMenu;
  var
    i: integer;
  begin
    for i := 1 to countButtons do
      buttons[i].clearButton;
    menu_border.clearBorder;
  end;

  destructor Menu.Destroy;
  var
    i: integer;
  begin
    for i := 1 to countButtons do
      buttons[i].Destroy;
    menu_border.Destroy;
  end;

  procedure ViewTable.Main(var menu: Menu);
var
  key: char;
  line: PLine;
begin
  table := T.Init(2, 2, 46, 8, 1);
  //достойно экстерминатуса
  menu.changePos(table.head_buttons[table.countColumn-1].x_pos + length(table.head_buttons[table.countColumn-1].text) + (menu.menu_border.XborderFreeSpace + 3), table.additional_textbutton[3].y_pos + (menu.menu_border.XborderFreeSpace + 3));
  menu.showMenu;
  table.showPage;
  key := ' ';
  line := table.lineList.getNode(table.getFirstLineNumber(table.pageNumber) + (table.on_vertical_button-1));
  gotoxy(line^.data[1].x_pos, line^.data[1].y_pos);
  repeat
    key := readkey;
    case key of
      #1: WriteMode;
      #4: DeleteMode;
      #16: SortMode;
    end;
    table.switchPage(key);
  until (key = #27);
end;

procedure ViewTable.WriteMode; { Временно main}
var
  key: char;
  line: PLine;
begin
  table.showPositionHint;
  window(table.x, table.y, table.x_border, table.y_border);
  line := table.lineList.getNode(table.getFirstLineNumber(table.pageNumber) + (table.on_vertical_button-1));
  gotoxy(line^.data[table.on_horizontal_button].x_pos, line^.data[table.on_horizontal_button].y_pos);
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
      line := table.lineList.getNode(table.getFirstLineNumber(table.pageNumber) + (table.on_vertical_button-1));
      gotoxy(line^.data[table.on_horizontal_button].x_pos, line^.data[table.on_horizontal_button].y_pos);
    end
    else if key = #13 then
      table.writeInCell;
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

procedure ViewTable.SortMode;
begin
  table.SortTable(1);
  table.showPage;
end;

destructor ViewTable.Destroy;
var
  y: integer;
begin
  cursoroff;
  window(table.x, table.y, table.x_border, table.y_border);
  TextBackground(0);
  for y := 1 to table.y_border do
  begin
    gotoxy(1, y);
    //delline;
    clreol;
    sleep(1);
  end;
  cursoron;
  table.destroy;
  //table.free;
end;

end.

