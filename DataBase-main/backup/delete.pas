unit delete;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Crt;
type
  A = class
    public
      a, b: integer;
      constructor Init(x, y: integer);
      procedure print_a;
  end;

implementation
  constructor A.Init(x, y: integer);
  begin
    a := x;
    b := y;
    writeln(a);
  end;

  procedure A.print_a;
  begin
//    writeln(a);
  end;

var
  cls: A;
begin
  cls.Init(5, 4);
  cls.print_a;
  readkey()
end.

