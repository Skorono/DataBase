unit GeneralTypes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  Coords = array[1..2] of integer;
  Header = array of string;
  ArrOfString = array of string;
  writeableRecord = record
    Type_ID: char;
    text: string[255];
    number: integer;
  end;

  ObjOnScreenInf = record
    x, y, last_x, last_y, background: byte;
  end;

  function isString(text: string): boolean;
  function isInteger(text: string): boolean;
  function isMore(str1, str2: string): boolean;
  function split(symbol: char; str: string): ArrOfString;
  function join(symbol: char; arr_str: ArrOfString): string;
  function max(arr: array of string): integer;
implementation

  function isString(text: string): boolean;
  var
    i: integer;
  begin
    result := true;
    if text = '' then
      result := false;
    for i := 1 to length(text) do
    begin
      if not (((text[i] in ['A'..'Z'])
              or (text[i] in ['a'..'z'])
              or (text[i] in ['А'..'Я'])
              or (text[i] in ['а'..'я'])
              or (text[i] in ['0'..'9'])
              or (text[i] = ' '))  then
        result := false;
    end;
  end;

  function isInteger(text: string): boolean;
  var
    i: integer = 0;
  begin
    result := true;
    if text = '' then
      result := false;
    while ((result) and (i < length(text))) do
    begin
      i := i + 1;
      if not (text[i] in ['0'..'9']) then
        result := false;
    end;
  end;

  function isMore(str1, str2: string): boolean;
  begin
    result := false;
    if (isInteger(str1) and isInteger(str2)) then
      if strToInt(str1) > strToInt(str2) then
        result := true;
    if (isString(str1) and isString(str2)) then
      if str1[1] > str2[1] then
        result := true;
  end;

  // возвращает массив "слов" разделенных опеределенным символом (symbol) -> split(): ["возвращает", "массив", "\"слов\"", "разделенных", "опеределенным", "символом", "(symbol)"]
  function split(symbol: char; str: string): ArrOfString;
  var
    i: byte;
  begin
    i := 1;   // количество символов до разделяемого символа (в частном случае: пробел).
    result := nil;
    while (length(str) >= i) and (str[1] <> '') do
    begin
      if str[i] = symbol then
      begin
        // split <=> result - это одно и то же. setlength - увеличивает количество элементов динамического массива
        setlength(result, length(result)+1); // length(result) - возвращает количество элементов в массиве. result индексируется с 0 поэтому, если массив имеет в себе два элемента, то индекс второго будет равен 0.
        //if (i = length(str)) or (i = 1) then
        //  result[length(result)-1] := '';
        result[length(result)-1] := copy(str, 1, i-1); // копирует слово до пробела
        str := copy(str, i + 1, length(str));  // копируем оставшуюся часть текста без этого слова и (пробела)
        i := 1;
      end
      else
        i := i + 1;
    end;
    if str <> '' then
    begin
      setlength(result, length(result)+1);
      result[length(result)-1] := str; // присваиваем оставшуюся часть строки последнему элементу.
    end;
  end;

  //  Соединяет массив строк символом.
  function join(symbol: char; arr_str: ArrOfString): string;
  var
    i: integer;
    new_str: string;
  begin
    new_str := ''; // динамически изменяемая строка
    result := '';
    for i := 0 to length(arr_str)-1 do
      new_str := new_str + arr_str[i] + symbol; // изменяем строку
    //result := new_str + arr_str[length(arr_str)-1];
    result := new_str;
  end;

  function max(arr: array of string): integer;
  var
    strI, maxL: integer;
  begin
    maxL := 0;
    for strI := 0 to Length(arr) - 1 do
    begin
      if length(arr[strI]) > maxL then
        maxL := length(arr[strI]);
    end;
    result := maxL;
  end;

end.



