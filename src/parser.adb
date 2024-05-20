with Ada.Text_IO; use Ada.Text_IO;
with CodeWriter; use CodeWriter;
with Ada.Directories; use Ada.Directories;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Utils; use Utils;

package body Parser is

   o_file: File_Type; -- output file ASM

   --  type instruction_record is record
   --     op: String  (1.. 30);
   --     label : String  (1.. 30);
   --     arg: Integer;
   --  end record;

   procedure init_parser(full_ofname:String) is
-- VARAIBLE that contains all the .vm file names in the current directory ( add a function in Utils )
      --  fnames_arr: array(0..4) of String;
   begin
      Open(File => o_file, Mode => Out_File, Name => full_ofname);
      --  fnames_arr := Utils.current_dir_filenames;
      -- loop that for each file in the current dir (that is vm)
      -- send the file name to the read_file procedure

      Close(o_file);
   end init_parser;

   procedure init_file_traversal is -- like list_directories from project 0
   begin
      -- 1. loop over all files in current directory
      -- 2. if the file has extenssion of ".vm":
      -- 2.1. extract name of file
      -- 2.2: create and open a corresponding .asm file (with the same file name as the .vm one)
      -- 3. ...
      null;
   end init_file_traversal;

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
      ins: String := "";
      f_in : File_Type;
      instructions: instruction_record;
   begin
      Open(File => f_in, Mode => In_File, Name => if_name); -- the input file with the .vm extenssion

      CodeWriter.init_f(if_name); -- initialize the input file name in the codewriter for ease of use in labels, static etc.

      while not End_Of_File(f_in) loop
         ins := Get_Line (File => f_in);
         instructions := parse_Instruction(ins);
         if instructions.op = "pop" or instructions.op = "push" then
            switch_stack_ops(instructions.op, instructions.label, instructions.arg);
         else
            switch_arith_ops(instructions.op);
         end if;
         ins := "";
      end loop;

      CodeWriter.init_f(""); -- make the current file name an empty string once more
      Close(f_in);
   end read_file;

   function  parse_Instruction (Line:String) return instruction_record is
   -- 1. separate the instruction by finding the index of ' '
   -- 2. delete that part of the string
   -- 3. send in loop again until there is we are returned -1
   -- 4. then use that last one for what is needed
   -- (usually changed to number, but need to check based on all options!)
      ins: instruction_record;
   begin

      return ins;
   end parse_Instruction;

end Parser;
