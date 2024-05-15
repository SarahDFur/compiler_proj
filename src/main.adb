with Ada.Text_IO; use Ada.Text_IO;
with arith_logic; use arith_logic;

procedure Main is
   file: File_Type;
begin
   Ada.Text_IO.Create(File => file, Mode => Ada.Text_IO.Out_File,
                         Name => "C:\Users\daaty\Desktop\school\semester b\fundamentals\compiler_proj\\out_f.asm");

   --  Insert code here.
   null;
end Main;
