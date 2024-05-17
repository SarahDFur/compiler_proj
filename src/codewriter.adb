with Ada.Text_IO;
use Ada.Text_IO;

package body CodeWriter is
   file: File_Type;
   file_name : String := "";
   
   procedure init_f (f: File_Type; n : String)is
   begin
      file := f;
      file_name := n;
   end init_f;
   
--     procedure write_add (arg1: String, arg2: String) is
--  --  // vm command: add
--  --  @SP		// A = 0
--  --  A=M-1	//A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=257
--  --  D=M		//D = RAM[A] = RAM[257] = 5
--  --  		       //D saves the second item in the stack
--  --  A=A-1	//A = 257-1 = 256
--  --  M=D+M	//RAM[A] = D+RAM[A] => RAM[256] = 8+RAM[256] = 5+4 = 9
--  --  		//save the add result in the place of the first item on the stack
--  --  		//this is equal to:  pop second item, pop first item,  //push the result of their addition to the stack.
--  --  @SP	//after pushing the result to the stack,
--  --  		// we want to decrement the stack pointer.
--  --  		//current command is: A=0
--  --  M=M-1
--     begin
--        Open(File => file, Mode => Out_File, Name => "out_f.asm");
--        Put_Line(File => file, Item => "@SP");
--        Close(file);
--     end write_add;

      -- PUSH WRITE FUNCTIONS: --
   procedure push_local (argument: Integer) is
   begin
      Open(File => file, Mode => Out_File, Name => "out_f.asm");
      
      Put_Line(File => file, Item => "@" & argument'Image); -- A = argument
      Put_Line(File => file, Item => "D = A");                 -- D = A = argument
                                                               
      Put_Line(File => file, Item => "@LCL");
      Put_Line(File => file, Item => "A = M + D");
      Put_Line(File => file, Item => "D = M");

      Put_Line(File => file, Item => "@SP");                    -- A = SP = 0
      Put_Line(File => file, Item => "A = M");                -- A = RAM[A] = top of stack
      Put_Line(File => file, Item => "M = D");                -- M = RAM[A] = RAM[top of stack] = D = argument
      
      Put_Line(File => file, Item => "@SP");                   -- A = 0
      Put_Line(File => file, Item => "M = M + 1");        --  RAM[A] = RAM[A] + 1 = next free place

      Close(file);     
   end push_local;
   
   procedure push_argument (argument: Integer) is
   begin
      Open(File => file, Mode => Out_File, Name => "out_f.asm");
      
      Put_Line(File => file, Item => "@ARG");               -- A = argument segment
      Put_Line(File => file, Item => "D = A");                 -- D = A = argument
                                                               
      Put_Line(File => file, Item => "@" & argument'Image);
      Put_Line(File => file, Item => "D = D + A");
      Put_Line(File => file, Item => "A = D");

      Put_Line(File => file, Item => "@SP");                    -- A = SP = 0
      Put_Line(File => file, Item => "M = D");                -- M = RAM[A] = RAM[top of stack] = D = argument
      
      Put_Line(File => file, Item => "@SP");                   -- A = 0
      Put_Line(File => file, Item => "M = M + 1");        --  RAM[A] = RAM[A] + 1 = next free place

      Close(file);   
   end push_argument;

   procedure push_this (argument: Integer) is
   begin
      Open(File => file, Mode => Out_File, Name => "out_f.asm");
      
      Put_Line(File => file, Item => "@" & argument'Image);
      Put_Line(File => file, Item => "D = A");       
                                                               
      Put_Line(File => file, Item => "@THIS");
      Put_Line(File => file, Item => "A = M + D");
      Put_Line(File => file, Item => "D = M");

      Put_Line(File => file, Item => "@SP");                    -- A = SP = 0
      Put_Line(File => file, Item => "A = M");               
      Put_Line(File => file, Item => "M = D");

      Put_Line(File => file, Item => "@SP");                   -- A = 0
      Put_Line(File => file, Item => "M = M + 1");        --  RAM[A] = RAM[A] + 1 = next free place

      Close(file);    
   end push_this;
   
   procedure push_that (argument: Integer) is
   begin
      Open(File => file, Mode => Out_File, Name => "out_f.asm");
      
      Put_Line(File => file, Item => "@" & argument'Image);
      Put_Line(File => file, Item => "D = A");       
                                                               
      Put_Line(File => file, Item => "@THAT");
      Put_Line(File => file, Item => "A = M + D");
      Put_Line(File => file, Item => "D = M");

      Put_Line(File => file, Item => "@SP");                    -- A = SP = 0
      Put_Line(File => file, Item => "A = M");               
      Put_Line(File => file, Item => "M = D");

      Put_Line(File => file, Item => "@SP");                   -- A = 0
      Put_Line(File => file, Item => "M = M + 1");        --  RAM[A] = RAM[A] + 1 = next free place

      Close(file);   
   end push_that;

   procedure push_temp (argument: Integer) is
   begin 
      Open(File => file, Mode => Out_File, Name => "out_f.asm");
      
      Put_Line(File => file, Item => "@TEMP");
      Put_Line(File => file, Item => "D = A");
      Put_Line(File => file, Item => "@" & argument'Image);
      Put_Line(File => file, Item => "A = A + D");
      Put_Line(File => file, Item => "D = M");                

      Put_Line(File => file, Item => "@SP");                    -- A = SP = 0
      Put_Line(File => file, Item => "A = M");                -- A = RAM[A] = top of stack
      Put_Line(File => file, Item => "M = D");                -- M = RAM[A] = RAM[top of stack] = D = argument
      
      Put_Line(File => file, Item => "@SP");                   -- A = 0
      Put_Line(File => file, Item => "M = M + 1");        --  RAM[A] = RAM[A] + 1 = next free place
      Close(file);
   end push_temp;

   procedure push_static (argument: Integer) is
   begin
      Open(File => file, Mode => Out_File, Name => "out_f.asm");
      
      Put_Line(File => file, Item => "@" & file_name & '.' & argument'Image); -- A = argument
      Put_Line(File => file, Item => "D = M");                 -- D = A = argument

      Put_Line(File => file, Item => "@SP");                    -- A = SP = 0
      Put_Line(File => file, Item => "A = M");                -- A = RAM[A] = top of stack
      Put_Line(File => file, Item => "M = D");                -- M = RAM[A] = RAM[top of stack] = D = argument
      
      Put_Line(File => file, Item => "@SP");                   -- A = 0
      Put_Line(File => file, Item => "M = M + 1");        --  RAM[A] = RAM[A] + 1 = next free place
      Close(file);   
   end push_static;

   procedure push_ptr (argument: Integer) is 
   begin 
      Open(File => file, Mode => Out_File, Name => "out_f.asm");
      
      case argument is
      when 0 =>
         Put_Line(File => file, Item => "@THIS"); 
      when 1 =>
         Put_Line(File => file, Item => "@THAT");
      when others =>
         null;
      end case;
     
      Put_Line(File => file, Item => "D = M");                

      Put_Line(File => file, Item => "@SP");                   
      Put_Line(File => file, Item => "A = M");               
      Put_Line(File => file, Item => "M = D");                
      
      Put_Line(File => file, Item => "@SP");                   -- A = 0
      Put_Line(File => file, Item => "M = M + 1");        --  RAM[A] = RAM[A] + 1 = next free place

      Close(file);                 
   end push_ptr;
   
   procedure push_const (argument: Integer) is
   begin
      Open(File => file, Mode => Out_File, Name => "out_f.asm");
      
      Put_Line(File => file, Item => "@" & argument'Image); -- A = argument
      Put_Line(File => file, Item => "D = A");                 -- D = A = argument

      Put_Line(File => file, Item => "@SP");                    -- A = SP = 0
      Put_Line(File => file, Item => "A = M");                -- A = RAM[A] = top of stack
      Put_Line(File => file, Item => "M = D");                -- M = RAM[A] = RAM[
      
      Put_Line(File => file, Item => "@SP");                   -- A = 0
      Put_Line(File => file, Item => "M = M + 1");        --  RAM[A] = RAM[A] + 1 = next free place
      Close(file);
   end push_const;
   
   -- POP WRITE FUNCTIONS: --
   procedure pop_local (argument: Integer) is 
   begin 
      Open(File => file, Mode => Out_File, Name => "out_f.asm");
      
      Put_Line(File => file, Item => "@SP");                    -- A = SP = 0
      Put_Line(File => file, Item => "A = M - 1");           -- A = RAM[0] - 1
      Put_Line(File => file, Item => "D = M");                --  D = RAM[A] = VALUE OF *SP - 1
       
      Put_Line(File => file, Item => "@LCL");                 -- A = LCL = 1 // usually
      Put_Line(File => file, Item => "A = M");                -- A = RAM[LCL] = value of first (segment start addr)
      declare 
         i : Integer := argument;
         begin
            while i /= 0 loop
               Put_Line(File => file, Item => "A = A + 1"); -- A = A + argument = offset of LCL segment (from start)
               i := i - 1;
            end loop;                 
         end;
      Put_Line(File => file, Item => "M = D");                -- RAM[ RAM[LCL] + argument ] = the value in LCL + offset 
      
      Put_Line(File => file, Item => "@SP");                   -- A = SP = 0
      Put_Line(File => file, Item => "M = M - 1");          -- RAM[0] = RAM[0] - 1 = next available place in memory
     
      Close(file);
   end pop_local;
               
-- TODO: change loops that calculate A + x => add(A, x) ?
   procedure pop_argument (argument: Integer) is 
   begin
      Open(File => file, Mode => Out_File, Name => "out_f.asm");
 
      Put_Line(File => file, Item => "@SP");                    -- A = SP = 0
      Put_Line(File => file, Item => "A = M - 1");           -- A = RAM[0] - 1
      Put_Line(File => file, Item => "D = M");                --  D = RAM[A] = VALUE OF *SP - 1
            
      Put_Line(File => file, Item => "@ARG");                 -- A = ARG = 2 // usually
      Put_Line(File => file, Item => "A = M");                -- A = RAM[ARG] = value of first (segment start addr)
      declare -- iterate argument no. of times to get to the correct address
         i : Integer := argument;
         begin
            while i /= 0 loop
               Put_Line(File => file, Item => "A = A + 1"); -- A = A + argument = offset of ARG segment (from start)
               i := i - 1;
            end loop;                 
         end;
      Put_Line(File => file, Item => "M = D");                -- RAM[ RAM[ARG] + argument ] = the value in ARG + offset 
      
      Put_Line(File => file, Item => "@SP");                   -- A = SP = 0
      Put_Line(File => file, Item => "M = M - 1");          -- RAM[0] = RAM[0] - 1 = next available place in memory
     
      Close(file);         
   end pop_argument;

   procedure pop_this (argument: Integer) is
   begin
      Open(File => file, Mode => Out_File, Name => "out_f.asm");
 
      Put_Line(File => file, Item => "@SP");                    -- A = SP = 0
      Put_Line(File => file, Item => "A = M - 1");           -- A = RAM[0] - 1
      Put_Line(File => file, Item => "D = M");                --  D = RAM[A] = VALUE OF *SP - 1
            
      Put_Line(File => file, Item => "@THIS");                 -- A = THIS = 3 // usually
      Put_Line(File => file, Item => "A = M");                -- A = RAM[THIS] = value of first (segment start addr)
      declare -- iterate argument no. of times to get to the correct address
         i : Integer := argument;
         begin
            while i /= 0 loop
               Put_Line(File => file, Item => "A = A + 1"); -- A = A + argument = offset of THIS segment (from start)
               i := i - 1;
            end loop;                 
         end;
      Put_Line(File => file, Item => "M = D");                -- RAM[ RAM[THIS] + argument ] = the value in THIS + offset 
      
      Put_Line(File => file, Item => "@SP");                   -- A = SP = 0
      Put_Line(File => file, Item => "M = M - 1");          -- RAM[0] = RAM[0] - 1 = next available place in memory
     
      Close(file);         
   end pop_this;

   procedure pop_that (argument: Integer) is
   begin 
      Open(File => file, Mode => Out_File, Name => "out_f.asm");
 
      Put_Line(File => file, Item => "@SP");                    -- A = SP = 0
      Put_Line(File => file, Item => "A = M - 1");           -- A = RAM[0] - 1
      Put_Line(File => file, Item => "D = M");                --  D = RAM[A] = VALUE OF *SP - 1
            
      Put_Line(File => file, Item => "@THAT");                 -- A = THAT = 4 // usually
      Put_Line(File => file, Item => "A = M");                -- A = RAM[THAT] = value of first (segment start addr)
      declare -- iterate argument no. of times to get to the correct address
         i : Integer := argument;
         begin
            while i /= 0 loop
               Put_Line(File => file, Item => "A = A + 1"); -- A = A + argument = offset of THAT segment (from start)
               i := i - 1;
            end loop;                 
         end;
      Put_Line(File => file, Item => "M = D");                -- RAM[ RAM[THAT] + argument ] = the value in THAT + offset 
      
      Put_Line(File => file, Item => "@SP");                   -- A = SP = 0
      Put_Line(File => file, Item => "M = M - 1");          -- RAM[0] = RAM[0] - 1 = next available place in memory
     
      Close(file);         
   end pop_that;

   procedure pop_temp (argument: Integer) is
   begin
      Open(File => file, Mode => Out_File, Name => "out_f.asm");

      Put_Line(File => file, Item => "@SP");                    -- A = SP = 0
      Put_Line(File => file, Item => "A = M - 1");           -- A = RAM[0] - 1
      Put_Line(File => file, Item => "D = M");                --  D = RAM[A] = VALUE OF *SP - 1 = value at top of stack
      declare 
         val : Integer := 5 + argument;
      begin      
         Put_Line(File => file, Item => "@" & val'Image);               
      end;
      Put_Line(File => file, Item => "M = D");                -- RAM[ RAM[TEMP] + argument ] = the value in TEMP + offset 
      
      Put_Line(File => file, Item => "@SP");                   -- A = SP = 0
      Put_Line(File => file, Item => "M = M - 1");          -- RAM[0] = RAM[0] - 1 = next available place in memory
     
      Close(file);         
   end pop_temp;

   procedure pop_static (argument: Integer) is -- file_name = "name" from "name.vm"
      str_class_name : String :=  file_name & '.' & argument'Image; 
      -- RANGE OF STATIC BLOCK: [16 - 255]
      -- can also calculate the offset with a loop incrementing 'argument' times the value 16
   begin
      Open(File => file, Mode => Out_File, Name => "out_f.asm");
 
      Put_Line(File => file, Item => "@SP");
      Put_Line(File => file, Item => "A = M - 1"); 
      Put_Line(File => file, Item => "D = M");

      Put_Line(File => file, Item => "@" & str_class_name);
      Put_Line(File => file, Item => "M = D");
      
      Put_Line(File => file, Item => "@SP");
      Put_Line(File => file, Item => "M = M - 1");
      Close(file);         
   end pop_static;

   procedure pop_ptr (argument: Integer) is
   begin
      Open(File => file, Mode => Out_File, Name => "out_f.asm");
      
      Put_Line(File => file, Item => "@SP");                    -- A = SP = 0
      Put_Line(File => file, Item => "A = M - 1");           -- A = RAM[0] - 1
      Put_Line(File => file, Item => "D = M");                --  D = RAM[A] = VALUE OF *SP - 1
      case argument is
           when 0 =>
               Put_Line(File => file, Item => "@THIS");        -- A = SP = 0
         when 1 =>
               Put_Line(File => file, Item => "@THAT");      -- A = SP = 0
         when others =>
            null;
      end case;               
      Put_Line(File => file, Item => "A = D");        -- A = RAM[0] - 1

      Put_Line(File => file, Item => "@SP");                   -- A = SP = 0
      Put_Line(File => file, Item => "M = M - 1");          -- RAM[0] = RAM[0] - 1 = next available place in memory
 
      Close(file);         
   end pop_ptr;

end CodeWriter;
