with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Utils; use Utils;
with Ada.Directories; use Ada.Directories;
with Ada.Characters.Conversions; use Ada.Characters.Conversions;
with SymbolTable; use SymbolTable;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

package body Code_Generation is

   --# Creates & Opens output file (xxx.xml):
   procedure init_analyzer (filename: Unbounded_String) is
      -- The name of the current file we wish to *READ* from:
      name: Unbounded_String := To_Unbounded_String(
                                                    To_String(filename)
                                                    (To_String(filename)'First..find_char_index(To_String(filename), '.')  - 2)
                                                   );
   begin
      -- 1.1. create file where filename = name & '.vm' for WRITING:
      sym_tbl_name := To_Unbounded_String(To_String(name) & "_symbol_table.txt");
      xml_file_name := name & ".vm";
      Create(File => curr_xml_file, Mode => Out_File, Name => Current_Directory & '\' & To_String(name) & ".vm");
      Close(curr_vm_file);
      -- 1.2 & 1.3 will be closed at the end of this procedure !
      -- 1.2. open the 'T.xml' file for READING:
      Open(File => curr_xml_file, Mode => In_File, Name => To_String(filename));
      -- 1.3. open xxx.vm for WRITING:
      Open(File => curr_vm_file, Mode => Out_File, Name => To_String(name) & ".vm");

      SymbolTable.Constructor(name); -- Create A SYMBOL TABLE for our current xml file
      Open(File => out_sym_tbl, Mode => Out_File, Name => To_String(name) & "_symbol_table.txt");
      Put_Line(File => out_sym_tbl, Item => "<class-scope>");

      Put_Line(Get_Line(File => curr_xml_file)); -- <tokens>
      parse_class;
      Put_Line(Get_Line(File => curr_xml_file)); -- </tokens>
      
      -- End all execution:
      Close(curr_vm_file);
      Close(curr_xml_file);
   end init_analyzer;
   --# PROGRAM STRUCTURE:
   procedure parse_class is
      temp : Unbounded_String := To_Unbounded_String("");
   begin
      Put_Line(File => curr_vm_file, Item => "<class>"); -- Wrapper Tag
      --  while not End_Of_File(curr_xml_file) loop
      temp := To_Unbounded_String(Get_Line(File => curr_xml_file)); -- Get first line (is keyword - class)  
      --# <keyword> class </keyword>
      Put_Line(To_String(temp));
      if To_String(temp) = "<keyword> class </keyword>" then -- must conform to the following structure
         -- 1. 'class' keyword:
         Put_Line(File => curr_vm_file, Item => To_String(temp));
         -- 2. Get Class NAME:
         temp := To_Unbounded_String(Get_Line(File => curr_xml_file));  -- will get the function name 
         curr_class_name := temp;
         --# <identifier> className </identifier>
         Put_Line(To_String(temp));
         Put_Line(File => curr_vm_file, Item => To_String(temp));         
         -- 3. Open Class Definitions: '{' :
         temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
         --# <symbol> { </symbol>
         Put_Line(To_String(temp));
         Put_Line(File => curr_vm_file, Item => To_String(temp));
         -- 4. Call classVarDec :  For all fields that belong to the class:

         -- LOOP: needs to be in a loop:
         -- while Get_Line in { static | field }
         temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
         --#  <keyword> static | field </keyword>
         while  To_String(temp) in  "<keyword> static </keyword>" | "<keyword> field </keyword>" loop   
            Put_Line(To_String(temp));
            parse_classVarDec(temp);  -- Will be called only if not empty
            temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
            --#  <keyword> static | field </keyword>  ||  <keyword> function | constructor | method </keyword>
         end loop;
         -- 5. call subroutines : 
         --# <keyword> function | constructor | method </keyword>
         while To_String(temp) in "<keyword> constructor </keyword>" | "<keyword> function </keyword>"
           | "<keyword> method </keyword>" loop
            SymbolTable.startSubroutine;
            parse_subroutineDec(temp);
            temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
            --# <keyword> function | constructor | method </keyword>  ||  <symbol> } </symbol>
            Put_Line(To_String(temp));
         end loop;
        
         --# <symbol> } </symbol>  =>  end of class
         if To_String(temp) = "<symbol> } </symbol>" then
            Put_Line(File => curr_vm_file, Item => To_String(temp));
         end if;
         Put_Line(File => curr_vm_file, Item => "</class>");
      end if;
   end parse_class;
   
   procedure parse_classVarDec (t: Unbounded_String) is
      temp : Unbounded_String := t;
      var_name : Unbounded_String := To_Unbounded_String("");
      var_type : Unbounded_String := To_Unbounded_String("");
      kind : Unbounded_String := To_Unbounded_String("");
   begin  
      --# <keyword> static | field </keyword>  =>  printed to file 
      --  temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
      if To_String(temp) in "<keyword> static </keyword>" | "<keyword> field </keyword>" then
         Put_Line(File => curr_vm_file, Item => "<classVarDec>");
         -- field | static
         if To_String(temp) = "<keyword> static </keyword>" then
            kind := To_Unbounded_String("STATIC");
         elsif To_String(temp) = "<keyword> field </keyword>" then
            kind := To_Unbounded_String("FIELD");
         end if;
         var_type := parse_type(To_Unbounded_String(""));
         -- next comes the <identifier> tag:
         temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
         --# <identifer> varName </identifer>
         Put_Line(To_String(temp));
         var_name := Utils.split_string(To_String(temp))(2);
         -- <symbol> tag == ','
         temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
         --# <symbol> , </symbol>
         Put_Line(To_String(temp));

         SymbolTable.define(var_name, var_type, kind);
         while To_String(temp) = "<symbol> , </symbol>" loop
            -- NEXT <identifier> tag [ another field in the same line ]
            temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
            var_name := Utils.split_string(To_String(temp))(2);
            --# <identifer> varName </identifer>
            Put_Line(To_String(temp));
            SymbolTable.define(var_name, var_type, kind);
            -- Get next symbol to see if it's another ',':
            temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
            --# <symbol> , </symbol> || --# <symbol> ; </symbol>
            Put_Line(To_String(temp));
         end loop;
         if To_String(temp) = "<symbol> ; </symbol>" then
            Put_Line("end of classVarDec: " & To_String(temp));
            --  Put_Line(File => curr_vm_file, Item => To_String(temp));
         end if;
         Put_Line(File => curr_vm_file, Item => "</classVarDec>");
      else
         Put_Line(File => curr_vm_file, Item => To_String(temp));
      end if;
      -- End of class-scope:
      Put_Line(File => out_sym_tbl, Item => "</class-scope>"); 
      Close(out_sym_tbl);
   end parse_classVarDec;

   function parse_type (t: Unbounded_String) return Unbounded_String is
      temp : Unbounded_String := t;
   begin
      if To_String(temp) = "" then 
         temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
         --#  <keyword> int | char | boolean </keyword> 
         --# || <identifer> className </identifer> 
         Put_Line(To_String(temp));
      end if;
      return Utils.split_string(To_String(temp))(2);  -- return the actual type
   end parse_type;
   
   procedure parse_subroutineDec (t: Unbounded_String) is
      temp : Unbounded_String := t;
      var_name : Unbounded_String := To_Unbounded_String("");
      var_type : Unbounded_String := To_Unbounded_String("");
      kind : Unbounded_String := To_Unbounded_String("");
      is_void : Boolean := False;
   begin   
--# Loop over the next section - parameter list and local vars. Save all the information to first line of method scope:
      declare
         helper_str : Unbounded_String := To_Unbounded_String("");
         -- Func helper vars:
         func_type : Unbounded_String := To_Unbounded_String("");
         func_name : Unbounded_String := To_Unbounded_String("");
         -- Counters:
         func_params : Unbounded_String := To_Unbounded_String("");
         func_locals : Unbounded_String := To_Unbounded_String("");
         -- For Symbol Table Method-Scope header:
         func_info : Unbounded_String := To_Unbounded_String("");
      begin
         -- outputs the first tag (constructor | function | method)
         Put_Line(To_String(helper_str));
         helper_str := To_Unbounded_String(Get_Line(File => curr_xml_file));
         --# <keyword> void </keyword>  ||  parse_type(helper_str)
         Put_Line(To_String(helper_str));
         if To_String(helper_str) /= "<keyword> void </keyword>" then
            func_type := parse_type(helper_str);
            func_info := func_info & func_type & " ";
         else
            is_void := True;
            func_info := func_info & "void ";
         end if;
         -- subroutineName:
         helper_str := To_Unbounded_String(Get_Line(File => curr_xml_file));
         curr_func_name := Utils.split_string(To_String(helper_str))(2);
         func_info := func_info & curr_class_name & "." & To_String(curr_func_name);
         --# <identifier> subroutineName </identifier>
         Put_Line(To_String(helper_str));
         -- parameterList:
         helper_str := To_Unbounded_String(Get_Line(File => curr_xml_file));
         --# <symbol> ( </symbol>
         Put_Line(To_String(helper_str));
         --  if To_String(helper_str) = "<symbol> ( </symbol>" then
         --  Put_Line(File => curr_vm_file, Item => "<parameterList>");
--# PARAMETER LIST COUNT:
         helper_str := To_Unbounded_String(Get_Line(File => curr_xml_file));
         --# parse_type  ||  <symbol> ) </symbol>
         Put_Line(To_String(helper_str));
         if To_String(helper_str) /= "<symbol> ) </symbol>" then  -- indicates that there are no parameters
            helper_str := parse_type(helper_str);
            -- varNsme:
            helper_str := To_Unbounded_String(Get_Line(File => curr_xml_file));
            --# <identifier> varName </identifier>
            count_args := count_args + 1;

            Put_Line(To_String(helper_str));
            helper_str := To_Unbounded_String(Get_Line(File => curr_xml_file));
            --# <symbol> ) | , </symbol>
            Put_Line(To_String(helper_str));
            while To_String(helper_str) = "<symbol> , </symbol>" loop
               -- type:
               helper_str := To_Unbounded_String(Get_Line(File => curr_xml_file));
               --# <symbol> , </symbol>
               Put_Line(To_String(helper_str));
               -- varName:
               helper_str := To_Unbounded_String(Get_Line(File => curr_xml_file));  -- will end when this equals to '{'
               count_args := count_args + 1;

               Put_Line(To_String(helper_str));
               helper_str := To_Unbounded_String(Get_Line(File => curr_xml_file));
            end loop;
         end if;
         -- ')' == when parameterList stops executing ! ! ! !
         -- helper_str in parse_parameterList == ')' at the end of the run
         func_info := func_info & count_args'Image;
--# COUNT # LOCAL VARS:
         helper_str := To_Unbounded_String(Get_Line(File => curr_xml_file));
         --# <symbol> { </symbol>
         Put_Line(To_String(helper_str));
         helper_str := To_Unbounded_String(Get_Line(File => curr_xml_file));
         --# <keyword> var </keyword>  ||  statements
         Put_Line(To_String(helper_str));
         while To_String(helper_str) = "<keyword> var </keyword>" loop
            -- var:
            --  parse_varDec;
--# VARDEC:
           --  Put_Line(File => curr_vm_file, Item => "<varDec>");
-- type:
            helper_str := To_Unbounded_String(Get_Line(File => curr_xml_file));
            --# parse_type(temp):
            Put_Line(To_String(helper_str));
            helper_str := parse_type(helper_str);
            -- varName:
            helper_str := To_Unbounded_String(Get_Line(File => curr_xml_file));
            --# <identifier> varName </identifier>
            count_locals := count_locals + 1;

            Put_Line(To_String(helper_str));
            helper_str := To_Unbounded_String(Get_Line(File => curr_xml_file));
            --# <symbol> ;  ||  , </symbol>
            Put_Line(To_String(helper_str));
            while To_String(helper_str) = "<symbol> , </symbol>" loop
               -- ',' :
               count_locals := count_locals + 1;
               -- varName:
               helper_str := To_Unbounded_String(Get_Line(File => curr_xml_file));
               --# <identifier> varName </identifier>
               Put_Line(To_String(helper_str));
               -- check next token:
               helper_str := To_Unbounded_String(Get_Line(File => curr_xml_file));
               --# <symbol> ;  ||  , </symbol>
               Put_Line(To_String(helper_str));
            end loop;
            -- last temp will be equal to ';' : 
            --  Put_Line(File => curr_vm_file, Item => "</varDec>");

            helper_str := To_Unbounded_String(Get_Line(File => curr_xml_file));
            --# <keyword> var </keyword>  ||  statements
            Put_Line(To_String(helper_str));
         end loop;   
         func_info := func_info & count_locals'Image;
         
         Open(File => out_sym_tbl, Mode => Append_File, Name => sym_tbl_name);
         Put_Line(File => out_sym_tbl, Item => "<method-scope> " & To_String(func_info));
         Close(out_sym_tbl);
         Put_Line(File => curr_vm_file, Item => "function" & curr_class_name & "." 
                  & curr_func_name & " " &  Integer'Image (count_locals) (2 .. count_locals'Image'Length));
         count_args := 0;
         count_locals := 0;
      end;
      
      Open(File => curr_xml_file, Mode => In_File, Name => xml_file_name);
      while stop_line /= 0 loop
         temp := To_unbounded_String(Get_Line(File => curr_xml_file));
         stop_line := stop_line - 1;
      end loop;
      -- outputs the first tag (constructor | function | method)
      Put_Line(To_String(temp));
      if To_String(temp) = "<keyword> method </keyword>" then
         SymbolTable.define(To_Unbounded_String("this"), curr_class_name, To_Unbounded_String("ARG"));
      --  elsif To_String(temp) in "<keyword> function </keyword>" | "<keyword> constructor </keyword>" then
      end if;
      
      temp := To_Unbounded_String(Get_Line(File => curr_xml_file)); 
      --# <keyword> void </keyword>  ||  parse_type(temp)
      Put_Line(To_String(temp));
      if To_String(temp) = "<keyword> void </keyword>" then
         is_void := True;
      end if;
      -- subroutineName:
      temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
      --# <identifier> subroutineName </identifier>
      Put_Line(To_String(temp));

      -- parameterList:
      temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
      --# <symbol> ( </symbol>
      Put_Line(To_String(temp));
      parse_parameterList;
      -- ')' == when parameterList stops executing ! ! ! !
      -- temp in parse_parameterList == ')' at the end of the run:
      -- subroutineBody:
      parse_subroutineBody;
      --  end if;
      Put_Line(File => curr_vm_file, Item => "</subroutineDec>");
      null;
   end parse_subroutineDec;
   
   procedure parse_parameterList is
      temp: Unbounded_String := To_Unbounded_String("");
      var_name : Unbounded_String := To_Unbounded_String("");
      var_type : Unbounded_String := To_Unbounded_String("");
      kind : Unbounded_String := To_Unbounded_String("");
   begin
      Put_Line(File => curr_vm_file, Item => "<parameterList>");
      temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
      --# parse_type  ||  <symbol> ) </symbol>
      Put_Line(To_String(temp));
      if To_String(temp) /= "<symbol> ) </symbol>" then  -- indicates that there are no parameters
         var_type := parse_type(temp);
         -- varNsme:
         temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
         var_name := temp;
         --# <identifier> varName </identifier>
         SymbolTable.define(var_name, var_type, To_Unbounded_String("ARG"));

         Put_Line(To_String(temp));
         temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
         --# <symbol> ) | , </symbol>
         Put_Line(To_String(temp));
         while To_String(temp) = "<symbol> , </symbol>" loop
            -- type:
            temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
            --# <symbol> , </symbol>
            Put_Line(To_String(temp));
            var_type := parse_type(temp);
            -- varName:
            temp := To_Unbounded_String(Get_Line(File => curr_xml_file));  -- will end when this equals to '{'
            var_name := temp;
            --# <identifier> varName </identifier>
            SymbolTable.define(var_name, var_type, To_Unbounded_String("ARG"));

            Put_Line(To_String(temp));
            temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
         end loop;
      end if;
      Put_Line(File => curr_vm_file, Item => "</parameterList>");
      null;
   end parse_parameterList;
   
   procedure parse_subroutineBody is
      temp : Unbounded_String := To_Unbounded_String("");
   begin
      Put_Line(File => curr_vm_file, Item => "<subroutineBody>");
      temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
      --# <symbol> { </symbol>
      Put_Line(To_String(temp));
      temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
      --# <keyword> var </keyword>  ||  statements
      Put_Line(To_String(temp));
      while To_String(temp) = "<keyword> var </keyword>" loop
         -- var:
         parse_varDec;  
         temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
         --# <keyword> var </keyword>  ||  statements
         Put_Line(To_String(temp));
      end loop;   
      Put_Line(File => out_sym_tbl, Item => "</method-scope>");
      Close(out_sym_tbl);
      
      --# Loop over Method-Scope, and count how many local variables it contains:
      Open(File => out_sym_tbl, Mode => In_File, Name => To_String(sym_tbl_name));
      while not End_Of_File(out_sym_tbl) and To_String(temp) /= "</class-scope>" loop  -- skip class-scope
         temp := To_Unbounded_String(Get_Line(File => out_sym_tbl));
      end loop;
      while not End_Of_File(out_sym_tbl) and To_String(temp) /= "</method-scope>" loop  -- count inside method-scope
         temp := To_Unbounded_String(Get_Line(File => out_sym_tbl));
         if To_String(temp) /= "<" then
            if To_String(SymbolTable.kindOf(temp)) = "VAR" then
               count_locals := count_locals + 1;
            end if;
         end if;
      end loop;
      Close(out_sym_tbl);
      -- Until NOW we entered into the symbol table all the parameters and local vars in method-scope
      Put_Line(File => curr_vm_file, Item => "function" & To_String(curr_class_name) & "." & To_String(curr_func_name) & count_locals'Image);
      -- statements:       
      -- send temp to the procedure so that w e can check which type of statement it is
      temp := parse_statements(temp);
      --  Put_Line(File => curr_vm_file, Item => "<symbol> } </symbol>");
      Put_Line(File => curr_vm_file, Item => "</subroutineBody>");
   end parse_subroutineBody;
   
   procedure parse_varDec is
      temp : Unbounded_String := To_Unbounded_String("");
      var_name : Unbounded_String := To_Unbounded_String("");
      var_type : Unbounded_String := To_Unbounded_String("");
      kind : Unbounded_String := To_Unbounded_String("");
   begin
      Put_Line(File => curr_vm_file, Item => "<varDec>");
      -- type:
      temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
      --# parse_type(temp):
      Put_Line(To_String(temp));
      var_type := parse_type(temp);
      -- varName:
      temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
      var_name := temp;
      --# <identifier> varName </identifier>
      SymbolTable.define(var_name, var_type, To_Unbounded_String("VAR"));
      Put_Line(To_String(temp));
      temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
      --# <symbol> ;  ||  , </symbol>
      Put_Line(To_String(temp));
      while To_String(temp) = "<symbol> , </symbol>" loop
         -- ',' :
         -- varName:
         temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
         var_name := temp;
         --# <identifier> varName </identifier>
         Put_Line(To_String(temp));
         SymbolTable.define(var_name, var_type, To_Unbounded_String("VAR"));
         -- check next token:
         temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
         --# <symbol> ;  ||  , </symbol>
         Put_Line(To_String(temp));
      end loop;
      -- last temp will be equal to ';' : 
      --  Put_Line(File => curr_vm_file, Item => "<symbol> ; </symbol>");
      Put_Line(File => curr_vm_file, Item => "</varDec>");
   end parse_varDec;
   
   --# STATEMENTS:
   function parse_statements (t: Unbounded_String) return Unbounded_String is
      temp : Unbounded_String := t;
   begin
      Put_Line(File => curr_vm_file, Item => "<statements>");
      while To_String(temp) /= "<symbol> } </symbol>" loop
         -- breakdown the statement
         -- statement procedure will return the first token in the next statement
         temp := parse_statement(temp);
         Put_Line(To_String(temp));
      end loop;
      --  Put_Line(File => curr_vm_file, Item => "<symbol> } <symbol>");
      -- ^ happens in the above level
      Put_Line(File => curr_vm_file, Item => "</statements>");
      return temp;
   end parse_statements;
   
   function parse_statement (t: Unbounded_String) return Unbounded_String is
      temp : Unbounded_String := t;
   begin
      --  Put_Line(File => curr_vm_file, Item => "<statement>");

      if To_String(temp) = "<keyword> let </keyword>" then
         temp := parse_letStatement(temp);
         Put_Line(To_String(temp));
      elsif To_String(temp) = "<keyword> if </keyword>" then
         temp := parse_ifStatement(temp);
         Put_Line(To_String(temp));
      elsif To_String(temp) = "<keyword> while </keyword>" then
         temp := parse_whileStatement(temp);
         Put_Line(To_String(temp));
      elsif To_String(temp) = "<keyword> do </keyword>" then
         temp := parse_doStatement(temp);
         Put_Line(To_String(temp));
      elsif To_String(temp) = "<keyword> return </keyword>" then
         temp := parse_returnStatement(temp);
         Put_Line(To_String(temp));
      end if;
      -- temp == START of next statement
      --  Put_Line(File => curr_vm_file, Item => "</statement>");
      return temp;
   end parse_statement;
   
   function parse_letStatement (t: Unbounded_String) return Unbounded_String is
      temp : Unbounded_String := t;
      varName : Unbounded_String := To_Unbounded_String("");
      segment : Unbounded_String := To_Unbounded_String("");
      index_of : Integer;
   begin
      Put_Line(File => curr_vm_file, Item => "<letStatement>");
      -- let keyword:
      -- varName:
      temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
      varName := temp;
      --# <identifier> varName </identifier>
      Put_Line(To_String(temp));
      
      --# TODO: Have the functions accept 2 params, 1 being the current function name:
      segment := SymbolTable.kindOf(varName);
      --  if To_String(segment) = "STATIC" then
      if To_String(segment) = "VAR" then
         segment := To_Unbounded_String("local");
      elsif To_String(segment) = "ARG" then
         segment := To_Unbounded_String("argument");
      elsif To_String(segment) = "FIELD" then
         segment := To_Unbounded_String("this");
      end if;      
      index_of := SymbolTable.indexOf(varName);

      temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
      --# <symbol> [  |  = </symbol> 
      Put_Line(To_String(temp));
      if To_String(temp) = "<symbol> [ </symbol>" then
         temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
         temp := parse_expression(temp); -- temp == next token == ] (by the end of this procedure)
         temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
      end if;
      if To_String(temp) = "<symbol> = </symbol>" then      
         temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
         temp := parse_expression(temp);
      end if;
      -- Final commands:
      Put_Line(File => curr_vm_file, Item => "pop " & To_String(segment) & " " & Integer'Image (index_of) (2 .. index_of'Image'Length));
      Put_Line(File => curr_vm_file, Item => "push " & To_String(segment) & " " &  Integer'Image (index_of) (2 .. index_of'Image'Length));
      Put_Line(File => curr_vm_file, Item => "</letStatement>");
      -- temp == NEXT token:
      -- so that we can check if the next token in '}' 
      temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
      Put_Line(To_String(temp));
      return temp;
   end parse_letStatement;
   
   function parse_ifStatement (t: Unbounded_String) return Unbounded_String is 
      temp : Unbounded_String := t;
   begin
      Put_Line(File => curr_vm_file, Item => "<ifStatement>");
      -- if keyword:
      -- '(' :
      temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
      Put_Line(To_String(temp));
      --  Put_Line(File => curr_vm_file, Item => "<symbol> ( </symbol>");
      temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
      temp := parse_expression(temp);      
      Put_Line(File => curr_vm_file, Item => "if-goto IF_TRUE" & Integer'Image (count_if) (2 .. count_if'Image'Length));
      Put_Line(File => curr_vm_file, Item => "goto IF_FALSE" & Integer'Image (count_if) (2 .. count_if'Image'Length));
      Put_Line(File => curr_vm_file, Item => "label IF_TRUE" & Integer'Image (count_if) (2 .. count_if'Image'Length));
      --  Put_Line(File => curr_vm_file, Item => "<symbol> ) </symbol>");
      -- { :
      temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
      Put_Line(To_String(temp));
      --  Put_Line(File => curr_vm_file, Item => "<symbol> { </symbol>");
      -- statements:
      temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
      Put_Line(To_String(temp));
      temp := parse_statements(temp);
      Put_Line(File => curr_vm_file, Item => "goto IF_END" & Integer'Image (count_if) (2 .. count_if'Image'Length));
      Put_Line(File => curr_vm_file, Item => "label IF_FALSE" & Integer'Image (count_if) (2 .. count_if'Image'Length));
      -- else || next line ? :
      temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
      Put_Line(To_String(temp));
      if To_String(temp) = "<keyword> else </keyword>" then
         -- else keyword:
         --  Put_Line(File => curr_vm_file, Item => To_String(temp));
         -- statements:
         temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
         Put_Line(To_String(temp));
         --  Put_Line(File => curr_vm_file, Item => "<symbol> { </symbol>");

         temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
         temp := parse_statements(temp);
         -- } - closer;
         Put_Line(To_String(temp));
         --  Put_Line(File => curr_vm_file, Item => "<symbol> } </symbol>");
      else
         Put_Line(File => curr_vm_file, Item => "</ifStatement>");
         return temp;
      end if;
      Put_Line(File => curr_vm_file, Item => "label IF_END" & Integer'Image (count_if) (2 .. count_if'Image'Length));
      count_if := count_if + 1;

      temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
      Put_Line(To_String(temp));
      Put_Line(File => curr_vm_file, Item => "</ifStatement>");
      return temp;
   end parse_ifStatement;
   
   function parse_whileStatement (t: Unbounded_String) return Unbounded_String is
      temp : Unbounded_String := t;
   begin
      Put_Line(File => curr_vm_file, Item => "<whileStatement>");
      -- while keyword:
      Put_Line(File => curr_vm_file, Item => "label WHILE_EXP" & Integer'Image (count_before_while) (2 .. count_before_while'Image'Length));
      -- '(' expression ')' :
      temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
      Put_Line(To_String(temp));
      -- expression:
      temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
      temp := parse_expression(temp);
      
      Put_Line(To_String(temp));
      Put_Line(File => curr_vm_file, Item => "not");
      Put_Line(File => curr_vm_file, Item => "if-goto WHILE_END" & Integer'Image (count_before_while) (2 .. count_before_while'Image'Length));

      -- '{' statements '}' :
      temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
      Put_Line(To_String(temp));
      -- statements:
      temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
      Put_Line(To_String(temp));
      temp := parse_statements(temp);
      Put_Line(To_String(temp));
      Put_Line(File => curr_vm_file, Item => "goto WHILE_EXP" & Integer'Image (count_before_while) (2 .. count_before_while'Image'Length));
      Put_Line(File => curr_vm_file, Item => "label WHILE_END" & Integer'Image (count_before_while) (2 .. count_before_while'Image'Length));

      Put_Line(File => curr_vm_file, Item => "</whileStatement>");

      -- temp == NEXT token:
      temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
      Put_Line(To_String(temp));
      return temp;
   end parse_whileStatement;
   
   function parse_doStatement (t: Unbounded_String) return Unbounded_String is
      temp: Unbounded_String := t;
   begin
      Put_Line(File => curr_vm_file, Item => "<doStatement>");

      --  Put_Line(File => curr_vm_file, Item => "<keyword> do </keyword>");
      temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
      temp := parse_subroutineCall(temp);
      
      Put_Line(To_String(temp));
      --  Put_Line(File => curr_vm_file, Item => "<symbol> ; </symbol>");

      Put_Line(File => curr_vm_file, Item => "</doStatement>");
      Put_Line(File => curr_vm_file, Item => "pop temp 0");

      temp := To_Unbounded_String(Get_Line(File => curr_xml_file)); -- for wrapping level to know if it can exit
      Put_Line(To_String(temp));
      return temp;
   end parse_doStatement;
   
   function parse_returnStatement (t: Unbounded_String) return Unbounded_String is
      temp : Unbounded_String := t;
   begin
      Put_Line(File => curr_vm_file, Item => "<returnStatement>");
      -- return
      Put_Line(File => curr_vm_file, Item => "<keyword> return </keyword>");
      -- expression
      temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
      if To_String(temp) /= "<symbol> ; </symbol>" then
         temp := parse_expression(temp);
      end if;
      -- end line - ; symbol:
      Put_Line(File => curr_vm_file, Item => "<symbol> ; </symbol>");
      Put_Line(File => curr_vm_file, Item => "</returnStatement>");
      -- temp == NEXT token:
      temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
      Put_Line(To_String(temp));
      return temp;
   end parse_returnStatement;
   
   --# EXPRESSIONS:
   function parse_expression (t : Unbounded_String := To_Unbounded_String("")) return Unbounded_String is
      temp : Unbounded_String := t;
      op : Unbounded_String := To_Unbounded_String("");
   begin
      Put_Line(File => curr_vm_file, Item => "<expression>");
      --# first line in term
      temp := parse_term(temp);

      while To_String(temp) in "<symbol> + </symbol>" | "<symbol> - </symbol>" | "<symbol> * </symbol>"
        | "<symbol> / </symbol>" | "<symbol> &amp; </symbol>" | "<symbol> | </symbol>" | "<symbol> &lt; </symbol>" 
          | "<symbol> &gt; </symbol>" | "<symbol> = </symbol>" loop
         op := Utils.split_string(To_String(temp))(2); 
         temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
         Put_Line(To_String(temp));
         temp := parse_term(temp);
         Put_Line(File => curr_vm_file, Item => To_String(convert_expression_ops(op)));
         Put_Line(To_String(temp));
      end loop;
      Put_Line(File => curr_vm_file, Item => "</expression>");
      return temp;
   end parse_expression;
   
   function parse_term (t: Unbounded_String  := To_Unbounded_String("")) return Unbounded_String is
      temp : Unbounded_String := t;
   begin
      Put_Line(File => curr_vm_file, Item => "<term>");
      -- integerConstant:
      if To_String(temp)(1..17) = "<integerConstant>" then
         temp := Utils.split_string(To_String(temp))(2);
         Put_Line(File => curr_vm_file, Item => "push constant " & To_String(temp));
         -- stringConstant:
      elsif To_String(temp)(1..16) = "<stringConstant>" then
         declare
            helper : Utils.String_Array := Utils.split_string(To_String(temp));
            result : Unbounded_String := To_Unbounded_String("");
            curr_char : Character;
            ascii_val : Integer := 0;
         begin
            --  helper := ;
            for i in helper'Range loop
               if i /= helper'Length and i /= 1 then
                  temp := To_Unbounded_String(To_String(temp) & To_String(helper(i)) & " ");
               end if;
            end loop;
            Put_Line(File => curr_vm_file, Item => "push constant" & To_String(t)'Length'Image);
            Put_Line(File => curr_vm_file, Item => "call String.new 1");
            for i in To_String(temp)'Range loop
               ascii_val := Character'Pos(To_String(temp)(i));
               Put_Line(File => curr_vm_file, Item => "push constant" & ascii_val'Image);
               Put_Line(File => curr_vm_file, Item => "call String.appendChar 2");
            end loop;
         end;
         -- keywordConstant == { true, false, null, this }:  
      elsif To_String(temp) in "<keyword> true </keyword>" | "<keyword> false </keyword>" 
        | "<keyword> null </keyword>" | "<keyword> this </keyword>" then
         if To_String(temp) in "<keyword> false </keyword>" | "<keyword> null </keyword>" then
            Put_Line(File => curr_vm_file, Item => "push constant 0");
         elsif To_String(temp) = "<keyword> true </keyword>" then
            Put_Line(File => curr_vm_file, Item => "push constant 0");
            Put_Line(File => curr_vm_file, Item => "not");
         elsif To_String(temp) = "<keyword> this </keyword>" then
            Put_Line(File => curr_vm_file, Item => "push pointer 0");
         end if;
         -- varName:  OR  subroutineCall:
      elsif To_String(temp)(1..12) = "<identifier>" then
         --  Put_Line(File => curr_vm_file, Item => To_String(temp));
         temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
         --# <symbol> [  |  (  |  . </symbol>
         Put_Line(To_String(temp));
         -- varName '[' expression ']':
         if To_String(temp) = "<symbol> [ </symbol>" then
            Put_Line(File => curr_vm_file, Item => To_String(temp));
            temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
            temp := parse_expression(temp);
            --  temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
            --# <symbol> ] </symbol>
            Put_Line(To_String(temp));
            Put_Line(File => curr_vm_file, Item => "<symbol> ] </symbol>");
            -- subroutineCall -> subroutineName '(' expressionList ')' :
         elsif To_String(temp) = "<symbol> ( </symbol>" then
            Put_Line(File => curr_vm_file, Item => To_String(temp));
            temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
            temp := parse_expressionList(temp);
            --  if To_String(temp) = "<symbol> ) </symbol>" then
            --     temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
            --# <symbol> ) </symbol>
            Put_Line(To_String(temp));
            Put_Line(File => curr_vm_file, Item => "<symbol> ) </symbol>");
            --  end if;
            -- subroutineCall -> (className | varName) '.' subroutineName '(' expressionList ')' :
         elsif To_String(temp) = "<symbol> . </symbol>" then
            Put_Line(File => curr_vm_file, Item => To_String(temp));
            -- subroutineName:
            temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
            --# <identifier> subroutineName </identifier>
            Put_Line(To_String(temp));
            Put_Line(File => curr_vm_file, Item => To_String(temp));
            -- ( expressionList ):
            temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
            Put_Line(To_String(temp));
            Put_Line(File => curr_vm_file, Item => "<symbol> ( </symbol>");
            temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
            temp := parse_expressionList(temp);

            Put_Line(File => curr_vm_file, Item => "<symbol> ) </symbol>");
         else
            Put_Line(File => curr_vm_file, Item => "</term>");
            return temp;
         end if;
         -- '(' expression ')' :
      elsif To_String(temp) = "<symbol> ( </symbol>" then
         Put_Line(File => curr_vm_file, Item => To_String(temp));
         -- expression:
         temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
         temp := parse_expression(temp);
         Put_Line(To_String(temp));
         --  return temp;
      elsif To_String(temp) in "<symbol> - </symbol>" | "<symbol> ~ </symbol>" then
         declare
            op : Unbounded_String := Utils.split_string(To_String(temp))(2);
         begin
            temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
            Put_Line(To_String(temp));
            temp := parse_term(temp);  -- is already the next line ! we don't need to read more after this
            if To_String(op) = "-" then
               Put_Line(File => curr_vm_file, Item => "neg");
            elsif To_String(op) = "~" then
               Put_Line(File => curr_vm_file,  Item => "not");
            end if;
            Put_Line(To_String(temp));
            Put_Line(File => curr_vm_file, Item => "</term>");
            return temp; 
         end;
      else -- any other op
         return temp;
      end if;
      Put_Line(File => curr_vm_file, Item => "</term>");
      -- Get Next Line - right after the term ! :
      temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
      Put_Line(To_String(temp));
      return temp;
   end parse_term;

   function parse_subroutineCall (t : Unbounded_String := To_Unbounded_String("")) return Unbounded_String is
      temp : Unbounded_String := t;
      name : Unbounded_String := To_Unbounded_String("");
      result : Unbounded_String := To_Unbounded_String("");
   begin
      -- subroutineName | className | varName:
      name := Utils.split_string(To_String(temp))(2); -- the name
      Put_Line(To_String(temp));

      temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
      Put_Line(To_String(temp));
      -- subroutineCall -> subroutineName '(' expressionList ')' :
      if To_String(temp) = "<symbol> ( </symbol>" then -- not a built in method usually 
         result := To_Unbounded_String(To_String(curr_class_name) & "." & To_String(name)); -- className.subroutineName 
         result := To_unbounded_String(To_String(result) & " " & SymbolTable.varCount(To_Unbounded_String("ARG")));

         Put_Line(To_String(temp));
         temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
         Put_Line(To_String(temp));
         
         temp := parse_expressionList(temp);
         Put_Line(To_String(temp));
         Put_Line(File => curr_vm_file, Item => To_String(result));
         --  Put_Line(File => curr_vm_file, Item => "<symbol> ) </symbol>");
         -- subroutineCall -> (className | varName) '.' subroutineName '(' expressionList ')' :
      elsif To_String(temp) = "<symbol> . </symbol>" then
         result := name; -- save the classname
         -- subroutineName:
         temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
         name := Utils.split_string(To_String(temp))(2); -- extracted subroutine name
         result := To_Unbounded_String(To_String(result) & "." & To_String(name));
         result := To_unbounded_String(To_String(result) & " " & SymbolTable.varCount(To_Unbounded_String("ARG")));
         Put_Line(To_String(temp));
         -- ( expressionList ):
         temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
         Put_Line(To_String(temp));
         temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
         
         temp := parse_expressionList(temp);
         Put_Line(File => curr_vm_file, Item => To_String(result));
      end if;
      temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
      return temp;
   end parse_subroutineCall;

   function parse_expressionList (t: Unbounded_String := To_Unbounded_String("")) return Unbounded_String is
      temp: Unbounded_String := t;
      var_name : Unbounded_String;
      kind : Unbounded_String;
      var_type : Unbounded_String;

   begin
      Put_Line(File => curr_vm_file, Item => "<expressionList>");
      if To_String(temp) /= "<symbol> ) </symbol>" then
         temp := parse_expression(temp);
         Put_Line(To_String(temp));
         while To_String(temp) = "<symbol> , </symbol>" loop
            --  Put_Line(File => curr_vm_file, Item => To_String(temp));
            Put_Line(To_String(temp));
            temp := To_Unbounded_String(Get_Line(File => curr_xml_file));
            temp := parse_expression(temp);
         end loop;
      end if;

      Put_Line(File => curr_vm_file, Item => "</expressionList>");
      return temp;
   end parse_expressionList;

   --# Converters:
   function convert_expression_ops (t : Unbounded_String) return Unbounded_String is
   begin
      if To_String(t) = "+" then
         return To_Unbounded_String("add");
      elsif To_String(t) = "-" then
         return To_Unbounded_String("sub");
      elsif To_String(t) = "*" then
         return To_Unbounded_String("call Math.multiply 2");
      elsif To_String(t) = "/" then
         return To_Unbounded_String("call Math.divide 2");
      elsif To_String(t) = "&amp;" then
         return To_Unbounded_String("and");
      elsif To_String(t) = "|" then
         return To_Unbounded_String("or");
      elsif To_String(t) = "&lt;" then
         return To_Unbounded_String("lt");
      elsif To_String(t) = "&gt;" then
         return To_Unbounded_String("gt");
      elsif To_String(t) = "=" then
         return To_Unbounded_String("eq");
      end if;
      return To_Unbounded_String("");
   end convert_expression_ops;

   
end Code_Generation;
