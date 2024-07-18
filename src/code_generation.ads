with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;

package Code_Generation is

      --# Identifiers:
   -- className, subroutineName, varName

   --# Globals:
   curr_xml_file: File_Type;  -- reads from JACK file
   curr_vm_file: File_Type;    --  writes to VM file
   out_sym_tbl : File_Type;
   --# Global Vars: LABEL COUNTERS:
   count_if : Integer := 0;
   count_else : Integer := 0;
   count_before_while : Integer := 0;
   count_after_while : Integer := 0;
   --# Global Vars: Function Counters:
   count_locals : Integer := 0;
   count_args : Integer := 0;
   --# Other Counters:
   count_class_vars : Integer := 0;
   --# Helper Variables:
   sym_tbl_name : Unbounded_String := To_Unbounded_String("");
   curr_class_name : Unbounded_String := To_Unbounded_String("");
   curr_func_name : Unbounded_String := To_Unbounded_String("");
   type String_Array is array (Positive range <>) of Unbounded_String;

   procedure init_analyzer (filename: Unbounded_String);
   --# PROGRAM STRUCTURE:
   procedure parse_class;
   procedure parse_classVarDec (t: Unbounded_String);
   function parse_type (t: Unbounded_String) return Unbounded_String;
   procedure parse_subroutineDec (t: Unbounded_String);
   procedure parse_subroutineBody;
   procedure parse_parameterList;
   procedure parse_varDec;
   --# STATEMENTS:
   function parse_statements (t: Unbounded_String) return Unbounded_String;
   function parse_statement (t : Unbounded_String) return Unbounded_String;
   function parse_letStatement (t: Unbounded_String) return Unbounded_String;
   function parse_ifStatement (t: Unbounded_String) return Unbounded_String;
   function parse_whileStatement (t: Unbounded_String) return Unbounded_String;
   function parse_doStatement (t: Unbounded_String) return Unbounded_String;
   function parse_returnStatement (t: Unbounded_String) return Unbounded_String;
   --# EXPRESSIONS:
   function parse_expression (t : Unbounded_String := To_Unbounded_String("")) return Unbounded_String;
   function parse_term (t: Unbounded_String  := To_Unbounded_String("")) return Unbounded_String;
   function parse_subroutineCall (t : Unbounded_String := To_Unbounded_String("")) return Unbounded_String;
   function parse_expressionList (t: Unbounded_String := To_Unbounded_String("")) return Unbounded_String;
   --# Converters:
   function convert_expression_ops (t : Unbounded_String) return Unbounded_String;

end Code_Generation;
