unit GeneralTypes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  Header = array of string;
  ObjOnScreenInf = record
    x, y, last_x, last_y, background: byte;
  end;
implementation

end.

