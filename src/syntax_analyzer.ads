with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Syntax_Analyzer is

   procedure init_analyzer (filename: Unbounded_String);
   --# PROGRAM STRUCTURE:
   procedure parse_class;
   procedure parse_classVarDec (t: Unbounded_String);
   procedure parse_type (t: Unbounded_String);
   procedure parse_subroutineDec (t: Unbounded_String);
   procedure parse_parameterList;
   procedure parse_varDec;
   --# STATEMENTS:
   procedure parse_statements (t: Unbounded_String);
   function parse_statement (t : Unbounded_String) return Unbounded_String;
   function parse_letStatement (t: Unbounded_String) return Unbounded_String;
   function parse_ifStatement (t: Unbounded_String) return Unbounded_String;
   function parse_whileStatement (t: Unbouned_String) return Unbounded_String;
   function parse_doStatement (t: Unbounded_String) return Unbounded_String;
   function parse_returnStatement (t: Unbounded_String) return Unbounded_String;
   --# EXPRESSIONS:
   procedure parse_expression;
   function parse_term (t: Unbounded_String) return Unbounded_String;
   procedure parse_expressionList;

end Syntax_Analyzer;
