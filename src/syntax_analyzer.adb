with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Utils; use Utils;
with Ada.Directories; use Ada.Directories;
with Ada.Characters.Conversions; use Ada.Characters.Conversions;
-- We'll need to see how to get the actual tokens from the last stage
--# Option 1: 
-- 1) separate everything into tokens again
-- 2) send it to the appropriate 
--# Option 2:
-- 1) read line by line from the T.xml files
-- 2) based on what the type of token is, (and what it contains if needed),
--      we'll send to the next rule
-- 3) When do we return from inside a statement? 
--      When we get to '}' it's the end of the current section !
--# IS THERE ANOTHER constraint ? ? ?
package body Syntax_Analyzer is

   --# Globals:
   in_file: File_Type;
   o_file: File_Type;
   --# Identifiers:
   -- className, subroutineName, varName
   --# Creates & Opens output file (xxx.xml):
   procedure init_analyzer (filename: Unbounded_String) is
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
      Open(File => o_file, Mode => Out_File, Name => To_String(name) & ".xml");
      -- 2. write '<class>' label as first line
      --  Put_Line(File => o_file, Item => "<class>");
      -- 3. each line must be separated to individual tokens
      Put_Line(Get_Line(File => in_file)); -- <tokens>
      parse_class;
      Put_Line(Get_Line(File => in_file)); -- </tokens>
      
      -- End all execution:
      Close(o_file);
      Close(in_file);
   end init_analyzer;
   --# PROGRAM STRUCTURE:
   procedure parse_class is
      temp : Unounded_String := To_Unbounded_String("");
   begin
      Put_Line(File => o_file, Item => "<class>");
      --  while not End_Of_File(in_file) loop
      temp := To_Unbounded_String(Get_Line(File => in_file)); -- Get first line (is keyword - class)
      --  temp := middle_word(temp);  -- NEED TO IMPLEMENT THIS
      if To_String(temp) = "<keyword> class </keyword>"then -- must conform to the following structure
         -- 1. 'class' keyword:
         Put_Line(File => o_file, Item => To_String(temp));
         -- 2. Get Class NAME:
         temp := To_Unbounded_String(Get_Line(File => in_file));  -- will get the function name 
         --  temp := middle_word(temp);
         Put_Line(File => o_file, Item => To_String(temp));
         --  Put_Line(File => o_file, Item => "<identifier>" & temp & "</identifier>");
         
         -- 3. Open Class Definitions: '{' :
         temp := To_Unbounded_String(Get_Line(File => in_file));
         if To_String(temp) = "<symbol> { </symbol>" then
            Put_Line(File => o_file, Item => To_String(temp));
         end if;
         -- 4. Call classVarDec :  For all fields that belong to the class:

         -- LOOP: needs to be in a loop:
         -- while Get_Line in { static | field }
         temp := To_Unbounded_String(Get_Line(File => in_file));
         while  To_String(temp) in  "<keyword> static </keyword>" | "<keyword> field </keyword>" loop   
            parse_classVarDec(temp);  -- Will be called only if not empty
            temp := To_Unbounded_String(Get_Line(File => in_file));
         end loop;
         
         -- 5. call subroutines : 
         --  temp := To_Unbounded_String(Get_Line(File => in_file));  -- <= this is already calulated in the last loop
         while To_String(temp) in "<keyword> constructor </keyword>" | "<keyword> function </keyword>"
           | "<keyword> method </keyword>" loop
            parse_subroutineDec(temp);
            temp := To_Unbounded_String(Get_Line(File => in_file));
         end loop;
         
         --  temp := To_Unbounded_String(Get_Line(File => in_file));  -- <= already saved in the last loop
         if To_String(temp) := "<symbol> } </symbol>" then
            Put_Line(File => o_file, Item => To_String(temp));
         end if;
      end if;    
      Put_Line(File => o_file, Item => "</class>");
   end parse_class;
   
   procedure parse_classVarDec (t: Unbounded_String) is
      temp : Unbounded_String := t;
   begin
      --  Put_Line(File => o_file, Item => To_String(temp));
      --  temp := To_Unbounded_String(Get_Line(File => in_file));
      if To_String(temp) in "<keyword> static </keyword>" | "<keyword> field </keyword>" then
         Put_Line(File => o_file, Item => To_String(temp));
         parse_type(To_Unbounded_String(""));
         -- next comes the <identifier> tag:
         temp := To_Unbounded_String(Get_Line(File => in_file));
         Put_Line(File => o_file, Item => To_String(temp));
         -- <symbol> tag == '('
         temp := To_Unbounded_String(Get_Line(File => in_file));
         while To_String(temp) = "<symbol> , </symbol>" loop
            -- Put into the file the <symbol> tag
            Put_Line(File => o_file, Item => To_String(temp));  
            -- NEXT <identifier> tag [ another field in the same line ]
            temp := To_Unbounded_String(Get_Line(File => in_file));
            Put_Line(File => o_file, Item => To_String(temp));
            -- Get next symbol to see if it's another ',':
            temp := To_Unbounded_String(Get_Line(File => in_file));
         end loop;
         if To_String(temp) = "<symbol> ; </symbol>" then
            Put_Line(File => o_file, Item => To_String(temp));
         end if;
      end if;
      null; -- In the case of the class having no fields 
   end parse_classVarDec;
   
   procedure parse_type (t: Unbounded_String) is
      temp : Unounded_String := t;
   begin
      if To_String(temp) = "" then 
         temp := To_Unbounded_String(Get_Line(File => in_file));
      end if;

      if To_String(temp) in "<keyword> int </keyword>" | "<keyword> char </keyword>" 
        | "<keyword> boolean </keyword>" then
         Put_Line(File => o_file, Item => To_String(temp));
         -- className:
         temp := To_Unbounded_String(Get_Line(File => in_file));
         Put_Line(File => o_file, Item => To_String(temp));
      end if;
      null;
   end parse_type;
   
   procedure parse_subroutineDec (t: Unbounded_String) is
      temp : Unbounded_String := t;
   begin
      -- outputs the first tag (constructor | function | method)
      Put_Line(File => o_file, Item => To_String(temp)); 
      temp := To_Unbounded_String(Get_Line(File => in_file));
      if To_String(temp) /= "<keyword> void </keyword>" then
         parse_type(temp);
      else
         Put_Line(File => o_file, Item => To_String(temp)); -- it's VOID
      end if;
      -- subroutineName:
      temp := To_Unbounded_String(Get_Line(File => in_file));
      Put_Line(File => o_file, Item => To_String(temp));
      -- parameterList:
      temp := To_Unbounded_String(Get_Line(File => in_file));
      if To_String(temp) = "<symbol> ( </symbol>" then
         Put_Line(File => o_file, Item => To_String(temp));
         parse_parameterList;
         -- ')' == when parameterList stops executing ! ! ! !
         Put_Line(File => o_file, Item => "<symbol> ) </symbol>");
         
         -- subroutineBody:
         parse_subroutineBody;
      end if;
      null;
   end parse_subroutingDec;
   
   procedure parse_parameterList is
      temp: Unobounded_String := To_Unbounded_String("");
   begin
      temp := To_Unbounded_String(Get_Line(File => in_file));
      if To_String(temp) /= "<symbol> ) </symbol>" then  -- indicates that there are no parameters
         parse_type(temp);
         -- varNsme:
         temp := To_Unbounded_String(Get_Line(File => in_file));
         Put_Line(File => o_file, Item => To_String(temp)); 
         temp := To_Unbounded_String(Get_Line(File => in_file));
         while To_String(temp) = "<symbol> , </symbol>" loop
            Put_Line(File => o_file, Item => To_String(temp));
            -- type:
            temp := To_Unbounded_String(Get_Line(File => in_file));
            parse_type(temp);
            -- varName:
            temp := To_Unbounded_String(Get_Line(File => in_file));  -- will end when this equals to '{'
            Put_Line(File => o_file, Item => To_String(temp));
         end loop;
      end if;
      null;
   end parse_parameterList;
   
   procedure parse_subroutineBody is
      temp : Unbounded_String := To_Unbounded_String("");
   begin
      Put_Line(File => o_file, Item => "<symbol> { </symbol>");
      temp := To_Unbounded_String(Get_Line(File => in_file));
      while To_String(temp) = "<keyword> var </keyword>" loop
         -- var:
         --  Put_Line(File => o_file, Item => To_String(temp));
         parse_varDec;  
         temp := To_Unbounded_String(Get_Line(File => in_file));
      end loop;   
      -- statements:       
      -- send temp to the procedure so that we can check which type of statement it is
      parse_statements(temp);
      Put_Line(File => o_file, Item => "<symbol> } </symbol>");
   end parse_subroutineBody;
   
   procedure parse_varDec is
      temp : Unbounded_String := To_Unbounded_String("");
   begin
      Put_Line(File => o_file, Item => "<keyword> var </keyword>");
      -- type:
      temp := To_Unbounded_String(Get_Line(File => in_file));
      parse_type(temp);
      -- varName:
      temp := To_Unbounded_String(Get_Line(File => in_file));
      Put_Line(File => o_file, Item => To_String(temp));
      temp := To_Unbounded_String(Get_Line(File => in_file));
      while To_String(temp) = "<symbol> , <symbol>" loop
         -- ',' :
         Put_Line(File => o_file, Item => To_String(temp));
         -- varName:
         temp := To_Unbounded_String(Get_Line(File => in_file));
         Put_Line(File => o_file, Item => To_String(temp));
         -- check next token:
         temp := To_Unbounded_String(Get_Line(File => in_file));
      end loop;
      Put_Line(File => o_file, Item => "<symbol> ; </symbol>");
   end parse_varDec;
   
   --# STATEMENTS:
   procedure parse_statements (t: Unbounded_String) is
      temp : Unbounded_String := t;
   begin
      while To_String(temp) /= "<symbol> } <symbol>" loop
         -- breakdown the statement
         -- statement procedure will return the first token in the next statement
         temp := parse_statement(temp);
      end loop;
      --  Put_Line(File => o_file, Item => "<symbol> } <symbol>");
      -- ^ happens in the above level
      null;
   end parse_statements;
   
   function parse_statement (t: Unbounded_String) return Unbounded_String is
      temp : Unbounded_String := t;
   begin
      if To_String(temp) = "<keyword> let </keyword>" then
         temp := parse_letStatement(temp);
      elsif To_String(temp) = "<keyword> if </keyword>" then
         temp := parse_ifStatement(temp);
      elsif To_String(temp) = "<keyword> while </keyword>" then
         temp := parse_whileStatement(temp);
      elsif To_String(temp) = "<keyword> do </keyword>" then
         temp := parse_doStatement(temp);
      elsif To_String(temp) = "<keyword> return </keyword>" then
         temp := parse_returnStatement(temp);
      end if;
      -- temp == START of next statement
      return temp;
   end parse_statement;
   
   function parse_letStatement (t: Unbounded_String) return Unbounded_String is
      temp : Unbounded_String := t;
   begin
      -- let keyword:
      Put_Line(File => o_file, Item => "<keyword> let </keyword>");
      -- varName:
      temp := To_Unbounded_String(Get_Line(File => in_file));
      Put_Line(File => o_file, Item => To_String(temp));
      -- array ? :
      temp := To_Unbounded_String(Get_Line(File => in_file));
      if To_String(temp) = "<symbol> [ </symbol>" then
         Put_Line(File => o_file, Item => To_String(temp));
         parse_expression; -- temp == next token == ] (by the end of this procedure)
         --  temp := To_Unbounded_String(Get_Line(File => in_file));
         Put_Line(File => o_file, Item => "<symbol> ] </symbol>");
      end if;
      temp := To_Unbounded_String(Get_Line(File => in_file));
      Put_Line(File => o_file, Item => "<symbol> = </symbol>");
      parse_expression;
      Put_Line(File => o_file, Item => "<symbol> ; </symbol>");

      -- temp == NEXT token:
      -- so that we can check if the next token in '}' 
      temp := To_Unbounded_String(Get_Line(File => in_file));
      return temp;
   end parse_letStatement;
   
   function parse_ifStatement (t: Unbounded_String) return Unbounded_String is 
      temp : Unbounded_String := t;
   begin
      -- if keyword:
      Put_Line(File => o_file, Item => "<keyword> if </keyword>");
      -- varName:
      temp := To_Unbounded_String(Get_Line(File => in_file));
      Put_Line(File => o_file, Item => To_String(temp));
      -- { :
      temp := To_Unbounded_String(Get_Line(File => in_file));
      Put_Line(File => o_file, Item => "<symbol> { </symbol>");
      -- statements:
      temp := To_Unbounded_String(Get_Line(File => in_file));
      if To_String(temp) = "<symbol> } <symbol>" then
         Put_Line(File => o_file, Item => To_String(temp));
      else
         parse_statements(temp);

         temp := To_Unbounded_String(Get_Line(File => in_file));
         Put_Line(File => o_file, Item => "<symbol> } </symbol>");
      end if;
      temp := To_Unbounded_String(Get_Line(File => in_file));
      if To_String(temp) = "<keyword> else </keyword>" then
         -- else keyword:
         Put_Line(File => o_file, Item => To_String(temp));
         -- statements:
         temp := To_Unbounded_String(Get_Line(File => in_file));
         parse_statements(temp);
         -- } - closer;
         temp := To_Unbounded_String(Get_Line(File => in_file));
         Put_Line(File => o_file, Item => "<symbol> } <symbol>");
      end if;
      temp := To_Unbounded_String(Get_Line(File => in_file));
      return temp;
   end parse_ifStatement;
   
   function parse_whileStatement (t: Unbounded_String) return Unbounded_String is
      temp : Unbounded_String := t;
   begin
      -- while keyword:
      Put_Line(File => o_file, Item => "<keyword> while </keyword>");
      -- '(' expression ')' :
      temp := To_Unbounded_String(Get_Line(File => in_file));
      Put_Line(File => o_file, Item => "<symbol> ( </symbol>");
      -- expression:
      parse_expression;
      
      temp := To_Unbounded_String(Get_Line(File => in_file));
      Put_Line(File => o_file, Item => "<symbol> ) </symbol>");
      -- '{' statements '}' :
      temp := To_Unbounded_String(Get_Line(File => in_file));
      Put_Line(File => o_file, Item => "<symbol> { </symbol>");
      -- statements:
      temp := To_Unbounded_String(Get_Line(File => in_file));
      parse_statements(temp);
      temp := To_Unbounded_String(Get_Line(File => in_file));
      Put_Line(File => o_file, Item => "<symbol> } </symbol>");

      -- temp == NEXT token:
      temp := To_Unbounded_String(Get_Line(File => in_file));
      return temp;
   end parse_whileStatement;
   
   function parse_doStatement (t: Unbounded_String) return Unbounded_String is
      temp: Unbounded_String := t;
   begin
      Put_Line(File => o_file, Item => "<keyword> do </keyword>");
      parse_subroutineCall;
      temp := To_Unbounded_String(Get_Line(File => in_file));
      Put_Line(File => o_file, Item => "<symbol> ; </keyword>");
      
      temp := To_Unbounded_String(Get_Line(File => in_file)); -- for wrapping level to know if it can exit
      return temp;
   end parse_doStatement;
   
   function parse_returnStatement (t: Unbounded_String) return Unbounded_String is
      temp : Unbounded_String := t;
   begin
      -- return
      Put_Line(File => o_file, Item => "<keyword> return </keyword>");
      -- expression
      --  temp := To_Unbounded_String(Get_Line(File => in_file));
      parse_expression;
      -- end line - ; symbol:
      Pu_Line(File => o_file, Item => "<symbol> ; </symbol>");
      -- temp == NEXT token:
      temp := To_Unbounded_String(Get_Line(File => in_file));
      return temp;
   end parse_returnStatement;
   
   --# EXPRESSIONS:
   procedure parse_expression is
      temp : Unbounded_String := To_Unbounded_String("");
   begin
      temp := To_Unbounded_String(Get_Line(File => in_file));
      temp := parse_term(temp);
      
      --  temp := To_Unbounded_String(Get_Line(File => in_file));
      while To_String(temp) in "<symbol> + </symbol>" | "<symbol> - </symbol>" | "<symbol> * </symbol>"
        | "<symbol> / </symbol>" | "<symbol> & </symbol>" | "<symbol> | </symbol>" | "<symbol> < </symbol>" 
          | "<symbol> > </symbol>" | "<symbol> = </symbol>" loop
         Put_Line(File => o_file, Item => To_String(temp));
         temp := To_Unbounded_String(Get_Line(File => in_file));
         temp := parse_term(temp);
      end loop;
   end parse_expression;
   
   function parse_term (t: Unbounded_String) return Unbounded_String is
      temp : Unbounded_String := t;
   begin
      -- integerConstant:
      if To_String(temp)(1..17) = "<integerConstant>" then
         Put_Line(File => o_file, Item => To_String(temp));
      -- stringConstant:
      elsif To_String(temp)(1..16) = "<stringConstant>" then
         Put_Line(File => o_file, Item => To_String(temp));
      -- keywordConstant == { true, false, null, this }:  
      elsif To_String(temp) in "<keyword> true </keyword>" | "<keyword> false </keyword>" 
        | "<keyword> null </keyword>" | "<keyword> this </keyword>" then
         Put_Line(File => o_file, Item => To_String(temp));
      -- varName:  OR  subroutineCall:
      elsif To_String(temp)(1..11) = "<identifer>" then
         Put_Line(File => o_file, Item => To_String(temp));
         temp := To_Unbounded_String(Get_Line(File => in_file));
         -- varName '[' expression ']':
         if To_String(temp) = "<symbol> [ </symbol>" then
            Put_Line(File => o_file, Item => To_String(temp));
            --  temp := To_Unbounded_String(Get_Line(File => in_file));
            parse_expression;
            temp := To_Unbounded_String(Get_Line(File => in_file));
            Put_Line(File => o_file, Item => "<symbol> ] </symbol>");
         -- subroutineCall -> subroutineName '(' expressionList ')' :
         elsif To_String(temp) = "<symbol> ( </symbol>" then
            Put_Line(File => o_file, Item => To_String(temp));
            parse_expressionList;
            temp := To_Unbounded_String(Get_Line(File => in_file));
            Put_Line(File => o_file, Item => "<symbol> ) <symbol>");
         -- subroutineCall -> (className | varName) '.' subroutineName '(' expressionList ')' :
         elsif To_String(temp) = "<symbol> . </symbol>" then
            Put_Line(File => o_file, Item => To_String(temp));
            -- subroutineName:
            temp := To_Unbounded_String(Get_Line(File => in_file));
            Put_Line(File => o_file, Item => To_String(temp));
            -- ( expressionList ):
            temp := To_Unbounded_String(Get_Line(File => in_file));
            Put_Line(File => o_file, Item => "<symbol> ( <symbol>");
            expressionList;
            Put_Line(File => o_file, Item => "<symbol> ) <symbol>");
         end if;
      -- '(' expression ')' :
      elsif To_String(temp) = "<symbol> ( </symbol>" then
         Put_Line(File => o_file, Item => To_String(temp));
         -- expression:
         parse_expression;

         temp := To_Unbounded_String(Get_Line(File => in_file));
         Put_Line(File => o_file, Item => "<symbol> ) </symbol>");
      elsif To_String(temp) in "<symbol> = </symbol>" | "<symbol> ~ </symbol>" then
         Put_Line(File => o_file, Item => To_String(temp));
         temp := To_Unbounded_String(Get_Line(File => in_file));
         parse_term(temp);
      end if;

      temp := To_Unbounded_String(Get_Line(File => in_file));
      return temp;
   end parse_term;
   
   procedure parse_expressionList is
      temp: Unbounded_String := To_Unbounded_String("");
   begin
      parse_expression;
      temp := To_Unbounded_String(Get_Line(File => in_file));
      while To_String(temp) = "<symbol> , </symbol>" loop
         Put_Line(File => o_file, Item => To_String(temp));
         parse_expression;
         temp := To_Unbounded_String(Get_Line(File => in_file));
      end loop;

   end parse_expressionList;


end Syntax_Analyzer;
