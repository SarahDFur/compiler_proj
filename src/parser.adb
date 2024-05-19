with Ada.Text_IO; use Ada.Text_IO;
with CodeWriter; use CodeWriter;
with Ada.Directories; use Ada.Directories;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package body Parser is

   procedure switch_stack_ops (op: String, label : String, argument: Integer) is
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

   procedure switch_arith_ops (op:String, label:String, argument:Integer) is
   begin
   end switch_arith_ops;

   procedure switch_logic_ops (op:String, label:String, argument:Integer) is
   begin
   end switch_logic_ops;

   --------------------------------------------------------------------------------------------------------------------------
   procedure parse_Instruction (i_fname: String, Line : String) is  -- will be called from main ("init" function for parser)
      file: File_Type; -- will be used to write to the output .asm file
      input_f: File_Type; -- for the file we read (sent by main in a loop (or in a separate function here )
      o_fname: String;
   begin
      Open(File => input_f, Mode => In_File, Name => i_fname);
      -- create the output file here bellow
      -- use the i_fname (everything before the '.' -> need to create a function that executes .split(char))
      Create(File => file, Mode => Out_File,
             Name => Current_Directory & o_fname);
      Open(File => file, Mode => Out_File, Name => --"out_f.asm"); -- o_fname & ".asm"
      -- already created in main (only opened once for the entire writing
      -- we will need to create out files for every vm file separately

      close(file);
      close(input_f);
   end parse_Instruction;

end Parser;
