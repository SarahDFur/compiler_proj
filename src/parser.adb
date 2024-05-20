with Ada.Text_IO; use Ada.Text_IO;
with CodeWriter; use CodeWriter;
with Ada.Directories; use Ada.Directories;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Utils; use Utils;

package body Parser is

   o_file: File_Type; -- output file ASM

   type instruction_record is record
      op: String;
      label : String;
      arg: Integer;
   end record;

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
      case op is
         when "push" =>
            case label is
-- Group 1: (local, argument, this, that)
               when "local" =>
                  CodeWriter.push_local(argument);
               when "argument" =>
                  CodeWriter.push_argument(argument);
               when "this" =>
                  CodeWriter.push_this(argument);
               when "that" =>
                  CodeWriter.pus_that(argument);
-- Group 2 (temp)
               when "temp" =>
                  CodeWriter.push_temp(argument);
-- Group 3 (static)
               when "static" =>
                  CodeWriter.push_static(argument);
-- Group 4 (pointer 0, pointer 1)
               when "pointer" =>
                  CodeWriter.push_ptr(argument);
-- Group 5 (constant)
               when "constant" =>
                  CodeWriter.push_const(argument);
            end case;

         when "pop" =>
-- Group 1: (local, argument, this, that)
            case label is
               when "local" =>
                  CodeWriter.pop_local(argument);
               when "argument" =>
                  CodeWriter.pop_argument(argument);
               when "this" =>
                  CodeWriter.pop_this(argument);
               when "that" =>
                  CodeWriter.pop_that(argument);
-- Group 2 (temp)
               when "temp" =>
                  CodeWriter.pop_temp(argument);
-- Group 3 (static)
               when "static" =>
                  CodeWriter.pop_static(argument);
-- Group 4 (pointer 0, pointer 1)
               when "pointer" =>
                  CodeWriter.pop_ptr(argument);
            end case;
      end case;
   end switch_stack_ops;

   procedure switch_arith_ops (op:String; label:String; argument:Integer) is
   begin
      case op is
      when "add" =>
         CodeWriter.write_add;
      when "sub" =>
         CodeWriter.write_sub;
      when "neg" =>
         CodeWriter.write_neg;
      when "or" =>
         CodeWriter.write_or;
      when "and" =>
         CodeWriter.write_and;
      when "not" =>
         CodeWriter.write_not;
      when "eq" =>
         CodeWriter.write_eq;
      when others =>
         null;
      end case;
   end switch_arith_ops;
   --------------------------------------------------------------------------------------------------------------------------
   -- READ ALL LINES FROM FILE AND SEND TO parse_instruction: --
   procedure read_file (if_name: String) is
      -- 1. in a loop, get_line all the lines
      -- 2. send each line to parse_instruction
      i : Integer := 0;
      Line: String := "";
      f_in : File_Type;
      instructions: instruction_record;
   begin
      Open(File => f_in, Mode => In_File, Name => if_name); -- the input file with the .vm extenssion

      CodeWriter.init_f(if_name); -- initialize the input file name in the codewriter for ease of use in labels, static etc.

      while not End_Of_File(f_in) loop
         Get_Line (File => f_in, Item => Line);
         instructions := parse_Instruction(Line);
         if instructions.Op = "pop" or instructions.Op = "push" then
            switch_stack_ops(instructions.Op, instrucions.label, instructions.arg);
         else
            switch_arith_ops(instructions.Op, instrucions.label, instructions.arg);
         end if;
         Line := "";
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
