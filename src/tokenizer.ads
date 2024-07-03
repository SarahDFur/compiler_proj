with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Tokenizer is
   --# Init / Self made "Constructor":
   -- keyword, symbol, integerConstant, StringConstant, identifier
   procedure init_xml(filename: Unbounded_String);
   --# Automata States:
   --  procedure automata(line: Unbounded_String);
   function q0_start  (char: Character := Ada.Characters.Latin_1.NUL) return Character;
   -- Will return the last character read that breaks the rule of the state:
   function q1_letters (char: Character) return Character; -- will be for keywords
   function q3_integer_constants (char: Character) return Character; -- for numbers
   function q4_symbols (char: Character) return Character; -- for symbols
   procedure q5_string_constants; -- will loop through the string until it gets to " and then send it to be written
   --# Conversions & Writing to xxxT.xml file:
   --  procedure parse_tok(Line: Unbounded_String);
   procedure switch_write_tag (elem:String; word: String);
   function convert_symbol(sym: String) return String;
   --  procedure check_type;
end Tokenizer;
