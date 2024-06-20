with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Tokenizer is
   -- keyword, symbol, integerConstant, StringConstant, identifier
   procedure init_vm(filename: Unbounded_String);
   procedure automata(line: Unbounded_String);
   procedure parse_tok(Line: Unbounded_String);
   procedure switch_write_tag (elem:String; word: String);
   function convert_symbol(sym: String) return String;
end Tokenizer;
