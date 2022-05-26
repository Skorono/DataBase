program Main;

{$mode objfpc}{$H+}

uses
  Classes, Windows, Crt, base_graphic;

var
   menu_obj: Menu;
begin
  SetConsoleCP(1251);
  SetConsoleOutputCP(1251);
  ShowWindow(GetConsoleWindow(), SW_MAXIMIZE);
  SetConsoleTitle('BD MENU');
  menu_obj:=Menu.Init(1, 1, 0);
  menu_obj.Create;
  readkey();
end.

