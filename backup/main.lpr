program Main;

{$mode objfpc}{$H+}

uses
  Classes, Windows, Crt, base_graphic, base_menu;

var
   menu_obj: Menu;
begin
  SetConsoleCP(1251);
  SetConsoleOutputCP(1251);
  ShowWindow(GetConsoleWindow(), SW_MAXIMIZE);
  SetConsoleTitle('DataBase');

  {áÂÌ ÂÌÃÎ ÀÇÃ  ÆÂ Ï ÜÎ  ÂÌ Ï !!! İ Á ÁÏ ÂÆË}
  menu_obj:=Menu.Init(100, 1, 215, 25, 0);
  menu_obj.Main;
  readkey();
end.

