program Main;

{$mode objfpc}{$H+}

uses
  Classes, Windows, Crt;

{var
   menu_obj: Menu;}
begin
  SetConsoleCP(1251);
  SetConsoleOutputCP(1251);
  ShowWindow(GetConsoleWindow(), SW_MAXIMIZE);
  SetConsoleTitle('BD MENU');
  writeln(GetConsoleWindow());
  //menu_obj:=Menu.Init(1, 1, 0);
  //menu_obj.Create;
  readkey();
end.

