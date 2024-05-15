with Ada.Text_IO; use Ada.Text_IO;

package body arith_logic is
   file: File_Type;
   procedure write_add (arg1: String, arg2: String) is
--  // vm command: add
--  @SP		// A = 0
--  A=M-1	//A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=257
--  D=M		//D = RAM[A] = RAM[257] = 5
--  		       //D saves the second item in the stack
--  A=A-1	//A = 257-1 = 256
--  M=D+M	//RAM[A] = D+RAM[A] => RAM[256] = 8+RAM[256] = 5+4 = 9
--  		//save the add result in the place of the first item on the stack
--  		//this is equal to:  pop second item, pop first item,  //push the result of their addition to the stack.
--  @SP	//after pushing the result to the stack,
--  		// we want to decrement the stack pointer.
--  		//current command is: A=0
--  M=M-1
   begin
      Open(File => file, Mode => Out_File, Name => "out_f.asm");
      Put_Line(File => file, Item => "@SP"); 
      Close(file);
   end write_add;

end arith_logic;
