unit Types;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  Header = array of string;

  ObjOnScreenInf = record
    x, y, last_x, last_y, background: byte;
  end;

  PLine = ^Line_Node;
     Line_Node = record
       data: array[1..7] of Cell;
       number: word;
       next: PLine;
       previous: PLine;
     end;
implementation

end.

