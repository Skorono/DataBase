unit GeneralTypes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  Header = array of string;
  ArrOfString = Header;
  ObjOnScreenInf = record
    x, y, last_x, last_y, background: byte;
  end;

  function isString(text: string): boolean;
  function isInteger(text: string): boolean;
  function split(symbol: char; str: string): ArrOfString;
  function join(symbol: char; arr_str: ArrOfString): string;
implementation
  function isString(text: string): boolean;
  var
    i: integer;
  begin
    result := true;
    for i := 1 to length(text) do
    begin
      if not (((text[i] in ['A'..'Z'])
              or (text[i] in ['a'..'z'])
              or (text[i] in ['À'..'ß'])
              or (text[i] in ['à'..'ÿ'])
              or (text[i] in ['0'..'9'])))  then
        result := false;
    end;
  end;

  function isInteger(text: string): boolean;
  var
    i: integer;
  begin
    result := true;
    for i := 1 to length(text) do
    begin
      if not (text[i] in ['0'..'9']) then
        result := false;
    end;
  end;

  function split(symbol: char; str: string): ArrOfString;
  var
    i: byte;
  begin
    i := 1;
    result := nil;
    while (length(str) >= i) and (str[1] <> '') do
    begin
      if str[i] = symbol then
      begin
        setlength(result, length(result)+1);
        if (i = length(str)) or (i = 1) then
          result[length(result)-1] := '';
        result[length(result)-1] := copy(str, 1, i-1);
        str := copy(str, i + 1, length(str));
        i := 1;
      end
      else
        i := i + 1;
    end;
    if str <> '' then
    begin
      setlength(result, length(result)+1);
      result[length(result)-1] := str;
    end;
  end;

  function join(symbol: char; arr_str: ArrOfString): string;
  var
    i: integer;
    new_str: string;
  begin
    new_str := '';
    result := '';
    for i := 0 to length(arr_str)-1 do
      new_str := new_str + arr_str[i] + symbol;
    //result := new_str + arr_str[length(arr_str)-1];
    result := new_str;
  end;
end.


