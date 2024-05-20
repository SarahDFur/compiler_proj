package Utils is

   function find_char_index (Search_str : String; ch: Character) return Integer ;
   --  function delete_substring (str: String; sub: String) return String;
   function current_dir_filenames return string_arr; 
   ------------------------ ! ! ! ! ! define a string array data type ! ! ! ! ! -----------------------------------
   function string_to_int (str:String) return Integer;
end Utils;
