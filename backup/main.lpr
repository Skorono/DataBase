program Main;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, base_graphic
  { you can add units after this };
var
   menu_obj: Menu(0, 0, 1);
begin
  menu_obj.Create;
end.

