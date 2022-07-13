unit storage;

{$mode ObjFPC}{$H+}
interface
uses
  Classes, SysUtils, base_graphic;

type PLine = ^Line_Node;
     Line_Node = record
       data: array[1..7] of Cell;
       number: word;
       next: PLine;
       previous: PLine;
     end;

     Cls_List = class
       strict private
         Line: PLine;
       public
         nodeCount: integer;
         constructor Init;
         destructor Del;
         function getNode(n: integer): PLine;
         procedure add_line(cells: array of Cell);
         procedure rewrite_cell;
         procedure save;
         {procedure rewrite_line;}
     end;

implementation
  constructor Cls_List.Init;
  begin
    nodeCount := 0;
    Line:=nil;
  end;

  procedure Cls_List.rewrite_cell;
  begin
  end;

  procedure Cls_List.add_line(cells: array of Cell);
  var
    new_Node, list_copy: PLine;
  begin
     new(new_Node);
     new_Node^.data := cells;
     new_Node^.next := nil;
     nodeCount := nodeCount + 1;

     if Line = nil then
     begin
       new_node^.previous := nil;
       Line := new_node;
       Line^.number := 1;
     end
     else
     begin
       list_copy := Line;
       while list_copy^.next <> nil do
         list_copy := list_copy^.next;
       list_copy^.next := new_node;
       new_node^.previous := list_copy;
       new_node^.number := list_copy^.number + 1;
     end;
  end;

  procedure Cls_List.save;
  begin

  end;

  function Cls_List.getNode(n: integer): PLine;
  var
    line_copy: PLine;
  begin
     if nodeCount > 0 then
     begin
       line_copy := Line;
       if line_copy <> nil then
       begin
         while (line_copy^.number <> n) and (line_copy^.next <> nil) do
           line_copy := line_copy^.next;
         getNode := line_copy;
       end;
     end;
  end;

  destructor Cls_List.Del;
  var
    t: PLine;
  begin
    while p<>nil do
    begin
      t:=line;
      line:=line^.next;
      Dispose(t);
    end;
  end;
end.

