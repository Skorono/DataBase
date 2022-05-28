unit storage;

{$mode ObjFPC}{$H+}
interface
uses
  Classes, SysUtils, base_graphic;

type PNode = ^Line_Node;
     Line_Node = record
       data: array[1..7] of Cell;
       next: PNode;
       previous: PNode;
     end;
     // Todo: Создать класс листа для передачи в класс для работы с базой
     Cls_List = class
       Line: PNode;
       function add_line: PNode;
       {procedure rewrite_line;}
     end;

implementation
  procedure rewrite_line;
  begin
  end;

  function Cls_List.add_line: PNode ;
  var
    new_Node: PNode;
  begin
     Line^.next := new_Node;
     Line^.next^.previous := Line;

     add_line := new_node;
  end;

end.

