program Main;

{$mode objfpc}{$H+}

uses
  Classes, Windows, Crt, base_graphic, db_representation, tables, storage;
type
  _table1 = specialize ViewTable<Table1>;
  _table2 = specialize ViewTable<Table2>;
  _table3 = specialize ViewTable<Table3>;

// удаление объекта предыдущей таблицы при создании новой
procedure destroyPreviousTable(var table1: _table1; var table2: _table2; var table3: _table3);
begin
  if table1 <> nil then
  begin
    table1.destroy;
    table1 := nil;
  end
  else if table2 <> nil then
  begin
    table2.destroy;
    table2 := nil;
  end
  else if table3 <> nil then
  begin
    table3.destroy;
    table3 := nil;
  end;
end;

// создание таблицы в зависимости от номера нажатой кнопки в меню
procedure createTable(var table1: _table1;  var table2: _table2; var table3: _table3; var menu_obj: Menu);
begin
  case menu_obj.on_button of
      1: begin
        table1 := _table1.Create;
        table1.main(menu_obj);
      end;
      2: begin
        table2 := _table2.Create;
        table2.main(menu_obj);
      end;
      3: begin
        table3 := _table3.Create;
        table3.main(menu_obj);
      end
    else      // в том случае если не выбрана ни одна кнопка
      begin
        menu_obj.Destroy;  // вызываем деструктор класса
        menu_obj := nil;
      end;
    end;
  end;

procedure main;
var
   main_menu: Menu;
   table1: _table1 = nil;
   table2: _table2 = nil;
   table3: _table3 = nil;
   backdrop: WindowManager;
begin
  backdrop := WindowManager.Init;
  main_menu := Menu.Init(110, 22, 240, 40, 0); // инициализируем меню по координатам
  main_menu.addButton('Учреждения');
  main_menu.addButton('Контрольные цифры приема');
  main_menu.addButton('Специальности');
  backdrop.createNewWindow(110, 22, 240, 40, 7);
  backdrop.showWindow(1);
  main_menu.Main;
  createTable(table1, table2, table3, main_menu);
  while main_menu <> nil do
  begin
    main_menu.Main;
    backdrop.showWindow(1);
    destroyPreviousTable(table1, table2, table3);  // удаление таблицы при перезаписи несохраненной таблицы
    createTable(table1, table2, table3, main_menu);
  end;
end;

begin
  SetConsoleCP(1251);
  SetConsoleOutputCP(1251);
  ShowWindow(GetConsoleWindow(), SW_MAXIMIZE);
  SetConsoleTitle('DataBase');
  main;
end.

