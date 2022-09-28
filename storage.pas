unit storage;

{$mode ObjFPC}{$H+}
interface
uses
  Classes, SysUtils, GeneralTypes, base_graphic;
const
  MAX_COUNT_OF_COLUMNS = 7;
type
     PLine = ^Line_Node;
     Line_Node = record
       data: array[1..MAX_COUNT_OF_COLUMNS] of Cell;
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
         procedure _renumberList;
         procedure _propetiesTransmission(sender: PLine; var recipient: PLine);
       public
         nodeCount: integer;
         constructor Init;
         destructor Destroy; override;
         function getNode(n: integer): PLine;
         procedure add_line(cells: array of Cell);
         procedure rewrite_cell;
         procedure insert(var elm: PLine; var replaceableNode: PLine);
         procedure delete(lineNumber: word);
         procedure save(name: string);
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

  procedure Cls_List.save(name: string);
  var
    i: integer;
    text: string;
    line_copy: PLine;
    f: file;
  begin
    assign(f, name);
    line_copy := Line;
    try
      rewrite(f, 1);
      while line_copy^.next <> nil do
      begin
        for i := 1 to MAX_COUNT_OF_COLUMNS do //columnCount
        begin
         text := line_copy^.data[i].text;
         if not isInteger(text) then
          BlockWrite(f, join('$', split(' ', text)), length(text)*sizeof(char))
         else
          BlockWrite(f, text, length(text)*sizeof(byte));
        end;
      line_copy := line_copy^.next;
      end;
    finally
      close(f);
    end;
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

  procedure Cls_List.delete(lineNumber: word);
  var
    i: integer;
    newEmptyElm, elm: PLine;
  begin
    new(newEmptyElm);
    newEmptyElm^.next := nil;
    newEmptyElm^.previous := nil;
    elm := getNode(lineNumber);
    newEmptyElm^.number := elm^.number;
    for i := 1 to MAX_COUNT_OF_COLUMNS do
    begin
      newEmptyElm^.data[i] := Cell.Create;
      newEmptyElm^.data[i].border := Border.Create;
    end;
    _propetiesTransmission(elm, newEmptyElm);

    _pullOffElmFromList(elm);
    _insert(newEmptyElm, newEmptyElm^.number);
  end;

  procedure Cls_List.insert(var elm: PLine; var replaceableNode: PLine);
  var
    i: word;
    elmDataCopy: PLine;
  begin
    new(elmDataCopy);
    for i := 1 to MAX_COUNT_OF_COLUMNS do
    begin
      elmDataCopy^.data[i] := Cell.Create;
      elmDataCopy^.data[i].border := Border.Create;
    end;
    _propetiesTransmission(elm, elmDataCopy);

    i := replaceableNode^.number;
    _pullOffElmFromList(elm);
    _renumberList;
    _insert(elm, i);
    _renumberList;

    replaceableNode := getNode(i+1);
    _propetiesTransmission(replaceableNode, elm);
    _propetiesTransmission(elmDataCopy, replaceableNode);
  end;

  procedure Cls_List._insert(var elm: PLine; i: integer);
  var
    node: PLine;
  begin
    if i = nodeCount then
    begin
      node := getNode(i-1);
      node^.next := elm;
      elm^.previous := node;
    end
    else if i > 1 then
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

    node := elm^.previous;
    if elm^.number = nodeCount then
      node^.next := nil
    else if elm^.number > 1 then
    begin
      node^.next := elm^.next;
      node^.next^.previous := node;
    end
    else if elm = Line then
      Line := Line^.next;
    dispose(elm);
    elm := newN;
  end;

  procedure Cls_List._renumberList;
  var
    j: integer;
    node: PLine;
  begin
    node := Line;
    for j := 1 to nodeCount do
     begin
      if node <> nil then
      begin
        if node^.previous <> nil then
          node^.number := node^.previous^.number + 1
        else
          node^.number := 1;
        node := node^.next
      end;
     end;
  end;

  procedure Cls_List._propetiesTransmission(sender: PLine; var recipient: PLine);
  var
    cell: byte;
  begin
    for cell := 1 to MAX_COUNT_OF_COLUMNS do
    begin
      if (sender^.data[cell] <> nil) and (recipient^.data[cell] <> nil) then
      begin
        recipient^.data[cell].x_pos := sender^.data[cell].x_pos;
        recipient^.data[cell].y_pos := sender^.data[cell].y_pos;
        recipient^.data[cell].border.start_x := sender^.data[cell].border.start_x;
        recipient^.data[cell].border.last_x := sender^.data[cell].border.last_x;
        recipient^.data[cell].border.top_y := sender^.data[cell].border.top_y;
        recipient^.data[cell].border.bottom_y := sender^.data[cell].border.bottom_y;
      end;
    end;
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

