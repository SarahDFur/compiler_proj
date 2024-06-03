with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;
package Parser is
   o_file: File_Type; -- output file ASM

   type instruction_record is record
      op: Unbounded_String;
      label : Unbounded_String;
      arg: Integer;
   end record;
   type String_Array is array (Positive range <>) of Unbounded_String;
   
   procedure init_parser(full_ofname: String); -- initializes the parser - CALLED FROM MAIN
   procedure read_file(if_name: String);
   -- Will have a switch, in which all instructions 
   -- Instruction Line will be sent to the appropriate write_to_file functions
   function parse_Instruction (Line : String) return instruction_record;
   procedure switch_stack_ops (op: String; label : String; argument: Integer);
   procedure switch_arith_ops (op: String);
   procedure switch_functions_ops (op: String; label : String; argument: Integer);

end Parser;

