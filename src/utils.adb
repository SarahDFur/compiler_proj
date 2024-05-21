with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Conversions;

package body Utils is
   
   --  type String_Array is array (Positive range <>) of Unbounded_String;

   -- type conversion function : String -> Integer
   function string_to_int (str: String) return Integer is
      T : Unbounded_String := To_Unbounded_String (str);
      I : Integer := Integer'Value (To_String (T));
   begin
      return I;
   end string_to_int;
   
   
   -- Returns the index of the character ch in a given string --
   function find_char_index (Search_str : String; ch: Character) return Integer is
   begin
      --  index := Search_str'Length;
      --  Put_Line(index'Image);
      --  Put_Line(Search_str);
      for Index in Search_str'Range loop
            if Search_str(Index) = ch then
                Put_Line("char at index:" & Index'Image);
                return Index;
            end if;
      end loop;
      return -1;
   end find_char_index;

   function split_string (str: String) return String_Array is
      Arr : String_Array := (1..300000=> To_Unbounded_String("")); --not size cost
      conter: Integer:=1;
      Temp : Unbounded_String := To_Unbounded_String(" ");
      S1 : String:=" ";
   begin 
      --  S1:= To_String(str);
      for I in str'Range loop
         if str(I) = ' ' then
            Arr(conter):=Temp;
            conter:=conter+1;
            Temp := To_Unbounded_String(" ");
         else
            Append(Temp, str(I));
         end if;
      end loop;
      return Arr;
   end split_string;

   
end Utils;
