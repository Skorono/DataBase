program Main;

{$mode objfpc}{$H+}

uses
  Classes, Windows, Crt, base_graphic, db_representation, tables;
type
  _table1 = specialize ViewTable<Table1>;
  _table2 = specialize ViewTable<Table2>;
  _table3 = specialize ViewTable<Table3>;

procedure destroyPreviousTable(table1: _table1;  table2: _table2; table3: _table3; prev_table: integer);
begin
  case prev_table of
      1: table1.destroy;
      2: table2.destroy;
      3: table3.destroy;
    end;
end;

procedure createTable(var table1: _table1;  var table2: _table2; var table3: _table3; menu_obj: Menu; launched_table: integer);
begin
  case launched_table of
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
      end;
    end;
end;

procedure main;
var
   menu_obj: Menu;
   table1: _table1;
   table2: _table2;
   table3: _table3;
   launched_table, prev_table: integer;
begin
  menu_obj:=Menu.Init(110, 22, 240, 40, 0);
  menu_obj.Main(launched_table);
  createTable(table1, table2, table3, menu_obj, launched_table);
  repeat
    prev_table := launched_table;
    menu_obj.Main(launched_table);
    destroyPreviousTable(table1, table2, table3, prev_table);
    createTable(table1, table2, table3, menu_obj, launched_table);
  until launched_table = 0;
end;

begin
  SetConsoleCP(1251);
  SetConsoleOutputCP(1251);
  ShowWindow(GetConsoleWindow(), SW_MAXIMIZE);
  SetConsoleTitle('DataBase');
  TextMode(CO40);
  main;

  {áÂÌ ÂÌÃÎ ÀÇÃ  ÆÂ Ï ÜÎ  ÂÌ Ï !!! İ Á ÁÏ ÂÆË}

end.

