with Ada.Text_IO; use Ada.Text_IO;
with CodeWriter; use CodeWriter;
with Ada.Directories; use Ada.Directories;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Utils; use Utils;
with Ada.Characters.Conversions;
use Ada.Characters.Conversions;

package body Parser is

   --  o_file: File_Type; -- output file ASM
   --  type String_Array is array (Positive range <>) of Unbounded_String;

   procedure init_parser(full_ofname:String) is
-- VARAIBLE that contains all the .vm file names in the current directory ( add a function in Utils )
    S : Unbounded_String := To_Unbounded_String("");
    Pattern : constant String := "*.vm";
    Filter  : constant Filter_Type := (Ordinary_File => True, others => False); -- Files only.
    Search : Search_Type;
    Dir_Entry : Directory_Entry_Type;
    Temp : Unbounded_String := To_Unbounded_String("");
    type String_Array is array (Positive range <>) of Unbounded_String;
    Arr : String_Array (1 .. 300000);-- Initialize all elements in the array
    counter : Natural := 1; -- For indexing the array elements
begin
    --Put_Line(Current_Directory); -- Print the current directory
      Open(File => o_file, Mode => Out_File, Name => "out_f.asm");

      Start_Search(Search, Current_Directory, Pattern, Filter); -- Start searching
      while More_Entries(Search) loop
         Get_Next_Entry(Search, Dir_Entry);
         --Ada.Text_IO.Put_Line(Simple_Name(Dir_Entry));
         Append(S, Simple_Name(Dir_Entry));
         Append(S, " ");
      end loop;

      End_Search(Search);

      -- Debug Print: Print the content of S
      --  Ada.Text_IO.Put_Line("Content of S: " & To_String(S));

      -- Extracting strings and adding them to the array
      for I in 1 .. Natural(Length(S)) loop
         if Element(S, I) = ' ' then
            -- Debug Print: Print the content of Temp
            --  Ada.Text_IO.Put_Line("Content of Temp: " & To_String(Temp));
            Arr(counter) := Temp;
            --  Ada.Text_IO.Put_Line("Content of Temp: " & To_String(Arr(counter)));
            counter := counter + 1;
            Temp := To_Unbounded_String("");
         else
            Append(Temp, Element(S, I));
         end if;
      end loop;

      -- Debug Print: Print the content of Arr
      for I in 1 .. counter - 1 loop
         read_file(To_String(Arr(I)));
      end loop;
      Close(o_file);
   end init_parser;

   -- SWITCH FUNCTIONS FOR DIFFERENT PARAMETERS PASSED --
   procedure switch_stack_ops (op: String; label : String; argument: Integer) is
   begin
      if op = "push" then
         if label = "local" then
            CodeWriter.push_local(argument);
         elsif label = "argument" then
            CodeWriter.push_argument(argument);
         elsif label = "this" then
            CodeWriter.push_this(argument);
         elsif label = "that" then
            CodeWriter.push_that(argument);
         elsif label = "temp" then
            CodeWriter.push_temp(argument);
         elsif label = "static" then
            CodeWriter.push_static(argument);
         elsif label = "pointer" then
            CodeWriter.push_ptr(argument);
         elsif label = "constant" then
            CodeWriter.push_const(argument);
         else
            -- Handle invalid label for "push" operation (optional)
            null;
         end if;
      else -- op = "pop"
         if label = "local" then
            CodeWriter.pop_local(argument);
         elsif label = "argument" then
            CodeWriter.pop_argument(argument);
         elsif label = "this" then
            CodeWriter.pop_this(argument);
         elsif label = "that" then
            CodeWriter.pop_that(argument);
         elsif label = "temp" then
            CodeWriter.pop_temp(argument);
         elsif label = "static" then
            CodeWriter.pop_static(argument);
         elsif label = "pointer" then
            CodeWriter.push_ptr(argument); -- typo in original code, should be pop_ptr
         else
            -- Handle invalid label for "pop" operation (optional)
            null;
         end if;
      end if;
   end switch_stack_ops;

   procedure switch_arith_ops (op:String) is
   begin
      if op = "add" then
         CodeWriter.write_add;
      elsif op = "sub" then
         CodeWriter.write_sub;
      elsif op = "neg" then
         CodeWriter.write_neg;
      elsif op = "or" then
         CodeWriter.write_or;
      elsif op = "and" then
         CodeWriter.write_and;
      elsif op = "not" then
         CodeWriter.write_not;
      elsif op = "eq" then
         CodeWriter.write_eq;
      elsif op = "lt" then
         CodeWriter.write_lt;
      elsif op = "gt" then
         CodeWriter.write_gt;
      else
         null;  -- Handle the "others" case
      end if;

   end switch_arith_ops;
   --------------------------------------------------------------------------------------------------------------------------
   -- READ ALL LINES FROM FILE AND SEND TO parse_instruction: --
   procedure read_file (if_name: String) is
      -- 1. in a loop, get_line all the lines
      -- 2. send each line to parse_instruction
      i : Integer := 0;
      ins: Unbounded_String;
      f_in : File_Type;
      instructions: instruction_record;
      name: Unbounded_String := To_Unbounded_String(if_name(if_name'First..find_char_index(if_name, '.')  - 1));
   begin
      Put_Line(if_name);
      Open(File => f_in, Mode => In_File, Name => if_name); -- the input file with the .vm extenssion

      CodeWriter.init_f(name); -- initialize the input file name in the codewriter for ease of use in labels, static etc.

      while not End_Of_File(f_in) loop
         ins := To_Unbounded_String(Get_Line (File => f_in));
         --  Put_Line(To_String(ins));
         instructions := parse_Instruction(To_String(ins));
         if To_String(instructions.op) = "pop" or To_String(instructions.op) = "push" then
            switch_stack_ops(op => To_String(instructions.op), label => To_String(instructions.label), argument => instructions.arg);
         else
            switch_arith_ops(To_String(instructions.op));
         end if;
         ins := To_Unbounded_String("");
      end loop;

      CodeWriter.init_f(To_Unbounded_String("")); -- make the current file name an empty string once more
      Close(f_in);
   end read_file;

   function  parse_Instruction (Line:String) return instruction_record is
   -- 1. separate the instruction by finding the index of ' '
   -- 2. delete that part of the string
   -- 3. send in loop again until there is we are returned -1
   -- 4. then use that last one for what is needed
   -- (usually changed to number, but need to check based on all options!)
      ins: instruction_record;
      arr: Utils.String_Array := (1..300000=> To_Unbounded_String(""));
   begin
      arr := Utils.split_string(Line);
      if arr(1) /= "push" and arr(1) /= "pop" and arr(1) /= "add" and arr(1) /= "sub" and arr(1) /= "eq" and arr(1) /= "gt"
        and arr(1) /= "lt" and arr(1) /= "and" and arr(1) /= "or" and arr(1) /= "not" and arr(1) /= "neg" then
         ins.op := To_Unbounded_String("//");
         ins. label := To_Unbounded_String("");
         ins.arg := 0;
         --  Put_Line(File => o_file, item => To_String(arr(1)));
      else
         ins.op := (arr(1));
         --  Put_Line(File => o_file, item => To_String(arr(1)));

         if arr(2) /= "" then
            ins.label := (arr(2));
            --  Put_Line(File => o_file, item => To_String(arr(2)));
            if arr(3) /= "" then
               ins.arg := Utils.string_to_int(To_String(arr(3)));
               --  Put_Line(File => o_file, item => To_String(arr(3)));
            end if;
         end if;
      end if;
      return ins;
   end parse_Instruction;

end Parser;
