with Ada.Strings; use Ada.Strings;
with Ada.Text_IO; use Ada.Text_IO;
with Utils; use Utils;
with Ada.Characters.Conversions; use Ada.Characters.Conversions;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Parser; use Parser;

package body CodeWriter is

   file_name : Unbounded_String;
   name      : String := "";
   --  file : File_Type;  -- current input file
   --  File_Name : constant String := "out_f.asm";
   EQ_Counter       : Integer := 0;
   EQ_Counter_false : Integer := 0;
   --  Output_Line : String := "@EQ_" & To_String(file_name) & "_" & Integer'Image (EQ_Counter);
   --  Output_Line_false : String := "@UPDATE_SP_" & To_String(file_name) & "_" & Integer'Image (EQ_Counter_false);
   Output_Line       : Unbounded_String;
   Output_Line_false : Unbounded_String;

   procedure init_f (n : Unbounded_String) is
   begin
      --  file := f;
      file_name := n;
      --  Put_Line(File => Parser.o_file, item => To_String(file_name));
      null;
      --  name := To_String(file_name)(1.. Utils.find_char_index(To_String(file_name), '.') - 1);
   end init_f;

   procedure write_add is
   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");
      Put_Line (File => Parser.o_file, Item => "//ADD");
      Put_Line (File => Parser.o_file, Item => "@SP");
      Put_Line (File => Parser.o_file, Item => "A=M-1");
      Put_Line (File => Parser.o_file, Item => "D=M");
      Put_Line (File => Parser.o_file, Item => "A=A-1");
      Put_Line (File => Parser.o_file, Item => "M=D+M");
      Put_Line (File => Parser.o_file, Item => "@SP");
      Put_Line (File => Parser.o_file, Item => "M=M-1");
      --  Close(file);

   end write_add;

   procedure write_sub is
   begin

      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");
      Put_Line (File => Parser.o_file, Item => "//SUB");
      Put_Line (File => Parser.o_file, Item => "@SP");
      Put_Line (File => Parser.o_file, Item => " A=M-1");
      Put_Line (File => Parser.o_file, Item => "D=M");
      Put_Line (File => Parser.o_file, Item => "A=A-1");
      Put_Line (File => Parser.o_file, Item => "M=M-D");
      Put_Line (File => Parser.o_file, Item => "@SP");
      Put_Line (File => Parser.o_file, Item => "M=M-1");

      --  Close(file);

   end write_sub;

   procedure write_neg is
   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");
      Put_Line (File => Parser.o_file, Item => "@SP");
      Put_Line (File => Parser.o_file, Item => "A=M-1");
      Put_Line (File => Parser.o_file, Item => "M=-M");
      --  Close(file);

   end write_neg;

   procedure write_and is
   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");

      Put_Line (File => Parser.o_file, Item => "//AND");
      Put_Line (File => Parser.o_file, Item => "@SP");
      Put_Line (File => Parser.o_file, Item => "A=M-1");
      Put_Line (File => Parser.o_file, Item => " D=M");
      Put_Line (File => Parser.o_file, Item => "A=A-1");
      Put_Line (File => Parser.o_file, Item => "M=M&D");
      Put_Line (File => Parser.o_file, Item => "@SP");
      Put_Line (File => Parser.o_file, Item => "M=M-1");

      --  Close(file);
   end write_and;

   procedure write_or is
   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");
      Put_Line (File => Parser.o_file, Item => "//OR");
      Put_Line (File => Parser.o_file, Item => "@SP");
      Put_Line (File => Parser.o_file, Item => "A=M-1");
      Put_Line (File => Parser.o_file, Item => " D=M");
      Put_Line (File => Parser.o_file, Item => "A=A-1");
      Put_Line (File => Parser.o_file, Item => "M=M|D");
      Put_Line (File => Parser.o_file, Item => "@SP");
      Put_Line (File => Parser.o_file, Item => "M=M-1");

      --  Close(file);
   end write_or;

   procedure write_not is
   begin

      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");
      Put_Line (File => Parser.o_file, Item => "//NOT");
      Put_Line (File => Parser.o_file, Item => "@SP");
      Put_Line (File => Parser.o_file, Item => "A=M-1");
      Put_Line (File => Parser.o_file, Item => " M=!M");

      --  Close(file);
   end write_not;

   procedure write_eq is
   begin
      Output_Line :=
        To_Unbounded_String
          ("IF_TRUE" & To_String (file_name) &
           Integer'Image (EQ_Counter) (2 .. EQ_Counter'Image'Length));
      Output_Line_false :=
        To_Unbounded_String
          ("IF_FALSE" & To_String (file_name) &
           Integer'Image (EQ_Counter_false)
             (2 .. EQ_Counter_false'Image'Length));
      -- Open(File => file, Mode => Out_File, Name => "out_f.asm");
      Put_Line (File => Parser.o_file, Item => "//EQ");
      Put_Line (File => Parser.o_file, Item => "@SP");
      Put_Line (File => Parser.o_file, Item => "A=M-1");
      Put_Line (File => Parser.o_file, Item => "D=M");
      Put_Line (File => Parser.o_file, Item => "A=A-1");
      Put_Line (File => Parser.o_file, Item => "D=M-D");
      Put_Line (File => Parser.o_file, Item => "@" & To_String (Output_Line));
      Put_Line (File => Parser.o_file, Item => "D;JEQ"); -- if D=0
      Put_Line (File => Parser.o_file, Item => "D=0");
      Put_Line (File => Parser.o_file, Item => "@SP");
      Put_Line (File => Parser.o_file, Item => "A=M-1");
      Put_Line (File => Parser.o_file, Item => "A=A-1");
      Put_Line (File => Parser.o_file, Item => "M=D");
      Put_Line
        (File => Parser.o_file, Item => "@" & To_String (Output_Line_false));
      Put_Line (File => Parser.o_file, Item => "0;JMP");
      Put_Line
        (File => Parser.o_file, Item => "(" & To_String (Output_Line) & ")");
      Put_Line (File => Parser.o_file, Item => "D=-1");

      Put_Line (File => Parser.o_file, Item => "@SP");
      Put_Line (File => Parser.o_file, Item => "A=M-1");
      Put_Line (File => Parser.o_file, Item => "A=A-1");
      Put_Line (File => Parser.o_file, Item => "M=D");
      Put_Line
        (File => Parser.o_file,
         Item => "(" & To_String (Output_Line_false) & ")");

      Put_Line (File => Parser.o_file, Item => "@SP");
      Put_Line (File => Parser.o_file, Item => "M=M-1");
      EQ_Counter       := EQ_Counter + 1;
      EQ_Counter_false := EQ_Counter_false + 1;

      -- Close the file
      --  Close(file);

   end write_eq;

   procedure write_gt is
   begin
      Output_Line :=
        To_Unbounded_String
          ("IF_TRUE" & To_String (file_name) &
           Integer'Image (EQ_Counter) (2 .. EQ_Counter'Image'Length));
      Output_Line_false :=
        To_Unbounded_String
          ("IF_FALSE" & To_String (file_name) &
           Integer'Image (EQ_Counter_false)
             (2 .. EQ_Counter_false'Image'Length));
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");
      Put_Line (File => Parser.o_file, Item => "//GT");
      Put_Line (File => Parser.o_file, Item => "@SP");
      Put_Line (File => Parser.o_file, Item => "A=M-1");
      Put_Line (File => Parser.o_file, Item => "D=M");
      Put_Line (File => Parser.o_file, Item => "A=A-1");
      Put_Line (File => Parser.o_file, Item => "D=M-D");
      Put_Line (File => Parser.o_file, Item => "@" & To_String (Output_Line));
      Put_Line (File => Parser.o_file, Item => "D;JGT"); -- if D>0
      Put_Line (File => Parser.o_file, Item => "D=0");

      Put_Line (File => Parser.o_file, Item => "@SP");
      Put_Line (File => Parser.o_file, Item => "A=M-1");
      Put_Line (File => Parser.o_file, Item => "A=A-1");
      Put_Line (File => Parser.o_file, Item => "M=D");
      Put_Line
        (File => Parser.o_file, Item => "@" & To_String (Output_Line_false));
      Put_Line (File => Parser.o_file, Item => "0;JMP");
      Put_Line
        (File => Parser.o_file, Item => "(" & To_String (Output_Line) & ")");
      EQ_Counter := EQ_Counter + 1;
      Put_Line (File => Parser.o_file, Item => "D=-1");

      Put_Line (File => Parser.o_file, Item => "@SP");
      Put_Line (File => Parser.o_file, Item => "A=M-1");
      Put_Line (File => Parser.o_file, Item => "A=A-1");
      Put_Line (File => Parser.o_file, Item => "M=D");
      Put_Line
        (File => Parser.o_file,
         Item => "(" & To_String (Output_Line_false) & ")");

      EQ_Counter_false := EQ_Counter_false + 1;
      Put_Line (File => Parser.o_file, Item => "@SP");
      Put_Line (File => Parser.o_file, Item => "M=M-1");
      -- Close the file
      --  Close(file);

   end write_gt;

   procedure write_lt is
   begin
      Output_Line :=
        To_Unbounded_String
          ("IF_TRUE" & To_String (file_name) &
           Integer'Image (EQ_Counter) (2 .. EQ_Counter'Image'Length));
      Output_Line_false :=
        To_Unbounded_String
          ("IF_FALSE" & To_String (file_name) &
           Integer'Image (EQ_Counter_false)
             (2 .. EQ_Counter_false'Image'Length));
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");
      Put_Line (File => Parser.o_file, Item => "//LT");
      Put_Line (File => Parser.o_file, Item => "@SP");
      Put_Line (File => Parser.o_file, Item => "A=M-1");
      Put_Line (File => Parser.o_file, Item => "D=M");
      Put_Line (File => Parser.o_file, Item => "A=A-1");
      Put_Line (File => Parser.o_file, Item => "D=M-D");
      Put_Line (File => Parser.o_file, Item => "@" & To_String (Output_Line));
      Put_Line (File => Parser.o_file, Item => "D;JLT"); -- if D<0
      Put_Line (File => Parser.o_file, Item => "D=0");

      Put_Line (File => Parser.o_file, Item => "@SP");
      Put_Line (File => Parser.o_file, Item => "A=M-1");
      Put_Line (File => Parser.o_file, Item => "A=A-1");
      Put_Line (File => Parser.o_file, Item => "M=D");
      Put_Line
        (File => Parser.o_file, Item => "@" & To_String (Output_Line_false));
      Put_Line (File => Parser.o_file, Item => "0;JMP");
      Put_Line
        (File => Parser.o_file, Item => "(" & To_String (Output_Line) & ")");
      EQ_Counter := EQ_Counter + 1;
      Put_Line (File => Parser.o_file, Item => "D=-1");

      Put_Line (File => Parser.o_file, Item => "@SP");
      Put_Line (File => Parser.o_file, Item => "A=M-1");
      Put_Line (File => Parser.o_file, Item => "A=A-1");
      Put_Line (File => Parser.o_file, Item => "M=D");
      Put_Line
        (File => Parser.o_file,
         Item => "(" & To_String (Output_Line_false) & ")");

      EQ_Counter_false := EQ_Counter_false + 1;
      Put_Line (File => Parser.o_file, Item => "@SP");
      Put_Line (File => Parser.o_file, Item => "M=M-1");
      -- Close the file
      --  Close(file);

   end write_lt;

   procedure write_hash_lt is
   begin
      Output_Line :=
        To_Unbounded_String("IF_TRUE" & To_String (file_name) &
           Integer'Image (EQ_Counter) (2 .. EQ_Counter'Image'Length));
      Output_Line_false :=
        To_Unbounded_String("IF_FALSE" & To_String (file_name) &
           Integer'Image (EQ_Counter_false)(2 .. EQ_Counter_false'Image'Length));
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");
      Put_Line (File => Parser.o_file, Item => "//# LT");
      Put_Line (File => Parser.o_file, Item => "@SP");   -- load first argument (y)
      Put_Line (File => Parser.o_file, Item => "A=M-1"); -- a = ram[a] - 1
      Put_Line (File => Parser.o_file, Item => "D=M"); -- d = ram[a] => y
      Put_Line (File => Parser.o_file, Item => "A=A-1");  -- load second argument (x)
      Put_Line (File => Parser.o_file, Item => "D=M-D"); --  d = ram[a] - d = x - y < 0
      Put_Line (File => Parser.o_file, Item => "R5=M"); -- R5 = ram[a] = y
      Put_Line (File => Parser.o_file, Item => "@" & To_String (Output_Line));  -- x < y label
      Put_Line (File => Parser.o_file, Item => "D;JLT"); --
      --  Put_Line (File => Parser.o_file, Item => "D=0"); -- x > y
      Put_Line (File => Parser.o_file, Item => "D=M"); -- d = x

      Put_Line (File => Parser.o_file, Item => "@SP");
      Put_Line (File => Parser.o_file, Item => "A=M-1"); -- a = ram[a] - 1
      Put_Line (File => Parser.o_file, Item => "A=A-1"); -- a = a - 1
      Put_Line (File => Parser.o_file, Item => "M=D"); -- ram[a] = x - x at SP
      Put_Line (File => Parser.o_file, Item => "D=0");
      Put_Line
        (File => Parser.o_file, Item => "@" & To_String (Output_Line_false));
      Put_Line (File => Parser.o_file, Item => "0;JMP");
      Put_Line
        (File => Parser.o_file, Item => "(" & To_String (Output_Line) & ")");
      EQ_Counter := EQ_Counter + 1;
      Put_Line (File => Parser.o_file, Item => "D=-1"); -- return y

      Put_Line (File => Parser.o_file, Item => "@SP");
      Put_Line (File => Parser.o_file, Item => "A=M-1");
      Put_Line (File => Parser.o_file, Item => "A=A-1");
      Put_Line (File => Parser.o_file, Item => "M=R5");
      Put_Line
        (File => Parser.o_file,
         Item => "(" & To_String (Output_Line_false) & ")");

      EQ_Counter_false := EQ_Counter_false + 1;
      Put_Line (File => Parser.o_file, Item => "@SP");
      Put_Line (File => Parser.o_file, Item => "M=M-1");
   end write_hash_lt;

   -- PUSH WRITE FUNCTIONS: --
   procedure push_local (argument : Integer) is
   begin
      Put_Line (File => Parser.o_file, Item => "//PUSH LCL");
      Put_Line(File => Parser.o_file, Item => "@" & argument'Image (2 .. argument'Image'Length));
      Put_Line(File => Parser.o_file,Item => "D=A");                 -- D = A = argument

      Put_Line(File => Parser.o_file, Item => "@LCL");               -- A = argument segment
      --  Put_Line(File => Parser.o_file,Item => "D = A");                 -- D = A = argument

      Put_Line (File => Parser.o_file, Item => "A= M+D");
      Put_Line (File => Parser.o_file, Item => "D=M");

      Put_Line(File => Parser.o_file,Item => "@SP");                    -- A = SP = 0
      Put_Line (File => Parser.o_file, Item => "A=M");
      Put_Line (File => Parser.o_file, Item => "M= D");

      Put_Line(File => Parser.o_file, Item => "@SP");                   -- A = 0
      Put_Line(File => Parser.o_file, Item => "M = M + 1");         --  RAM[A] = RAM[A] + 1 = next free place

      --  Close(file);
   end push_local;

   procedure push_argument (argument : Integer) is
   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");

      Put_Line (File => Parser.o_file, Item => "//PUSH ARG");
      Put_Line(File => Parser.o_file,Item => "@" & argument'Image (2 .. argument'Image'Length));
      Put_Line(File => Parser.o_file,Item => "D = A");                 -- D = A = argument

      Put_Line(File => Parser.o_file, Item => "@ARG");    -- A = argument segment

      Put_Line (File => Parser.o_file, Item => "A = M + D");
      Put_Line (File => Parser.o_file, Item => "D = M");

      Put_Line(File => Parser.o_file,Item => "@SP");                    -- A = SP = 0
      Put_Line (File => Parser.o_file, Item => "A = M");
      Put_Line (File => Parser.o_file, Item => "M = D");

      Put_Line(File => Parser.o_file, Item => "@SP");                   -- A = 0
      Put_Line (File => Parser.o_file, Item => "M = M + 1");
      --  Close(file);
   end push_argument;

   procedure push_this (argument : Integer) is
   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");

      Put_Line (File => Parser.o_file, Item => "//PUSH THIS");
      Put_Line(File => Parser.o_file,Item => "@" & argument'Image (2 .. argument'Image'Length));
      Put_Line (File => Parser.o_file, Item => "D = A");

      Put_Line (File => Parser.o_file, Item => "@THIS");
      Put_Line (File => Parser.o_file, Item => "A = M + D");
      Put_Line (File => Parser.o_file, Item => "D = M");

      Put_Line(File => Parser.o_file, Item => "@SP");                    -- A = SP = 0
      Put_Line (File => Parser.o_file, Item => "A = M");
      Put_Line (File => Parser.o_file, Item => "M = D");

      Put_Line(File => Parser.o_file, Item => "@SP");                   -- A = 0
      Put_Line(File => Parser.o_file, Item => "M = M + 1");        --  RAM[A] = RAM[A] + 1 = next free place

      --  Close(file);
   end push_this;

   procedure push_that (argument : Integer) is
   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");

      Put_Line (File => Parser.o_file, Item => "//PUSH THAT");
      Put_Line(File => Parser.o_file, Item => "@" & argument'Image (2 .. argument'Image'Length));
      Put_Line (File => Parser.o_file, Item => "D = A");

      Put_Line (File => Parser.o_file, Item => "@THAT");
      Put_Line (File => Parser.o_file, Item => "A = M + D");
      Put_Line (File => Parser.o_file, Item => "D = M");

      Put_Line(File => Parser.o_file,Item => "@SP");                    -- A = SP = 0
      Put_Line (File => Parser.o_file, Item => "A = M");
      Put_Line (File => Parser.o_file, Item => "M = D");

      Put_Line(File => Parser.o_file, Item => "@SP");                   -- A = 0
      Put_Line(File => Parser.o_file, Item => "M = M + 1");        --  RAM[A] = RAM[A] + 1 = next free place

      --  Close(file);
   end push_that;

   procedure push_temp (argument : Integer) is
   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");

      Put_Line (File => Parser.o_file, Item => "//PUSH TEMP");
      Put_Line (File => Parser.o_file, Item => "@5");
      Put_Line (File => Parser.o_file, Item => "D = A");

      Put_Line(File => Parser.o_file, Item => "@" & argument'Image (2 .. argument'Image'Length));
      Put_Line (File => Parser.o_file, Item => "A = A + D");
      Put_Line (File => Parser.o_file, Item => "D = M");

      Put_Line(File => Parser.o_file,Item => "@SP");                    -- A = SP = 0
      Put_Line(File => Parser.o_file,Item => "A = M");                -- A = RAM[A] = top of stack
      Put_Line(File => Parser.o_file,Item => "M = D");                -- M = RAM[A] = RAM[top of stack] = D = argument

      Put_Line(File => Parser.o_file, Item => "@SP");                   -- A = 0
      Put_Line(File => Parser.o_file, Item => "M = M + 1");        --  RAM[A] = RAM[A] + 1 = next free place
      --  Close(file);
   end push_temp;

   procedure push_static (argument : Integer) is
   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");

      Put_Line (File => Parser.o_file, Item => "//PUSH STATIC");
      Put_Line(File => Parser.o_file, Item =>"@" & To_String (file_name) & '.' &
           argument'Image (2 .. argument'Image'Length)); -- A = argument
      Put_Line(File => Parser.o_file, Item => "D = M");                 -- D = A = argument

      Put_Line(File => Parser.o_file, Item => "@SP");                    -- A = SP = 0
      Put_Line(File => Parser.o_file, Item => "A = M");                -- A = RAM[A] = top of stack
      Put_Line(File => Parser.o_file,Item => "M = D");                -- M = RAM[A] = RAM[top of stack] = D = argument

      Put_Line(File => Parser.o_file, Item => "@SP");                   -- A = 0
      Put_Line(File => Parser.o_file, Item => "M = M + 1");        --  RAM[A] = RAM[A] + 1 = next free place
      --  Close(file);
   end push_static;

   procedure push_ptr (argument : Integer) is
   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");

      if argument = 0 then
         Put_Line (File => Parser.o_file, Item => "//PUSH PTR 0");
         Put_Line (File => Parser.o_file, Item => "@THIS");
      elsif argument = 1 then
         Put_Line (File => Parser.o_file, Item => "//PUSH PTR 1");
         Put_Line (File => Parser.o_file, Item => "@THAT");
         --  else
         --     null;  -- Handle the "others" case (optional)
      end if;

      Put_Line (File => Parser.o_file, Item => "D = M");

      Put_Line (File => Parser.o_file, Item => "@SP");
      Put_Line (File => Parser.o_file, Item => "A = M");
      Put_Line (File => Parser.o_file, Item => "M = D");

      Put_Line(File => Parser.o_file, Item => "@SP");                   -- A = 0
      Put_Line(File => Parser.o_file, Item => "M = M + 1");        --  RAM[A] = RAM[A] + 1 = next free place

      --  Close(file);
   end push_ptr;

   procedure push_const (argument : Integer) is
   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");

      Put_Line (File => Parser.o_file, Item => "//PUSH CONST");
      Put_Line(File => Parser.o_file, Item => "@" &
           argument'Image (2 .. argument'Image'Length)); -- A = argument
      Put_Line(File => Parser.o_file, Item => "D = A");                 -- D = A = argument

      Put_Line(File => Parser.o_file, Item => "@SP");                    -- A = SP = 0
      Put_Line(File => Parser.o_file, Item => "A = M");                -- A = RAM[A] = top of stack
      Put_Line(File => Parser.o_file, Item => "M = D");                -- M = RAM[A] = RAM[

      Put_Line(File => Parser.o_file, Item => "@SP");                   -- A = 0
      Put_Line(File => Parser.o_file, Item => "M = M + 1");        --  RAM[A] = RAM[A] + 1 = next free place
      --  Close(file);
   end push_const;

   procedure push_label(label: String) is
   begin
      Put_Line (File => Parser.o_file, Item => "//PUSH LABEL");
      Put_Line(File => Parser.o_file, Item =>"@" & label);
      Put_Line(File => Parser.o_file, Item =>"D=M");
      Put_Line(File => Parser.o_file, Item =>"@SP");
      Put_Line(File => Parser.o_file, Item =>"A=M");
      Put_Line(File => Parser.o_file, Item =>"M=D");
      Put_Line(File => Parser.o_file, Item =>"@SP");
      Put_Line(File => Parser.o_file, Item =>"M=M+1");
   end push_label;
   -- POP WRITE FUNCTIONS: --
   procedure pop_local (argument : Integer) is

   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");

      Put_Line (File => Parser.o_file, Item => "//POP LCL");
      Put_Line (File => Parser.o_file, Item => "@SP");                    -- A = SP = 0
      Put_Line(File => Parser.o_file, Item => "A = M - 1");           -- A = RAM[0] - 1
      Put_Line (File => Parser.o_file, Item => "D = M");                --  D = RAM[A] = VALUE OF *SP - 1

      Put_Line(File => Parser.o_file, Item => "@LCL");                 -- A = LCL = 1 // usually
      Put_Line(File => Parser.o_file, Item => "A = M");                -- A = RAM[LCL] = value of first (segment start addr)

      declare -- iterate argument no. of times to get to the correct address
         i : Integer := argument;
      begin
         while i >= 1 loop
            Put_Line(File => Parser.o_file, Item => "A = A + 1"); -- A = A + argument = offset of THAT segment (from start)
            i := i - 1;
         end loop;
      end;
      Put_Line(File => Parser.o_file, Item => "M = D");                -- RAM[ RAM[LCL] + argument ] = the value in LCL + offset

      Put_Line (File => Parser.o_file, Item => "@SP");                   -- A = SP = 0
      Put_Line(File => Parser.o_file, Item => "M = M - 1");          -- RAM[0] = RAM[0] - 1 = next available place in memory

      --  Close(file);
   end pop_local;

   procedure pop_argument (argument : Integer) is

   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");

      Put_Line (File => Parser.o_file, Item => "//POP ARG");
      Put_Line (File => Parser.o_file, Item => "@SP");                    -- A = SP = 0
      Put_Line(File => Parser.o_file, Item => "A = M - 1");           -- A = RAM[0] - 1
      Put_Line(File => Parser.o_file, Item => "D = M");                --  D = RAM[A] = VALUE OF *SP - 1

      Put_Line(File => Parser.o_file, Item => "@ARG");                 -- A = ARG = 2 // usually
      Put_Line(File => Parser.o_file, Item => "A = M");                -- A = RAM[ARG] = value of first (segment start addr)
      declare -- iterate argument no. of times to get to the correct address
         i : Integer := argument;
      begin
         while i >= 1 loop
            Put_Line(File => Parser.o_file, Item => "A = A + 1"); -- A = A + argument = offset of THAT segment (from start)
            i := i - 1;
         end loop;
      end;
      Put_Line(File => Parser.o_file, Item => "M = D");                -- RAM[ RAM[ARG] + argument ] = the value in ARG + offset

      Put_Line(File => Parser.o_file, Item => "@SP");                   -- A = SP = 0
      Put_Line(File => Parser.o_file, Item => "M = M - 1");          -- RAM[0] = RAM[0] - 1 = next available place in memory

      --  Close(file);
   end pop_argument;

   procedure pop_this (argument : Integer) is

   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");

      Put_Line (File => Parser.o_file, Item => "//POP THIS");
      Put_Line(File => Parser.o_file, Item => "@SP");                    -- A = SP = 0
      Put_Line(File => Parser.o_file, Item => "A = M - 1");           -- A = RAM[0] - 1
      Put_Line(File => Parser.o_file, Item => "D = M");                --  D = RAM[A] = VALUE OF *SP - 1

      Put_Line(File => Parser.o_file, Item => "@THIS");                 -- A = THIS = 3 // usually
      Put_Line(File => Parser.o_file, Item => "A = M");                -- A = RAM[THIS] = value of first (segment start addr)
      declare -- iterate argument no. of times to get to the correct address
         i : Integer := argument;
      begin
         while i >= 1 loop
            Put_Line(File => Parser.o_file, Item => "A = A + 1"); -- A = A + argument = offset of THAT segment (from start)
            i := i - 1;
         end loop;
      end;

      Put_Line(File => Parser.o_file, Item => "M = D");                -- RAM[ RAM[THIS] + argument ] = the value in THIS + offset

      Put_Line(File => Parser.o_file, Item => "@SP");                   -- A = SP = 0
      Put_Line(File => Parser.o_file,Item => "M = M - 1");          -- RAM[0] = RAM[0] - 1 = next available place in memory

      --  Close(file);
   end pop_this;

   procedure pop_that (argument : Integer) is
   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");

      Put_Line (File => Parser.o_file, Item => "//POP THAT");
      Put_Line (File => Parser.o_file, Item => "@SP");                    -- A = SP = 0
      Put_Line (File => Parser.o_file, Item => "A = M - 1");           -- A = RAM[0] - 1
      Put_Line(File => Parser.o_file, Item => "D = M");                --  D = RAM[A] = VALUE OF *SP - 1

      Put_Line(File => Parser.o_file, Item => "@THAT");                 -- A = THAT = 4 // usually
      Put_Line(File => Parser.o_file,Item => "A = M");                -- A = RAM[THAT] = value of first (segment start addr)
      declare -- iterate argument no. of times to get to the correct address
         i : Integer := argument;
      begin
         while i >= 1 loop
            Put_Line(File => Parser.o_file, Item => "A = A + 1"); -- A = A + argument = offset of THAT segment (from start)
            i := i - 1;
         end loop;
      end;
      Put_Line(File => Parser.o_file, Item => "M = D");                -- RAM[ RAM[THAT] + argument ] = the value in THAT + offset

      Put_Line(File => Parser.o_file, Item => "@SP");                   -- A = SP = 0
      Put_Line(File => Parser.o_file, Item => "M = M - 1");          -- RAM[0] = RAM[0] - 1 = next available place in memory

      --  Close(file);
   end pop_that;

   procedure pop_temp (argument : Integer) is
   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");

      Put_Line (File => Parser.o_file, Item => "//POP TEMP");
      Put_Line(File => Parser.o_file,Item => "@SP");                    -- A = SP = 0
      Put_Line (File => Parser.o_file, Item => "A = M - 1");           -- A = RAM[0] - 1
      Put_Line(File => Parser.o_file,Item => "D = M");                --  D = RAM[A] = VALUE OF *SP - 1 = value at top of stack
      declare
         val : Integer := 5 + argument;
      begin
         Put_Line (File => Parser.o_file, Item => "@" & val'Image (2 .. val'Image'Length));
      end;
      Put_Line(File => Parser.o_file,Item => "M = D");                -- RAM[ RAM[TEMP] + argument ] = the value in TEMP + offset

      Put_Line(File => Parser.o_file, Item => "@SP");                   -- A = SP = 0
      Put_Line(File => Parser.o_file,Item => "M = M - 1");          -- RAM[0] = RAM[0] - 1 = next available place in memory

      --  Close(file);
   end pop_temp;

   procedure pop_static (argument : Integer)
   is -- file_name = "name" from "name.vm"
      str_class_name : String := To_String (file_name) & '.' &
        argument'Image (2 .. argument'Image'Length);
      -- RANGE OF STATIC BLOCK: [16 - 255]
      -- can also calculate the offset with a loop incrementing 'argument' times the value 16
   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");

      Put_Line (File => Parser.o_file, Item => "//POP STATIC");
      Put_Line (File => Parser.o_file, Item => "@SP");
      Put_Line (File => Parser.o_file, Item => "A = M - 1");
      Put_Line (File => Parser.o_file, Item => "D = M");

      Put_Line (File => Parser.o_file, Item => "@" & str_class_name);
      Put_Line (File => Parser.o_file, Item => "M = D");

      Put_Line (File => Parser.o_file, Item => "@SP");
      Put_Line (File => Parser.o_file, Item => "M = M - 1");
      --  Close(file);
   end pop_static;

   procedure pop_ptr (argument : Integer) is
   begin
      --  Open(File => file, Mode => Out_File, Name => "out_f.asm");
      if argument = 0 then
         Put_Line (File => Parser.o_file, Item => "//POP PTR 0");
      elsif argument = 1 then
         Put_Line (File => Parser.o_file, Item => "//POP PTR 1");
         --  else
         --     Put_Line (File => file, Item => "-- Invalid argument for Print_Pop_Ptr");  -- Handle invalid input (optional)
      end if;
      Put_Line(File => Parser.o_file, Item => "@SP");                    -- A = SP = 0
      Put_Line(File => Parser.o_file,Item => "A = M - 1");           -- A = RAM[0] - 1
      Put_Line(File => Parser.o_file,Item => "D = M");                --  D = RAM[A] = VALUE OF *SP - 1
      if argument = 0 then
         Put_Line (File => Parser.o_file, Item => "@THIS");
      elsif argument = 1 then
         Put_Line (File => Parser.o_file, Item => "@THAT");
         --  else
         --     null;  -- Handle the "others" case (no action)
      end if;
      Put_Line (File => Parser.o_file, Item => " M= D");        -- A = RAM[0] - 1

      Put_Line(File => Parser.o_file, Item => "@SP");                   -- A = SP = 0
      Put_Line(File => Parser.o_file, Item => "M = M - 1");          -- RAM[0] = RAM[0] - 1 = next available place in memory

      --  Close(file);
   end pop_ptr;

   procedure pop_label(label: String) is
   begin
      -- 'LABEL' = *(FRAME - (index)):
      Put_Line (File => Parser.o_file, Item => "@LCL");
      Put_Line (File => Parser.o_file, Item => "M=M-1");
      Put_Line (File => Parser.o_file, Item => "A=M");
      Put_Line (File => Parser.o_file, Item => "D=M");
      Put_Line (File => Parser.o_file, Item => "@THAT");
      Put_Line (File => Parser.o_file, Item => "M=D");
   end pop_label;

   -- FUNCTION WRITE PROCEDURES --
   procedure write_call(func_name: String, num_push_vars: Integer) is
   begin
      Put_Line (File => Parser.o_file, Item => "// CALL");
      Put_Line(File => Parser.o_file, Item =>"@" & To_String (file_name) & '.' &
                 argument'Image (2 .. argument'Image'Length));
      -- call g n:
      -- PUSH RETURN-ADDRESS
      Put_Line(File => Parser.o_file, Item =>"// push return-address");
      Put_Line(File => Parser.o_file, Item =>"@" & func_name & ".ReturnAddress");
      Put_Line(File => Parser.o_file, Item =>"D=A");
      Put_Line(File => Parser.o_file, Item =>"@SP");
      Put_Line(File => Parser.o_file, Item =>"A=M");
      Put_Line(File => Parser.o_file, Item =>"M=D");
      Put_Line(File => Parser.o_file, Item =>"@SP");
      Put_Line(File => Parser.o_file, Item =>"M=M+1");
      -- PUSH LCL
      push_label("LCL");
      -- PUSH ARG
      push_label("ARG");
      -- PUSH THIS
      push_label("THIS");
      -- PUSH THAT
      push_label("THAT");
      -- ARG = SP-n-5
      Put_Line(File => Parser.o_file, Item =>"//ARG = SP - n - 5");
      Put_Line(File => Parser.o_file, Item =>"@SP");
      Put_Line(File => Parser.o_file, Item =>"D=M");
      Put_Line(File => Parser.o_file, Item =>"@" & (num_push_vars - 5)'Image(2..num_push_vars'Image'Length));
      Put_Line(File => Parser.o_file, Item =>"D=D-A");
      Put_Line(File => Parser.o_file, Item =>"@ARG");
      Put_Line(File => Parser.o_file, Item =>"M=D");
      -- LCL = SP
      Put_Line(File => Parser.o_file, Item =>"// LCL = SP");
      Put_Line(File => Parser.o_file, Item =>"@SP");
      Put_Line(File => Parser.o_file, Item =>"D=M");
      Put_Line(File => Parser.o_file, Item =>"@LCL");
      Put_Line(File => Parser.o_file, Item =>"M=D");
      -- goto g
      Put_Line(File => Parser.o_file, Item =>"// goto g");
      Put_Line(File => Parser.o_file, Item =>"@" & func_name);
      Put_Line(File => Parser.o_file, Item =>"0; JMP");
      -- label return-address
      Put_Line(File => Parser.o_file, Item =>"// label return-address");
      Put_Line(File => Parser.o_file, Item =>"(" & func_name & ".ReturnAddress" & ")");
   end write_call;

   procedure write_function(func_name: String, pass_var_num: Integer) is
   begin
      -- Declaring a function 'func_name' with 'pass_var_num' local variables
      Put_Line(File => Parser.o_file, Item =>"// FUNCTION");
      -- label g
      Put_Line(File => Parser.o_file, Item =>"(" & func_name & ")");
      -- Initialize local variables to 0
      Put_Line(File => Parser.o_file, Item =>"@" & (pass_var_num)'Image(2..pass_var_num'Image'Length));
      Put_Line(File => Parser.o_file, Item =>"D=A");
      Put_Line(File => Parser.o_file, Item =>"@" & func_name & ".END");
      Put_Line(File => Parser.o_file, Item =>"D; JEQ");
      -- jump if false (k != 0)
      Put_Line(File => Parser.o_file, Item =>"(" & func_name & ".Loop)");
      Put_Line(File => Parser.o_file, Item =>"@SP");
      Put_Line(File => Parser.o_file, Item =>"A=M");
      Put_Line(File => Parser.o_file, Item =>"M=0");
      Put_Line(File => Parser.o_file, Item =>"@SP");
      Put_Line(File => Parser.o_file, Item =>"M=M+1");
      Put_Line(File => Parser.o_file, Item =>"@" & func_name & ".Loop");
      -- jump while (k != 0)
      Put_Line(File => Parser.o_file, Item =>"D=D-1; JNE");
      -- end when true: (k == 0)
      Put_Line(File => Parser.o_file, Item => "(" & func_name & ".END)");

   end write_function;

   procedure write_return is
   begin
      -- FRAME = LCL
      Put_Line (File => Parser.o_file, Item => "// FRAME = LCL");
      Put_Line (File => Parser.o_file, Item => "@LCL");
      Put_Line (File => Parser.o_file, Item => "D=M");
      -- RET = *(FRAME-5)
      Put_Line (File => Parser.o_file, Item => "// RET = *(FRAME - 5)");
      Put_Line (File => Parser.o_file, Item => "// RAM[13] = (LOCAL - 5)");
      Put_Line (File => Parser.o_file, Item => "@5");
      Put_Line (File => Parser.o_file, Item => "A=D-A");
      Put_Line (File => Parser.o_file, Item => "D=M");
      Put_Line (File => Parser.o_file, Item => "@13");
      Put_Line (File => Parser.o_file, Item => "M=D");
      -- *ARG = pop()
      Put_Line (File => Parser.o_file, Item => "// *ARG = pop()");
      Put_Line (File => Parser.o_file, Item => "@SP");
      Put_Line (File => Parser.o_file, Item => "M=M-1");
      Put_Line (File => Parser.o_file, Item => "A=M");
      Put_Line (File => Parser.o_file, Item => "D=M");
      Put_Line (File => Parser.o_file, Item => "@ARG");
      Put_Line (File => Parser.o_file, Item => "A=M");
      Put_Line (File => Parser.o_file, Item => "M=D");
      -- SP = ARG + 1
      Put_Line (File => Parser.o_file, Item => "// SP = ARG + 1");
      Put_Line (File => Parser.o_file, Item => "@ARG");
      Put_Line (File => Parser.o_file, Item => "D=M");
      Put_Line (File => Parser.o_file, Item => "@SP");
      Put_Line (File => Parser.o_file, Item => "M=D+1");
      -- THAT = *(FRAME-1)
      Put_Line (File => Parser.o_file, Item => "// THAT = *(FRAME - 1)");
      pop_label("THAT");
      -- THIS = *(FRAME-2)
      Put_Line (File => Parser.o_file, Item => "// THIS = *(FRAME - 2)");
      pop_label("THIS");
      -- ARG = *(FRAME-3)
      Put_Line (File => Parser.o_file, Item => "// ARG = *(FRAME - 3)");
      pop_label("ARG");
      -- LCL = *(FRAME-4)
      Put_Line (File => Parser.o_file, Item => "// LCL = *(FRAME - 4)");
      pop_label("LCL");
      -- goto RET
      Put_Line (File => Parser.o_file, Item => "// goto RET");
      Put_Line (File => Parser.o_file, Item => "@!3");
      Put_Line (File => Parser.o_file, Item => "A=M");
      Put_Line (File => Parser.o_file, Item => "0; JMP");

   end write_return;



end CodeWriter;
