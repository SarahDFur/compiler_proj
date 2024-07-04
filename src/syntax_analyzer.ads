with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Syntax_Analyzer is

   procedure init_analyzer (filename: Unbounded_String);
   --# PROGRAM STRUCTURE:
   procedure parse_class;
   procedure parse_classVarDec (t: Unbounded_String);
   procedure parse_type (t: Unbounded_String);
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

end Syntax_Analyzer;
