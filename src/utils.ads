with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
package Utils is

   type String_Array is array (Positive range <>) of Unbounded_String;
   
   function find_char_index (Search_str : String; ch: Character) return Integer ;
   function string_to_int (str:String) return Integer;
   function split_string (str: String) return String_Array;
   function Remove_Whitespace(Input_String : String) return Unbounded_String;
   
end Utils;
