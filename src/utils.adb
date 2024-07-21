with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Conversions;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

package body Utils is
   
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
     
   function split_string (str: String) return String_Array is
      S : Unbounded_String := To_Unbounded_String(str);
      Words : String_Array := String_Vector.Empty_Vector;
      Temp : Unbounded_String := To_Unbounded_String("");
   begin
      for I in 1 .. Length(S) loop
         if Element(S, I) = ' ' then
            if Length(Temp) > 0 then
               String_Vector.Append(Words, Temp);
               Temp := To_Unbounded_String("");
            end if;
         else
            Append(Temp, Element(S, I));
         end if;
      end loop;
      
      if Length(Temp) > 0 then
         String_Vector.Append(Words, Temp);
      end if;
      
      return Words;
   end split_string;


   function Remove_Whitespace (Input_String : String) return Unbounded_String is
      Trimmed_String : Unbounded_String := To_Unbounded_String("");  -- Initialize empty string
      --  Index : Integer range 0 .. Input_String'Length;
      Original_String: Unbounded_String := To_Unbounded_String("");
   begin
      for Index in Input_String'Range loop
         if not ((Input_String(Index)) = ' ' or Input_String(Index)'Image = "") then  -- Input_String(Index) = "	"
            Trimmed_String := Trimmed_String & Input_String(Index);
            Original_String := Original_String & Input_String(Index);
         else
            Trimmed_String := Trimmed_String & '_';
            --  Original_String := Original_String & "_";
            Append(Original_String, '_');
         end if;
      end loop;
      -- Put_Line ("     Original string: " & To_String(Original_String));
      --Put_Line ("     Trimmed string: " & To_String(Trimmed_String));
      return Trimmed_String;
   end Remove_Whitespace;
end Utils;
