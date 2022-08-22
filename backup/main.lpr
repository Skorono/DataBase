program Main;

{$mode objfpc}{$H+}

uses
  Classes, Windows, Crt, base_graphic, db_representation, tables, storage;
type
  _table1 = specialize ViewTable<Table1>;
  _table2 = specialize ViewTable<Table2>;
  _table3 = specialize ViewTable<Table3>;

procedure destroyPreviousTable(var table1: _table1; var table2: _table2; var table3: _table3; prev_table: integer);
begin
  case prev_table of
      1: table1.destroy;
      2: table2.destroy;
      3: table3.destroy;
    end;
end;

procedure createTable(var table1: _table1;  var table2: _table2; var table3: _table3; var main_menu: Menu; launched_table: integer);
begin
  case launched_table of
      1: begin
        table1 := _table1.Create;
        table1.main(main_menu);
      end;
      2: begin
        table2 := _table2.Create;
        table2.main(main_menu);
      end;
      3: begin
        table3 := _table3.Create;
        table3.main(main_menu);
      end
  else
    main_menu.Destroy;
  end;
end;

procedure main;
var
   main_menu: Menu;
   table1: _table1;
   table2: _table2;
   table3: _table3;
   launched_table, prev_table: integer;
   //backdrop: WindowManager;
begin
  //backdrop := WindowManager.Init;
  main_menu := Menu.Init(110, 22, 240, 40, 0);
  main_menu.addButton('Учреждения');
  main_menu.addButton('Контрольные цифры приема');
  main_menu.addButton('Специальности');
  //backdrop.createNewWindow(110, 22, 240, 40, 7);
  //backdrop.showWindow(1);
  main_menu.Main(launched_table);
  createTable(table1, table2, table3, main_menu, launched_table);
  while launched_table <> 0 do
  begin
    prev_table := launched_table;
    main_menu.Main(launched_table);
    //backdrop.showWindow(1);
    destroyPreviousTable(table1, table2, table3, prev_table);
    createTable(table1, table2, table3, main_menu, launched_table);
  end;
end;

begin
  SetConsoleCP(1251);
  SetConsoleOutputCP(1251);
  ShowWindow(GetConsoleWindow(), SW_MAXIMIZE);
  SetConsoleTitle('DataBase');
  main;
end.

