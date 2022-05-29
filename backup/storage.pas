unit storage;

{$mode ObjFPC}{$H+}
interface
uses
  Classes, SysUtils, base_graphic;

type PLine = ^Line_Node;
     Line_Node = record
       data: array[1..7] of Cell;
       next: PLine;
       previous: PLine;
     end;
     // Todo: Создать класс листа для передачи в класс для работы с базой

     Cls_List = class
       Line: PLine;
       function add_line(cells: array of Cell): PLine;
       procedure rewrite_cell;
       procedure save;
       {procedure rewrite_line;}
     end;

implementation
  procedure Cls_List.rewrite_cell;
  begin
  end;

  function Cls_List.add_line(cells: array of Cell): PLine ;
  var
    new_Node: PLine;
  begin
     new(Line^);
     Line^.data := cells;
     Line^.next := new_Node;
     Line^.next^.previous := Line;

     add_line := new_node;
  end;

  procedure Cls_List.save;
  begin

  end;

end.

