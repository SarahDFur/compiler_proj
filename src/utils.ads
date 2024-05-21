with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
package Utils is

   type String_Array is array (Positive range <>) of Unbounded_String;
   
   function find_char_index (Search_str : String; ch: Character) return Integer ;
   --  function current_dir_filenames return string_arr;
   ------------------------ ! ! ! ! ! define a string array data type ! ! ! ! ! -----------------------------------
   function string_to_int (str:String) return Integer;
   function split_string (str: String) return String_Array;
   
end Utils;
