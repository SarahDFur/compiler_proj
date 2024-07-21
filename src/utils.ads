with Ada.Containers.Vectors;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Utils is
   package String_Vector is new Ada.Containers.Vectors
     (Index_Type   => Natural,
      Element_Type => Unbounded_String);
   
   subtype String_Array is String_Vector.Vector;
   
   function split_string (str: String) return String_Array;
   function find_char_index (Search_str : String; ch: Character) return Integer ;
   function string_to_int (str:String) return Integer;
   function Remove_Whitespace(Input_String : String) return Unbounded_String;
   
end Utils;
