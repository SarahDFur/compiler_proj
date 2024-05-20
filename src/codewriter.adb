with Ada.Text_IO;
use Ada.Text_IO;

package body CodeWriter is
   --  file: File_Type;
   file_name : String := "";
   
   procedure init_f (n : String)is
   begin
      --  file := f;
      file_name := n;
   end init_f;
   
   procedure write_add is   
   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");
      Put_Line(File => file, Item => "//ADD"); 
      Put_Line(File => file, Item => "@SP"); 
      Put_Line(File => file, Item => " A=M-1"); 
      Put_Line(File => file, Item => "D=M"); 
      Put_Line(File => file, Item => "A=A-1"); 
      Put_Line(File => file, Item => "M=D+M"); 
      Put_Line(File => file, Item => "@SP"); 
      Put_Line(File => file, Item => "M=M-1"); 
      --  Close(file);

   end write_add;
   
   procedure write_sub  is
   begin

        --  Open(File => file, Mode => Out_File, Name => "out_f.asm");
        Put_Line(File => file, Item => "//SUB"); 
        Put_Line(File => file, Item => "@SP"); 
        Put_Line(File => file, Item => " A=M-1"); 
        Put_Line(File => file, Item => "D=M"); 
        Put_Line(File => file, Item => "A=A-1"); 
        Put_Line(File => file, Item => "M=D-M"); 
        Put_Line(File => file, Item => "@SP"); 
        Put_Line(File => file, Item => "M=M-1"); 
        
        --  Close(file);
       
   end write_sub;
   
   procedure write_neg is
   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");
      Put_Line(File => file, Item => "@SP"); 
      Put_Line(File => file, Item => " A=M-1"); 
      Put_Line(File => file, Item => " M=M-1"); 
      --  Close(file);

   end write_neg;
   
   procedure write_and is
   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");
      
      Put_Line(File => file, Item => "//AND"); 
      Put_Line(File => file, Item => "@SP"); 
      Put_Line(File => file, Item => "A=M-1"); 
      Put_Line(File => file, Item => " D=M"); 
      Put_Line(File => file, Item => "A=A-1"); 
      Put_Line(File => file, Item => "M=D&M"); 
      Put_Line(File => file, Item => "@SP"); 
      Put_Line(File => file, Item => "M=M-1");
     
      --  Close(file);
   end write_and;

   procedure write_or is
   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");
      Put_Line(File => file, Item => "//OR"); 
      Put_Line(File => file, Item => "@SP"); 
      Put_Line(File => file, Item => "A=M-1"); 
      Put_Line(File => file, Item => " D=M"); 
      Put_Line(File => file, Item => "A=A-1"); 
       Put_Line(File => file, Item => "M=D|M"); 
       Put_Line(File => file, Item => "@SP"); 
       Put_Line(File => file, Item => "M=M-1");
      
      --  Close(file);
   end write_or;
   
   procedure write_not is
   begin
      
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");
      Put_Line(File => file, Item => "//NOT"); 
      Put_Line(File => file, Item => "@SP"); 
      Put_Line(File => file, Item => "A=M-1"); 
      Put_Line(File => file, Item => " D=!M"); 
       Put_Line(File => file, Item => "@SP"); 
       Put_Line(File => file, Item => "M=M-1");
      
      --  Close(file);
   end write_not;

   procedure write_eq is
   begin
      
   end write_eq;
   
      -- PUSH WRITE FUNCTIONS: --
   procedure push_local (argument: Integer) is
   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");
      Put_Line(File => file, Item => "//PUSH LCL"); 
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

      --  Close(file);
   end push_local;
   
   procedure push_argument (argument: Integer) is
   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");
      
      Put_Line(File => file, Item => "//PUSH ARG"); 
      Put_Line(File => file, Item => "@ARG");               -- A = argument segment
      Put_Line(File => file, Item => "D = A");                 -- D = A = argument
                                                               
      Put_Line(File => file, Item => "@" & argument'Image);
      Put_Line(File => file, Item => "D = D + A");
      Put_Line(File => file, Item => "A = D");

      Put_Line(File => file, Item => "@SP");                    -- A = SP = 0
      Put_Line(File => file, Item => "M = D");                -- M = RAM[A] = RAM[top of stack] = D = argument
      
      Put_Line(File => file, Item => "@SP");                   -- A = 0
      Put_Line(File => file, Item => "M = M + 1");        --  RAM[A] = RAM[A] + 1 = next free place

      --  Close(file);
   end push_argument;

   procedure push_this (argument: Integer) is
   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");
      
      Put_Line(File => file, Item => "//PUSH THIS"); 
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

      --  Close(file);
   end push_this;
   
   procedure push_that (argument: Integer) is
   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");
      
      Put_Line(File => file, Item => "//PUSH THAT"); 
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

      --  Close(file);
   end push_that;

   procedure push_temp (argument: Integer) is
   begin 
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");
      
      Put_Line(File => file, Item => "//PUSH TEMP"); 
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
      --  Close(file);
   end push_temp;

   procedure push_static (argument: Integer) is
   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");
      
      Put_Line(File => file, Item => "//PUSH STATIC"); 
      Put_Line(File => file, Item => "@" & file_name & '.' & argument'Image); -- A = argument
      Put_Line(File => file, Item => "D = M");                 -- D = A = argument

      Put_Line(File => file, Item => "@SP");                    -- A = SP = 0
      Put_Line(File => file, Item => "A = M");                -- A = RAM[A] = top of stack
      Put_Line(File => file, Item => "M = D");                -- M = RAM[A] = RAM[top of stack] = D = argument
      
      Put_Line(File => file, Item => "@SP");                   -- A = 0
      Put_Line(File => file, Item => "M = M + 1");        --  RAM[A] = RAM[A] + 1 = next free place
      --  Close(file);
   end push_static;

   procedure push_ptr (argument: Integer) is 
   begin 
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");
      
      case argument is
      when 0 =>
         Put_Line(File => file, Item => "//PUSH PTR 0");  
         Put_Line(File => file, Item => "@THIS"); 
      when 1 =>
         Put_Line(File => file, Item => "//PUSH PTR 1");
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

      --  Close(file);
   end push_ptr;
   
   procedure push_const (argument: Integer) is
   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");

      Put_Line(File => file, Item => "//PUSH CONST"); 
      Put_Line(File => file, Item => "@" & argument'Image); -- A = argument
      Put_Line(File => file, Item => "D = A");                 -- D = A = argument

      Put_Line(File => file, Item => "@SP");                    -- A = SP = 0
      Put_Line(File => file, Item => "A = M");                -- A = RAM[A] = top of stack
      Put_Line(File => file, Item => "M = D");                -- M = RAM[A] = RAM[
      
      Put_Line(File => file, Item => "@SP");                   -- A = 0
      Put_Line(File => file, Item => "M = M + 1");        --  RAM[A] = RAM[A] + 1 = next free place
      --  Close(file);
   end push_const;
   
   -- POP WRITE FUNCTIONS: --
   procedure pop_local (argument: Integer) is 
   begin 
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");
      
      Put_Line(File => file, Item => "//POP LCL"); 
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
     
      --  Close(file);
   end pop_local;
               
-- TODO: change loops that calculate A + x => add(A, x) ?
   procedure pop_argument (argument: Integer) is 
   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");

      Put_Line(File => file, Item => "//POP ARG");
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
     
      --  Close(file);
   end pop_argument;

   procedure pop_this (argument: Integer) is
   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");
 
      Put_Line(File => file, Item => "//POP THIS");
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
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");
 
      Put_Line(File => file, Item => "//POP THAT");
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
     
      --  Close(file);
   end pop_that;

   procedure pop_temp (argument: Integer) is
   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");

      Put_Line(File => file, Item => "//POP TEMP");
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
     
      --  Close(file);
   end pop_temp;

   procedure pop_static (argument: Integer) is -- file_name = "name" from "name.vm"
      str_class_name : String :=  file_name & '.' & argument'Image; 
      -- RANGE OF STATIC BLOCK: [16 - 255]
      -- can also calculate the offset with a loop incrementing 'argument' times the value 16
   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");
 
      Put_Line(File => file, Item => "//POP STATIC");
      Put_Line(File => file, Item => "@SP");
      Put_Line(File => file, Item => "A = M - 1"); 
      Put_Line(File => file, Item => "D = M");

      Put_Line(File => file, Item => "@" & str_class_name);
      Put_Line(File => file, Item => "M = D");
      
      Put_Line(File => file, Item => "@SP");
      Put_Line(File => file, Item => "M = M - 1");
      --  Close(file);
   end pop_static;

   procedure pop_ptr (argument: Integer) is
   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");
      case argument is
         when 0 =>
            Put_Line(File => file, Item => "//POP PTR 0");
         when 1 =>
            Put_Line(File => file, Item => "//POP PTR 1");
      end case;
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
 
      --  Close(file);
   end pop_ptr;

end CodeWriter;
