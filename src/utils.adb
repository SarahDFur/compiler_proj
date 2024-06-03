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
                Put_Line("char at index:" & Index'Image );
                Put_Line(Search_str(Search_str'First .. Index-1));
                return Index;
            end if;
      end loop;
      return -1;
   end find_char_index;


   function Split_String (Str: String) return String_Array is
      Arr : String_Array := (1..1000=> To_Unbounded_String("")); -- Initialize the array
      Counter : Natural := 1; -- For indexing the array elements
      Temp : Unbounded_String := To_Unbounded_String("");
      S : Unbounded_String := To_Unbounded_String(Str);
      Index : Natural := 1;
   begin
      -- Find the first non-space character
       while Index <= Length(S) loop
         exit when Element(S, Index) /= ' ';
         Index := Index + 1;
      end loop;

      -- Print the index of the first non-space character
      --Ada.Text_IO.Put_Line("The index of the first non-space character is: " & Natural'Image(Index));

      -- Split the string into array elements
      for I in Index .. Natural(Length(S)) loop
         if Element(S, I) = ' ' then
               Arr(Counter) := Temp;
               Counter := Counter + 1;
               Temp := To_Unbounded_String("");

         else
            Append(Temp, Element(S, I));
         end if;
      end loop;

      -- Add the last collected string to the array if not empty
      if To_String(Temp) /= "" then
         Arr(Counter) := Temp;
      end if;
   
      return Arr;
   end Split_String;


   
end Utils;
