unit storage;

{$mode ObjFPC}{$H+}

interface
type PNode = ^Node;
     IntNode = record
       data: integer;
       next: PNode;
       previous: PNode;
     end;

     StrNode = record
       data: string;
       next: PNode;
       previous: PNode;
     end;

     FloatNode = record
       data: real;
       next: PNode;
       previous: PNode;
     end;
     Cls_List = class

     end;

uses
  Classes, SysUtils;

implementation

end.

