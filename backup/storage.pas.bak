unit storage;

{$mode ObjFPC}{$H+}
interface
uses
  Classes, SysUtils, GeneralTypes, base_graphic;

type
     PLine = ^Line_Node;
     Line_Node = record
       data: array[1..7] of Cell;
       number: word;
       next: PLine;
       previous: PLine;
     end;

     { Cls_List }

     Cls_List = class
       strict private
         Line: PLine;
         procedure _pullOffElmFromList(var elm: PLine);
         procedure _insert(var elm: PLine; i: integer);
         procedure _renumberList(fromI, toI: integer);
       public
         nodeCount: integer;
         constructor Init;
         destructor Destroy; override;
         function getNode(n: integer): PLine;
         procedure add_line(cells: array of Cell);
         procedure rewrite_cell;
         procedure insert(var elm: PLine; i: integer);
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

  {Добавляет линию таблицы в список.
  В процессе создается копия(list_copy) свойства класса Line,
  затем копии присваивается адрес параметра записи "next" до момента,
  пока не будет найден последний элемент списка.
  После нахождения в конец становится
  указатель на запись, содержащую линию}
  procedure Cls_List.add_line(cells: array of Cell);
  var
    new_node, list_copy: PLine;
  begin
     new(new_node);
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

  {Возвращает строку таблицы с определенным номером.
  Создается копия (line_copy) свойства класс Line ей передается ссылка на следующий элемент,
  пока не будет найден элемент списка с нужным номером.
  }
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

  procedure Cls_List.insert(var elm: PLine; i: integer);
  var
    number: integer;
  begin
     number := elm^.number + 1;
     _pullOffElmFromList(elm);
     _renumberList(number, nodeCount);
     _insert(elm, i);
     _renumberList(i, nodeCount);
  end;

  procedure Cls_List._insert(var elm: PLine; i: integer);
  var
    node: PLine;
  begin
    if i > 1 then
    begin
      node := getNode(i-1);
      elm^.next := node^.next;
      elm^.previous := node;
      node^.next^.previous := elm;
      node^.next := elm;
    end
    else if i = 1 then
    begin
      node := getNode(i);
      node^.previous := elm;
      elm^.next := node;
      Line := elm;
    end
    else if i = nodeCount then
    begin
      node := getNode(i);
      node^.next := elm;
      elm^.previous := node;
    end;
    elm^.number := i;
  end;

  procedure Cls_List._pullOffElmFromList(var elm: PLine);
  var
    newN, node: PLine;
  begin
    new(newN);
    newN^.data := elm^.data;
    newN^.next := nil;
    newN^.previous := nil;
    if (elm^.number > 1) and (elm^.number <> nodeCount) then
    begin
      node := elm^.previous;
      node^.next := elm^.next;
      node^.next^.previous := node;
    end
    else if elm = Line then
      Line := Line^.next;
    dispose(elm);
    elm := newN;
  end;

  procedure Cls_List._renumberList(fromI, toI: integer);
  var
    j: integer;
    node: PLine;
  begin
    node := getNode(fromI);
    if fromI = 2 then
    begin
      node^.number := 1;
      node := node^.next;
      fromI := fromI + 1;
    end;

    for j := fromI to toI do
     begin
      if node <> nil then
      begin
        if node^.previous <> nil then
          node^.number := node^.previous^.number + 1
        else
          node^.number := 1;
        node := node^.next;
      end;
     end;
    if (node <> nil) and (node^.next = nil) then
      nodeCount := node^.number;
  end;

  {
  Полность удаляет список
  }
  destructor Cls_List.Destroy;
  var
    line_copy: PLine;
  begin
    line_copy := Line;
    while Line^.number < nodeCount do
    begin
      Line := Line^.next;
      Dispose(line_copy);
      line_copy := Line;
    end;
    Line := nil;
  end;
end.

