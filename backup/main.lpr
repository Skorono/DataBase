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
  SetConsoleTitle('BD MENU');

  {Сделать отдельную передачу заднего цвета для Меню и отдельно для кнопок!!! Но после создания таблицы}
  menu_obj:=Menu.Init(1, 1, 80, 25, 0);
  menu_obj.Main;
  readkey();
end.

