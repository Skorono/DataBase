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
    private
      menu_border: Border;
      countButtons: byte;
      widthOfOffset, heightOfOffset: byte;
      // существование границы
      borderExistence: boolean;
      procedure changePos(x_pos, y_pos: byte);
      procedure changeSize(new_width_offset, new_height_offset: byte);
      procedure clearMenu;
      procedure eventKeyDown(var key: char); virtual;
      procedure SetBackground;
      procedure Show; virtual;
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
  // наследник Меню (находится внизу)
  SwitchMenu = class(Menu)
    private
      procedure Key_LEFT;
      procedure Key_RIGHT;
      procedure eventKeyDown(var key: char); override;
      procedure Show; override;
    public
      constructor Init(start_x, start_y, border_x , border_y, abs_background: integer);
      procedure addButton(text: string); override;
  end;

  { ViewTable }
  // дженерик взаимодействующий с таблицей
  generic ViewTable<T> = class
  strict private
    table: T;
    procedure Load;
    procedure Save;
    procedure Search;
    procedure SortMode;
    //procedure ShowHeadMod;
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

  procedure Menu.Show();
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

    if borderExistence then // если параметр true
    begin
      if menu_border = nil then
        menu_border := border.Init('~', 5, 6, buttons[1].GetStartX, buttons[1].GetTopY, buttons[countButtons].GetBottomY, text_size);
      // BUG
      menu_border.show;
    end;
  end;

  { Передвигает меню по новым координатам}
  procedure Menu.changePos(x_pos, y_pos: byte);
  const
    spaceBetweenButtons = 2;
  var
    new_button_y, i: integer;
  begin
    x := x_pos;
    y := y_pos;
    for i := 1 to countButtons do
    begin
      if i = 1 then
        new_button_y := y
      else
        new_button_y := buttons[i-1].GetTopY + spaceBetweenButtons; // сдвигаем по отношению к предыдущему
      buttons[i].ChangePos(x, new_button_y,
                            x + buttons[i].GetWidth, buttons[i].GetBottomY + spaceBetweenButtons);
    end;

    if menu_border <> nil then
      menu_border.ChangePos(buttons[1].GetStartX, buttons[1].GetTopY, buttons[countButtons].GetBottomY);
  end;

  {Изменяет размер меню посредством передвижения границы относительно текста
  Размер меню изменится при следующей отрисовке
  }
  procedure Menu.changeSize(new_width_offset, new_height_offset: byte);
  begin
    if borderExistence then
    begin
      widthOfOffset  := new_width_offset;
      heightOfOffset := new_height_offset;
      menu_border.changeSize(widthOfOffset, heightOfOffset);
    end;
  end;

  // добавляет кнопку в меню
  procedure Menu.addButton(text: string);
  const
    spaceBetweenButtons = 2;
  var
    cord_y: integer;
  begin
    // меняется только координата по Y
    if countButtons > 0 then  // если это не первая кнопка
      cord_y := buttons[countButtons].GetTopY + spaceBetweenButtons // следующая кнопка ниже предыдущей
    else
      cord_y := y; // если первая кнопка
    countButtons := countButtons + 1;
    buttons[countButtons] := TextButton.Init(length(text), spaceBetweenButtons, x, cord_y, background, text);
  end;

  procedure Menu.Key_UP;
  begin
    //buttons[on_button].background := 0;
    buttons[on_button].ChangeColor(15);
    buttons[on_button].show;
    if on_button = 1 then
      on_button := countButtons
    else
      on_button := on_button - 1;
    //Key_UP := on_button;
  end;

  procedure Menu.Key_DOWN;
  begin
    buttons[on_button].ChangeColor(15);
    buttons[on_button].show;
    if on_button = countButtons then
      on_button := 1
    else
      on_button := on_button + 1;
    //Key_DOWN := on_button;
  end;

  // обрабатывает событие нажатия кнопки
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
    Show;  // отрисовывает меню
    buttons[on_button].ChangeColor(15); // меняем цвет у кнопки на которой находится курсор
    buttons[on_button].show;
    window(x, y, x_border, y_border);

    key := #0;
    on_button := 1;
    while ((key <> #27) and (key <> #13)) do
    begin
      buttons[on_button].ChangeColor(2);
      buttons[on_button].show;
      key := readkey;
      eventKeyDown(key);
      if key = #27 then // ESC выход из программы
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
      buttons[i].clear;
    if borderExistence then
      menu_border.clear;
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
    borderExistence := false; // В этом типе меню границы нет
    //menu_border := nil;
  end;

  procedure SwitchMenu.Show;
  begin
    inherited Show;
    buttons[countButtons].clear;
  end;

  // LEFT
  procedure SwitchMenu.Key_LEFT;
  begin
    inherited Key_UP;

    if on_button <> countButtons then
      buttons[on_button+1].clear
    else
      buttons[1].clear;
  end;

  // RIGHT
  procedure SwitchMenu.Key_RIGHT;
  begin
    inherited Key_DOWN;
    if on_button <> 1 then
      buttons[on_button-1].clear // on_button-1 стирает предыдущий элемент
    else
      buttons[countButtons].clear;
  end;

  procedure SwitchMenu.eventKeyDown(var key: char);
  begin
    if key = #0 then
      begin
        case readkey of
          #77: Key_RIGHT;
          #75: Key_LEFT;
        end;
      end
  end;

  procedure SwitchMenu.addButton(text: string);
  begin
    inherited addButton(text);
    buttons[countButtons].ChangePos(buttons[countButtons].GetStartX, y,                                 // поскольку элементы меню находятся в одной точке Y устанавливаем у всех одинаковый
                                      buttons[countButtons].GetLastX, buttons[countButtons].GetBottomY);
  end;

  procedure ViewTable.Main(var menu: Menu);
var
  key: char;
  currentCellCoords: Coords;
begin
  table := T.Init(2, 2, 36, 10, 1); // (2, 2, 36, 8, 1)
  menu.changePos(table.head_buttons[table.countColumn-1].GetStartX + table.head_width + (menu.menu_border.GetXOffsetFromText + 3),
                 table.additional_textbutton[7].GetTopY + (menu.menu_border.GetXOffsetFromText + 3)); // получаем позицию последней подсказки, прибавляем размер границы, чтобы она не мешала подсказке
  menu.Show; // отрисовываем меню
  //table.showPage; // отрисовываем страницу таблицы
  key := ' ';
  currentCellCoords := table.getCellCoords(table.on_vertical_button, 1); // получаем координаты курсора по позиции на странице
  gotoxy(currentCellCoords[1], currentCellCoords[2]); // перемещаем курсор по координатам
  repeat
    key := readkey;
    case key of
      #1: WriteMode;
      #4: DeleteMode;
      #16: SortMode;
      #19: Save;
      #12: Load;
      #6: Search;
      //#8: ShowHeadMod;
    end;
    table.switchPage(key); // если нажато сочетание клавиш для переключения страницы, то она будет переключена, в противном случае ничего не произойдёт
  until (key = #27); // ESC
end;

// режим ввода
procedure ViewTable.WriteMode;
var
  key: char;
  currentCellCoords: Coords;
begin
  repeat
    window(table.x, table.y, table.x_border, table.y_border); // создаем окно по координатам таблицы

    currentCellCoords := table.getCellCoords(table.on_vertical_button, table.on_horizontal_button);  // получаем координаты ячейки на которой находится курсоп
    gotoxy(currentCellCoords[1], currentCellCoords[2]); // перемещаем курсор по координатам ячейки

    key := readkey;
    if key = #0 then
    begin
      table.onKeyDown(key);
    end
    else if key = #13 then // ENTER
      table.writeInCell;
  until key = #27;
end;

procedure ViewTable.DeleteMode;
var
  key: char;
begin
  //table.showPositionHint;
  key := ' ';
  table.on_horizontal_button := 1;
  table.on_vertical_button := 1;
  table.LineLighting(table.getFirstLineNumber(table.pageNumber) + (table.on_vertical_button-1), 7); // подсвечивает линию на которой находится курсор
  repeat
  key := readkey;
  if key = #0 then
  begin
    table.onDelKeyDown(key);
  end
  else if key = #4 then // Сtrl + D
  begin
    table.deleteLine(table.getFirstLineNumber(table.pageNumber) + (table.on_vertical_button-1));
  end;
  until (key = #27); // ESC
  table.turnOffDeleteLight;   // отключается подсветку у строки
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
  table.additional_textbutton[length(table.additional_textbutton) - 1].clear; // стирает подсказку о позиции.
  selectionMenu := table.createSelectionMenu; // создаем переключающеес мееню
  selectionDescription := TextButton.Init(preliminaryTextLen, 1, selectionMenu.x, selectionMenu.y, 0, 'Sort by: '); // создаем текст перед меню
  selectionMenu.x := selectionMenu.x + preliminaryTextLen;  // сдвигаем меню от selectionDescription

  selectionDescription.show; // отрисовываем меню
  for head_name := 0 to table.countColumn - 1 do
    selectionMenu.addButton(table.head_buttons[head_name].getText); // добавляем кнопки с текстом из шапки таблицы
  selectionMenu.Main; // запускаем меню
  selectionDescription.Destroy; // удаляем текст

  table.SortTable(selectionmenu.on_button); // сортируем таблицу по столбцу выбранному в меню
  table.showPage;                           // отрисовываем страницу
end;

procedure ViewTable.Save;
var
  lastLineInTable: PLine;
  field: TextButton;
  x_, y_, width: integer;
begin
  lastLineInTable := table.lineList.getNode(table.lineCount);
  x_ := lastLineInTable^.data[1].GetStartX;
  y_ := lastLineInTable^.data[table.countColumn].GetTopY + (table.borderFreeSpace * 2);
  width := lastLineInTable^.data[table.countColumn].GetStartX + lastLineInTable^.data[table.countColumn].GetWidth - table.borderFreeSpace; // (переписать writeInCell)
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
  coordsOfTheLastLine := table.getCellCoords(table.lineCount, 1); // получаем координаты первой ячейки последней строки на странице
  x_ := coordsOfTheLastLine[1];   // устанавливаем значение переменной
  y_ := coordsOfTheLastLine[2] + (table.borderFreeSpace * 2); // устанавливаем значение переменной по Y со сдвигом вниз.
  width := x_ + table.head_width * table.countColumn; // ЭТО ВАМ НЕ ШИРИНА! считаем ширину поля для ввода: это размер ширина одной ячеки помноженная на количество столбцов (переписать writeInCell)
                                                                                //
  field := table.createInputField(x_, y_, width); // создаем поля ввода с координатами и расчитанной шириной
  table.enterSavePath(field);
  table.Load(field.getText);
  field.border.destroy;
  field.destroy;
  table.showpage;
end;

procedure ViewTable.Search;
const
  preliminaryTextLen = 11; // размер подписи к меню выбора
var
  coordsOfTheLastLine: Coords;
  selectionDescription, field: TextButton;
  selectionMenu: SwitchMenu;
  head_name: byte;
begin
  table.additional_textbutton[length(table.additional_textbutton) - 1].clear;  // стираем подсказку о позиции

  selectionMenu := table.createSelectionMenu;  // создание меню выбора
  selectionMenu.x := selectionMenu.x + preliminaryTextLen;

  selectionDescription := TextButton.Init(preliminaryTextLen, 1, selectionMenu.x, selectionMenu.y, 0, 'Search in: '); // подпись к меню
  selectionMenu.x := selectionMenu.x + preliminaryTextLen;
  selectionDescription.show;

  for head_name := 0 to table.countColumn - 1 do
    selectionMenu.addButton(table.head_buttons[head_name].getText); // добавляем кнопки в меню выбора а именно названия столбцов.
  selectionMenu.Main;
  selectionDescription.Destroy; // удаление меню выбора после окончания работы с ним

  coordsOfTheLastLine := table.getCellCoords(table.lineCount, 1);
  field := table.createInputField(coordsOfTheLastLine[1], coordsOfTheLastLine[2] + (table.borderFreeSpace * 2),
            coordsOfTheLastLine[1] + ((table.head_width + (table.borderFreeSpace-1)) * table.countColumn)); // ширина поля ввода
  gotoxy(field.Border.GetStartX + field.border.GetXOffsetFromText, field.Border.GetTopY + field.border.GetYOffsetFromText); // перемещаем курсор к полю для ввода
  field.setText(table.enterText('', field.GetWidth - field.border.GetXOffsetFromText)); // enterText - ввод и проверка формата текста. setText - передача введенного текста полю
  table.search(field.getText(), selectionMenu.on_button); // поиск в таблице по тексту и номеру столбца
  field.border.Destroy;
  field.Destroy();
end;

// не используется
//procedure ViewTable.ShowHeadMod;
//var
//  key: char;
//  on_button: byte = 0;
//  button: byte;
//begin
//  table.clearHeadButtons;
//  table.PutButtonsOnEachOther(on_button+1, table.countColumn);
//  for button := 0 to table.countColumn - 1 do
//  begin
//    table.head_buttons[button].show;
//    table.head_buttons[button].border.show;
//  end;
//  repeat
//    key := readkey;
//    case key of
//      #75: table.SwitchHeadButton_Left(on_button);
//      #77: table.SwitchHeadButton_Right(on_button);
//    end;
//  until key = #27;
//end;

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
    clreol;  // стирает строку
    sleep(17);
  end;
  cursoron;
  table.destroy;
  //table.free;
end;

end.

