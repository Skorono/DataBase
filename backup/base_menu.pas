unit base_menu;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Crt, base_graphic, example_file;

type
    Menu = class sealed
      x, y, x_border, y_border, background: integer;
      buttons: array[1..10] of TextButton;
      menu_border: Border;

      countButtons: integer;
    private
      function Key_UP(on_button: integer): integer;
      function Key_DOWN(on_button: integer): integer;
      procedure press_enter(on_button: integer);

    public
      procedure Show_menu;
      procedure Main;
      constructor Init(abs_background: integer);
      {procedure paint_background;}
      destructor del;
  end;

implementation

constructor Menu.Init(abs_background: integer);
  begin
    x := 1;
    y := 1;
    x_border := 80;
    y_border := 25;
    countButtons := 3;
    background := abs_background;
  end;

  procedure Menu.Show_menu();
  const
    base_count = 3;
    text_size = 14;
    spaceBetweenButtons = 2;

  var
    text: string[text_size];
    cord_x, cord_y, i: integer;

  begin
    Window(x, y, x_border, y_border);
    {Paint_Background();}
    cord_x := (x_border div 2) - (text_size div 2);
    cord_y := y_border div 2;

    for i:= 1 to base_count do
      begin
        text := 'База Данных №' + inttostr(i);
        buttons[i] := TextButton.Init(text_size, spaceBetweenButtons, cord_x, cord_y, background, text);
        buttons[i].Create();
        cord_y := cord_y + spaceBetweenButtons;
      end;
    //menu_border := border.Init('~', 2, buttons[1].x_pos, buttons[1].y_pos, buttons[countButtons].y_pos, text_size);
    //menu_border.create;
  end;

  function Menu.Key_UP(on_button: integer): integer;
  begin
    buttons[on_button].background := 0;
    buttons[on_button].Create();
    if on_button = 1 then
      on_button := countButtons
    else
      on_button := on_button - 1;
    Key_UP := on_button;
  end;

  function Menu.Key_DOWN(on_button: integer): integer;
  begin
    buttons[on_button].background := 0;
    buttons[on_button].Create();
    if on_button = countButtons then
      on_button := 1
    else
      on_button := on_button + 1;
    Key_DOWN := on_button;
  end;

  procedure Menu.press_enter(on_button: integer);
  var
    base1: ViewTable;
    i: integer;
  begin
    Window(1, 1, x_border, y_border);
    TextBackground(0);
    del;
    ClrScr;

    base1 := base1.Init();
    for i := 1 to countButtons do
      if whereY = buttons[i].y_pos then
        case i of
        1:
          base1.show;
        {2:
          ;
        3:
          ;}
        end;
  end;

  procedure Menu.Main;
  var
    run: boolean;
    on_button: integer;
  begin
    Show_menu();

    run := true;
    on_button := 1;
    window(x, y, x_border, y_border);
    gotoxy(buttons[on_button].x_pos, buttons[on_button].y_pos);
    while run do
    begin
      case readkey of
      #72:
        begin
          on_button := Key_UP(on_button);
        end;
      #80:
        begin
          on_button := Key_DOWN(on_button);
        end;
      #13:
        begin
          press_enter(on_button);
          run := false;
        end;
      end;
      if run then
      begin
        buttons[on_button].background := 2;
        gotoxy(buttons[on_button].x_pos, buttons[on_button].y_pos);
        ClrEol;
        buttons[on_button].Create();
      end;
    end;
  end;

  {procedure Menu.paint_background();
  var
    i: integer;
  begin
    TextBackground(background);

    for i := 1 to y_border do
    begin
      gotoxy(1, i);
      write('1');
    end;
  end;  }

  destructor Menu.Del;
  var
    i: integer;
  begin
    for i := 1 to countButtons do
      buttons[i].del;
  end;
end.

