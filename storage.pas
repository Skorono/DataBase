unit storage;

{$mode ObjFPC}{$H+}
interface
uses
  Classes, SysUtils, base_graphic;

type PLine = ^Line_Node;
     Line_Node = record
       data: array[1..7] of Cell;
       number: integer;
       next: PLine;
       previous: PLine;
     end;
     // Todo: Создать класс листа для передачи в класс для работы с базой

     Cls_List = class
       nodeCount: integer;
       Line: PLine;
       constructor Init;
       function add_line(cells: array of Cell): PLine;
       function getNode(n: integer): PLine;
       procedure rewrite_cell;
       procedure save;
       {procedure rewrite_line;}
     end;

implementation
  constructor Cls_List.Init;
  begin
    nodeCount := 0;
    new(Line);
    Line^.previous := nil;
  end;

  procedure Cls_List.rewrite_cell;
  begin
  end;

  function Cls_List.add_line(cells: array of Cell): PLine;
  var
    new_Node: PLine;
  begin
     new(Line);
     Line^.data := cells;
     Line^.next := new_Node;

     Line^.next^.previous := Line;

     add_line := new_node;
     add_line^.next := nil;
     nodeCount := nodeCount + 1;
  end;

  procedure Cls_List.save;
  begin

  end;

  function Cls_List.getNode(n: integer): PLine;
  begin
     new(Line);
     while Line^.previous <> nil do
       Line := Line^.previous;

     while (Line^.number <> n) and (Line <> nil) do
       Line := Line^.previous;
     getNode := Line;
  end;

end.

