program Main;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, base_graphic
  { you can add units after this };
var
   menu_obj: Menu;
begin
  menu_obj.Init(0, 0, 1);
  menu_obj.Create;
end.

