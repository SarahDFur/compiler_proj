package body Utils is

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

   function delete_substring (str: String, sub: String) return String is
      i_start : Integer := 0;
      i_end : Integer := 0;
   begin
      i_start := find_char_index(str, sub(1));
      i_end := find_char_index(str, sub(sub'Length - 1));
      return str(0..i_start-1) & str(i_end..str'Length - 1);
   end delete_substring;
   
end Utils;
