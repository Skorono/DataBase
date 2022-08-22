unit GeneralTypes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, base_graphic;

type
  Header = array of string;
  CellArray = array of Cell;
  ObjOnScreenInf = record
    x, y, last_x, last_y, background: byte;
  end;
implementation

end.

