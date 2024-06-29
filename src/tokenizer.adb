with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Utils; use Utils;
with Ada.Directories; use Ada.Directories;
with Ada.Characters.Conversions; use Ada.Characters.Conversions;

package body Tokenizer is
   --# Start of Global variables & Records:
   -- Will be used to access (write) to the output file (xxxT.xml):
   o_file: File_Type;
   -- Variable we'll use to access the file:
   in_file: File_Type;
   -- Will contain the current token / stream of characters we wish to check :
   temp: Unbounded_String := To_Unbounded_String("");  
   -- Will contain the type of what's inside temp: [keyword, identifier, symbol, integerConstant, stringConstant]:
   temp_type : Unbounded_String := To_Unbounded_String("");

   -- Token Record for easier access when reading and writing:
   type Token is record
      elem: Unbounded_String;
      val: Unbounded_String;
   end record;
   --# End of Globals section ^
   
   --# Creates & Opens xxxT.xml files (for writing):
   procedure init_xml(filename: Unbounded_String) is
      -- The name of the current file we wish to *READ* from:
      name: Unbounded_String := To_Unbounded_String(
                                                    To_String(filename)
                                                    (To_String(filename)'First..find_char_index(To_String(filename), '.')  - 1)
                                                   );
   begin
      -- 1.1. create file where filename = name & 'T.xml' for WRITING:
      Create(File => o_file, Mode => Out_File, Name => Current_Directory & '\' & To_String(name) & "T.xml");
      Close(o_file);
      -- 1.2 & 1.3 will be closed at the end of this procedure !
      -- 1.2. open the '.jack' file for READING:
      Open(File => in_file, Mode => Ada.Text_IO.In_File, Name => To_String(filename));
      -- 1.3. open xxxT.xml for WRITING:
      Open(File => o_file, Mode => Out_File, Name => To_String(name) & "T.xml");
      -- 2. write '<tokens>' label as first line
          -- <tokens></tokens> == opening tag 
      Put_Line(File => o_file, Item => "<tokens>");
      -- 3. each line must be separated to individual tokens
      --  while not End_Of_File(f_in) loop
      --     line := To_Unbounded_String(Get_Line (File => o_file));
      --     automata(line);
      --  end loop;
      q0_start;
      Put_Line(File => o_file, Item => "</tokens>");
      Close(o_file);
      Close(in_file);
   end init_xml;
   
   --  procedure automata(line: Unbounded_String) is
   --     str : String := To_String(line);
   --     temp: Unbounded_String := To_Unbounded_String('');
   --  begin
   --     for i in str'Range loop
   --        if str(i) in '0'|'1'|'2'|'3'|'4'|'5'|'6'|'7'|'8'|'9' then
   --           Append(temp, str(i));
   --        elsif str(i) in 'class' | 'method' | 'field' | 'function' | 'constructor' | 'int' | 'boolean' | 'char'
   --          |'void' | 'var' | 'static' | 'let' | 'do' | 'if' | 'else' | 'while' | 'return' | 'true' | 'false' | 'null' | 'this' then
   --           if temp /= To_Unbounded_String('') then
   --              switch_write_tag('integerConstant', temp);
   --              temp := To_Unbounded_String('');
   --           end if;
   --  
   --        end if;
   --     end loop;
   --  end automata;

   --# Q0 - Starting point of the Automata:
   procedure q0_start is
      ch: Character;
   begin
      while not End_Of_File(in_file) loop
         -- Get the next character to read from the file
         Get(in_file, ch);  
         -- Because we're at the start of the automata we need to call 
         -- the appropriate procedure / function based on 'ch'
         
         -- 'Switch' Operation:
         -- Send to appropriate state:
         if ch in '0'|'1'|'2'|'3'|'4'|'5'|'6'|'7'|'8'|'9' then
            ch := q3_integer_constants(ch);
         elsif ch in 'A' | 'B' | 'C' | 'D' | 'E' | 'F' | 'G' | 'H' | 'I' | 'J' | 'K' | 'L' | 'M' | 'N' | 'O' | 'P' 
           | 'Q' | 'R' | 'S' | 'T' | 'U' | 'V' | 'W' | 'X' | 'Y' | 'Z' 
             | 'a' | 'b' | 'c' | 'd' | 'e' | 'f' | 'g' | 'h' | 'i' | 'j' | 'k' | 'l' | 'm' | 'n' | 'o' | 'p' | 'q' | 'r' 
               | 's' | 't' | 'u' | 'v' | 'w' | 'x' | 'y' | 'z' then
            ch := q1_letters(ch);   -- keyword is in temp if run is successful
         elsif ch in '{'|'}'|'('|')'|'['|']'|'.'|','|':'|'+'|'-'|'/'|'*'|'&'|'|'|'<'|'>'|'='|'~' then
            ch := q4_symbols(ch); -- symbol is in temp if run is successful
         elsif ch = '_' then
            ch := q2_ids(ch);         -- identifier is in temp if run is successful 
         elsif ch = '"' then  -- No need to send ch because we are saving the contents of the string without ' '
            q5_string_constants;  
            --  ch := '';
         end if;
         -- Send temp to be written into the output file:
         --  check_type; -- get correct type if it was not set until now in one of the states
         switch_write_tag(To_String(temp_type), To_String(temp));
         -- Nullify temp:
         temp := To_Unbounded_String(""); 
         temp_type := To_Unbounded_String("");
         if ch /= Character'Val(0) then
            Append(temp, ch);
         end if;
      end loop;
   end q0_start;
   --# Q1 - Keywords:
   function q1_letters (char: Character) return Character is
      ch: Character := char;
   begin
      while not End_Of_File(in_file) loop
         if ch not in 'A' | 'B' | 'C' | 'D' | 'E' | 'F' | 'G' | 'H' | 'I' | 'J' | 'K' | 'L' | 'M' | 'N' | 'O' | 'P' 
           | 'Q' | 'R' | 'S' | 'T' | 'U' | 'V' | 'W' | 'X' | 'Y' | 'Z' 
             | 'a' | 'b' | 'c' | 'd' | 'e' | 'f' | 'g' | 'h' | 'i' | 'j' | 'k' | 'l' | 'm' | 'n' | 'o' | 'p' | 'q' | 'r' 
               | 's' | 't' | 'u' | 'v' | 'w' | 'x' | 'y' | 'z' then
            -- IF ch in SYMBOL => temp_type = keyword
            if ch in  '{'|'}'|'('|')'|'['|']'|'.'|','|':'|'+'|'-'|'/'|'*'|'&'|'|'|'<'|'>'|'='|'~'|'''|' ' then
               if To_String(temp) in "class" | "method" | "field" | "function" | "constructor" | "int" | "boolean" 
                 | "char" |"void" | "var" | "static" | "let" | "do" | "if" | "else" | "while" | "return" 
                   | "true" | "false" | "null" | "this" then
                  temp_type := To_Unbounded_String("keyword");
               else
                  temp_type := To_Unbounded_String("identifer");
               end if;
               return ch;
            -- ELSE IF ch in NUMBERS or '_' => GOTO Q2
            elsif ch in '0'|'1'|'2'|'3'|'4'|'5'|'6'|'7'|'8'|'9'|'_' then
               ch := q2_ids(ch);
            end if;
         end if;
         temp := temp & ch;  -- First: temp = ch, then everything after will be added to it 
         Get(in_file, ch);
      end loop;
      -- In the case of this being the last word:
      temp_type := To_Unbounded_String("keyword");
      return ch;
   end q1_letters;
   --# Q2 - Identifiers:
   function q2_ids (char: Character) return Character is
      ch: Character := char;
   begin
      -- ID will stop being an id if it is a symbol or ' (or ' '):
      while not End_Of_File(in_file) loop
         if ch in  '{'|'}'|'('|')'|'['|']'|'.'|','|':'|'+'|'-'|'/'|'*'|'&'|'|'|'<'|'>'|'='|'~'|'''|' ' then
            -- No more numbers -> the integerConstant is finished
            temp_type := To_Unbounded_String("identifier");  -- Set to the appropriate type ! :>
            return ch;
         end if;
         temp := temp & ch;  -- First: temp = ch, then everything after will be added to it 
         Get(in_file, ch);
      end loop;
      -- In the case of this being the last word:
      temp_type := To_Unbounded_String("identifier");  -- Set to the appropriate type ! :>
      return ch;
   end q2_ids;
   --# Q3 - Integers:
   function q3_integer_constants (char: Character) return Character is
      ch: Character := char;
   begin
      while not End_Of_File(in_file) loop
         if ch not in '0'|'1'|'2'|'3'|'4'|'5'|'6'|'7'|'8'|'9' then  
            -- No more numbers -> the integerConstant is finished
            temp_type := To_Unbounded_String("integerConstant");  -- Set to the appropriate type ! :>
            return ch;
         end if;
         temp := temp & ch;  -- First: temp = ch, then everything after will be added to it 
         Get(in_file, ch);
      end loop;
      -- In the case of this being the last word:
      temp_type := To_Unbounded_String("integerConstant");  -- Set to the appropriate type ! :>
      return ch;
   end q3_integer_constants;
   --# Q4 - Symbols:
   function q4_symbols (char: Character) return Character is
      ch: Character := char;
      trash : Unbounded_String := To_Unbounded_String("");
   begin
      while not End_Of_File(in_file) loop
         if ch = '/' then  -- COMMENTS
            Get(in_file, ch);
            if ch = '/' then          -- Comment: //
               trash := To_Unbounded_String(Get_Line(File => in_file));
               Put_Line(To_String(trash));
               trash := To_Unbounded_String("");
            elsif ch = '*' then      -- Comment: /* */
               loop
                  Get(in_file, ch);
                  if ch = '*' then
                     Get(in_file, ch);
                     if ch = '/' then
                        exit;
                     end if;
                  end if;
               end loop;
            else                            -- ch = '/' for other things (not a comment)
               temp := temp & ch; 
            end if;
         end if;
         if ch not in  '{'|'}'|'('|')'|'['|']'|'.'|','|':'|'+'|'-'|'/'|'*'|'&'|'|'|'<'|'>'|'='|'~' then  
            if ch in '&'|'|'|'<'|'>'|'=' then
               temp := To_Unbounded_String(Convert_Symbol(To_String(temp)));
               -- Temp = correct version of the symbol ? 
               -- MIGHT not need this
            end if;
            -- No more numbers -> the integerConstant is finished
            temp_type := To_Unbounded_String("symbol");  -- Set to the appropriate type ! :>
            return ch;
         end if;
         temp := temp & ch;  -- First: temp = ch, then everything after will be added to it 
         Get(in_file, ch);
      end loop;
      -- In the case of this being the last word:
      temp_type := To_Unbounded_String("symbol");  -- Set to the appropriate type ! :>
      return ch;
   end q4_symbols;
   --# Q5 - String Constants: 
   -- All strings 
   procedure q5_string_constants is
      ch: Character;
   begin
      while not End_Of_File(in_file) loop
         Get(in_file, ch);
         if ch = ''' then  
            -- No more numbers -> the integerConstant is finished
            temp_type := To_Unbounded_String("stringConstant");  -- Set to the appropriate type ! :>
         end if; 
         temp := temp & ch;
      end loop;
      --  temp_type := 'stringConstant';
   end q5_string_constants;
   --# Writes to the xxxT.xml file the appropriate tags:
   -- elem: The name of the tag
   -- word: The content between the opening and closing tags
   procedure switch_write_tag (elem:String; word: String) is
   begin
      if elem = "keyword" then
         Put_Line(File => o_file, Item => "<keyword> " & word & " </keyword>");
      elsif elem = "symbol" then
         Put_Line(File => o_file, Item => "<symbol> " & convert_symbol(word) & " </symbol>");
      elsif elem = "integerConstant" then
         Put_Line(File => o_file, Item => "<integerConstant> " & word & " </integerConstant>");
      elsif elem = "stringConstant" then
         Put_Line(File => o_file, Item => "<stringConstant> " & word & " </stringConstant>");
      elsif elem = "identifier" then
         Put_Line(File => o_file, Item => "<identifier> " & word & " </identifier>");
      else 
            null;
      end if;   
   end switch_write_tag;
   --# Converts a string that symbolizes a single character (not including '<=' etc)
   -- into their corresponding text representations:
   function Convert_Symbol(sym: String) return String is
   begin
      if sym = "<" then
         return "&lt;";
      elsif sym = ">" then
         return "&gt;";
      elsif sym(sym'First) = '"' then  -- we know that 'sym' is a symbol => won't be larger than 1 in the case of ' " '
         return "&quot;";
      elsif sym = "&" then 
         return "&amp;";
      end if;
      return "";
   end Convert_Symbol;
   
   

end Tokenizer;
