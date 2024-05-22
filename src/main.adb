with Ada.Text_IO; use Ada.Text_IO;
with Parser; use Parser;
with Ada.DIrectories; use Ada.Directories;

procedure Main is
   file: File_Type;

begin
   Ada.Text_IO.Create(File => file, Mode => Ada.Text_IO.Out_File,
                      Name => Current_Directory & "\out_f.asm");
   Close(file);
   Parser.init_parser("out_f.asm");
   null;
end Main;
