unit db_representation;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Crt, GeneralTypes, Storage, base_graphic;

type
    { Menu }
    Menu = class
      x, y, x_border, y_border, on_button, background: byte;
      buttons: array[1..10] of TextButton;
      menu_border: Border;
      countButtons: byte;
    private
      borderExistence: boolean;
      procedure changePos(x_pos, y_pos: byte);
      procedure clearMenu;
      procedure eventKeyDown(var key: char); virtual;
      procedure SetBackground;
      procedure showMenu; virtual;
      procedure Key_UP; virtual;
      procedure Key_DOWN; virtual;
    public
      procedure Main;
      constructor Init(start_x, start_y, border_x , border_y, abs_background: integer);
      procedure addButton(text: string); virtual;
      {procedure paint_background;}
      destructor Destroy; override;
  end;

  { SwitchMenu }

  SwitchMenu = class(Menu)
    private
      procedure Key_UP; override;
      procedure Key_DOWN; override;
      procedure eventKeyDown(var key: char); override;
      procedure showMenu; override;
    public
      constructor Init(start_x, start_y, border_x , border_y, abs_background: integer);
      procedure addButton(text: string); override;
  end;

  { ViewTable }

  generic ViewTable<T> = class
  strict private
    table: T;
    procedure Load;
    procedure Save;
    procedure Search;
    procedure SortMode;
    procedure ShowHeadMod;
    procedure DeleteMode;
    procedure WriteMode;
  public
    procedure Main(var menu: Menu);
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
    borderExistence := true;
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
    {x � y ������������ ������������ ����. �� ���� ���� � ����� x=10 � y=10 �� ��� �������� ���������� ����������. � ����������� ����� ������ ��� ������� ����� ��� �� ���������}
    {Paint_Background();}
    //cord_x := (x_border div 2) - (text_size div 2);
    //cord_y := (y_border div 2) + spaceBetweenButtons;

    for i:= 1 to countButtons do
      buttons[i].show();

    if borderExistence then
    begin
      menu_border := border.Init('~', 5, 6, buttons[1].x_pos, buttons[1].y_pos, buttons[countButtons].y_pos, text_size);
      menu_border.show;
    end;
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

  procedure Menu.Key_UP;
  begin
    //buttons[on_button].background := 0;
    buttons[on_button].ChangeColor(15);
    if on_button = 1 then
      on_button := countButtons
    else
      on_button := on_button - 1;
    //Key_UP := on_button;
  end;

  procedure Menu.Key_DOWN;
  begin
    buttons[on_button].ChangeColor(15);
    if on_button = countButtons then
      on_button := 1
    else
      on_button := on_button + 1;
    //Key_DOWN := on_button;
  end;

  procedure Menu.eventKeyDown(var key: char);
  begin
    if key = #0 then
      begin
        case readkey of
          #72: Key_UP;
          #80: Key_DOWN;
        end;
      end
  end;

  procedure Menu.Main();
  var
    key: char;
  begin
    cursoroff;
    showMenu;
    buttons[on_button].ChangeColor(15);
    window(x, y, x_border, y_border);

    key := #0;
    on_button := 1;
    while ((key <> #27) and (key <> #13))do
    begin
      buttons[on_button].ChangeColor(2);
      key := readkey;
      eventKeyDown(key);
      if key = #27 then
        on_button := 0;
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
    if borderExistence then
      menu_border.clearBorder;
  end;

  destructor Menu.Destroy;
  var
    i: integer;
  begin
    for i := 1 to countButtons do
      buttons[i].Destroy;

    if menu_border <> nil then
      menu_border.Destroy;
  end;

  constructor SwitchMenu.Init(start_x, start_y, border_x , border_y, abs_background: integer);
  begin
    inherited Init(start_x, start_y, border_x , border_y, abs_background);
    borderExistence := false;
    //menu_border := nil;
  end;

  procedure SwitchMenu.showMenu;
  begin
    inherited showMenu;
    buttons[countButtons].clearButton;
  end;

  procedure SwitchMenu.Key_UP;
  begin
    inherited Key_UP;

    if on_button <> countButtons then
      buttons[on_button+1].clearButton
    else
      buttons[1].clearButton;
  end;

  procedure SwitchMenu.Key_DOWN;
  begin
    inherited Key_DOWN;
    if on_button <> 1 then
      buttons[on_button-1].clearButton
    else
      buttons[countButtons].clearButton;
  end;

  procedure SwitchMenu.eventKeyDown(var key: char);
  begin
    if key = #0 then
      begin
        case readkey of
          #77: Key_DOWN;
          #75: Key_UP;
        end;
      end
  end;

  procedure SwitchMenu.addButton(text: string);
  begin
    inherited addButton(text);
    buttons[countButtons].y_pos := y;
  end;

  procedure ViewTable.Main(var menu: Menu);
var
  key: char;
  currentCellCoords: Coords;
begin
  table := T.Init(2, 2, 36, 8, 1);
  //�������� ��������������
  menu.changePos(table.head_buttons[table.countColumn-1].x_pos + table.head_width + (menu.menu_border.XborderFreeSpace + 3),
                 table.additional_textbutton[3].y_pos + (menu.menu_border.XborderFreeSpace + 3));
  menu.showMenu;
  table.showPage;
  key := ' ';
  currentCellCoords := table.getCellCoords(table.on_vertical_button, 1);
  gotoxy(currentCellCoords[1], currentCellCoords[2]);
  repeat
    key := readkey;
    case key of
      #1: WriteMode;
      #4: DeleteMode;
      #16: SortMode;
      #19: Save;
      #12: Load;
      #6: Search;
      #8: ShowHeadMod;
    end;
    table.switchPage(key);
  until (key = #27);
end;

procedure ViewTable.WriteMode; { �������� main}
var
  key: char;
  currentCellCoords: Coords;
begin
  repeat
    table.showPositionHint;
    window(table.x, table.y, table.x_border, table.y_border);

    currentCellCoords := table.getCellCoords(table.on_vertical_button, table.on_horizontal_button);
    gotoxy(currentCellCoords[1], currentCellCoords[2]);

    key := readkey;
    if key = #0 then
    begin
      case readkey of
        #72: table.Key_UP;
        #80: table.Key_DOWN;
        #75: table.Key_LEFT;
        #77: table.Key_RIGHT;
      end;
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
  table.showpage;
end;

procedure ViewTable.SortMode;
const
  preliminaryTextLen = 9;
var
  selectionDescription: TextButton;
  selectionMenu: SwitchMenu;
  head_name: byte;
begin
  table.additional_textbutton[length(table.additional_textbutton) - 1].clearButton;
  selectionMenu := table.createSelectionMenu;
  selectionDescription := TextButton.Init(preliminaryTextLen, 1, selectionMenu.x, selectionMenu.y, 0, 'Sort by: ');
  selectionMenu.x := selectionMenu.x + preliminaryTextLen;

  selectionDescription.show;
  for head_name := 0 to table.countColumn - 1 do
    selectionMenu.addButton(table.head_buttons[head_name].getText);
  selectionMenu.Main;
  selectionDescription.Destroy;

  table.SortTable(selectionmenu.on_button);
  table.showPage;
end;

procedure ViewTable.Save;
var
  lastLineInTable: PLine;
  field: TextButton;
  x_, y_, width: integer;
begin
  lastLineInTable := table.lineList.getNode(table.lineCount);
  x_ := lastLineInTable^.data[1].x_pos;
  y_ := lastLineInTable^.data[table.countColumn].y_pos + (table.borderFreeSpace * 2);
  width := lastLineInTable^.data[table.countColumn].x_pos + lastLineInTable^.data[table.countColumn].button_width - table.borderFreeSpace;
  field := table.createInputField(x_, y_, width);
  table.enterSavePath(field);
  table.Save(field.getText);
  field.border.destroy;
  field.destroy;
end;

procedure ViewTable.Load;
var
  coordsOfTheLastLine: Coords;
  field: TextButton;
  x_, y_, width: integer;
begin
  coordsOfTheLastLine := table.getCellCoords(table.lineCount, 1);
  x_ := coordsOfTheLastLine[1];
  y_ := coordsOfTheLastLine[2] + (table.borderFreeSpace * 2);
  width := x_ + table.head_width - table.borderFreeSpace;  // ������ ���������!!!
  field := table.createInputField(x_, y_, width);
  table.enterSavePath(field);
  table.Load(field.getText);
  field.border.destroy;
  field.destroy;
  table.showpage;
end;

procedure ViewTable.Search;
const
  preliminaryTextLen = 11;
var
  coordsOfTheLastLine: Coords;
  selectionDescription, field: TextButton;
  selectionMenu: SwitchMenu;
  head_name: byte;
begin
  table.additional_textbutton[length(table.additional_textbutton) - 1].clearButton;

  selectionMenu := table.createSelectionMenu;
  selectionMenu.x := selectionMenu.x + preliminaryTextLen;

  selectionDescription := TextButton.Init(preliminaryTextLen, 1, selectionMenu.x, selectionMenu.y, 0, 'Search in: ');
  selectionMenu.x := selectionMenu.x + preliminaryTextLen;
  selectionDescription.show;

  for head_name := 0 to table.countColumn - 1 do
    selectionMenu.addButton(table.head_buttons[head_name].getText);
  selectionMenu.Main;
  selectionDescription.Destroy;

  coordsOfTheLastLine := table.getCellCoords(table.lineCount, 1);
  field := table.createInputField(coordsOfTheLastLine[1], coordsOfTheLastLine[2] + (table.borderFreeSpace * 2),
            coordsOfTheLastLine[1] + table.head_width - table.borderFreeSpace);
  field.setText(table.enterTextFormat(field));
  table.search(field.getText(), selectionMenu.on_button);
end;

procedure ViewTable.ShowHeadMod;
var
  key: char;
  on_button: byte = 0;
  button: byte;
begin
  table.clearHeadButtons;
  table.PutButtonsOnEachOther(on_button+1, table.countColumn);
  for button := 0 to table.countColumn - 1 do
  begin
    table.head_buttons[button].show;
    table.head_buttons[button].border.show;
  end;
  repeat
    key := readkey;
    case key of
      #75: table.SwitchHeadButton_Left(on_button);
      #77: table.SwitchHeadButton_Right(on_button);
    end;
  until key = #27;
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

