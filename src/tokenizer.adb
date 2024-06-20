with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
--  with types; use types;

package body Tokenizer is
   o_file: File_Type;

   type symbol is ("{","}","(",")","[","]",".",",",":","+","+","-","/","*","&","|","<",">","=","~");
   type StingConstant is ("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
                          "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z");

   type Token is record
      elem: Unbounded_String;
      val: Unbounded_String;
   end record;
   
   -- creates & opens file for writing ("...T.xml")
   procedure init_vm(filename: Unbounded_String) is
      in_file: File_Type;
      name: Unbounded_String := To_Unbounded_String(if_name(filename'First..find_char_index(filename, '.')  - 1));
   begin
      -- 1. create file filename & "T.xml"
      Create(File => o_file, Mode => Out_File, Name => Current_Directory & "\" & To_String(name) & "T.xml");
      Close(o_file);
      Open(File => in_file, Mode => In_File, Name => filename);

      Open(File => o_file, Mode => Out_File, Name => To_String(name) & "T.xml");
      
      -- 2. write "<tokens>" label as first line
      Put_Line(File => o_file, Item => "<tokens>");
      -- 3. each line must be separated to individual tokens
      while not End_Of_File(f_in) loop
         line := To_Unbounded_String(Get_Line (File => o_file));
         automata(line);
      end loop;
      Put_Line(File => o_file, Item => "</tokens>");
      Close(o_file);
      Close(in_file);
   end init_vm;
   
   procedure automata(line: Unbounded_String) is
      str : String := To_String(line);
      temp: Unbounded_String := To_Unbounded_String("");
   begin
      for i in str'Range loop
         if str(i) in "0"|"1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9" then
            Append(temp, str(i));
         elsif str(i) in "class" | "method" | "field" | "function" | "constructor" | "int" | "boolean" | "char" 
           |"void" | "var" | "static" | "let" | "do" | "if" | "else" | "while" | "return" | "true" | "false" | "null" | "this" then
            if temp /= To_Unbounded_String("") then
               switch_write_tag("integerConstant", temp);
               temp := To_Unbounded_String("");
            end if;
            
         end if;
      end loop;
   end automata;

   procedure parse_tok (Line: Unbounded_String) is
   begin
      -- separate each word
      -- write it to file once done
      null;
   end parse_tok;
   
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
   
   function Convert_Symbol(sym: String) return String is
   begin
      if sym = "<" then
         return "&lt;";
      elsif sym = ">" then
         return "&gt;";
      elsif sym = ('"') then  -- quot
         return "&quot;";
      elsif sym = "&" then 
         return "&amp;";
      elsif sym = "{" then 
         return "&;";
      elsif sym = "}" then 
         return "&;";
      elsif sym = "(" then 
         return "&;";
      elsif sym = ")" then 
         return "&;";
      elsif sym = "[" then 
         return "&;";
      elsif sym = "]" then 
         return "&;";
      elsif sym = "." then 
         return "&;";
      elsif sym = "," then 
         return "&;";
      elsif sym = ";" then 
         return "&;";
      elsif sym = "+" then 
         return "&;";
      elsif sym = "-" then 
         return "&;";
      elsif sym = "*" then 
         return "&;";
      elsif sym = "/" then 
         return "&;";
      elsif sym = "|" then 
         return "&;";
  	elsif sym = "=" then 
         return "&";
      elsif sym = "~" then 
         return "&;";
      else
         null;
      end if;
   end Convert_Symbol;
   
   

end Tokenizer;
