with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Utils; use Utils;
with Ada.Directories; use Ada.Directories;
with Ada.Characters.Conversions; use Ada.Characters.Conversions;
with SymbolTable; use SymbolTable;
with Utils; use Utils;

--# File Mode Types:
--    In_File: Opens an existing file for reading.
--    Out_File: Creates a new file for writing (overwrites if the file already exists).
--    Append_File: Opens an existing file for appending data to the end.

--#  [ Name, Type, Kind, # ]
package body SymbolTable is
   in_symbol_table_file, out_symbol_table_file : File_Type;  -- 2 variables for both operations
   filename : Unbounded_String := To_Unbounded_String("");  -- Current files name - name of the class in our case
   static_ids : Integer := 0;
   field_ids : Integer := 0;
     
   var_ids : Integer := 0;
   arg_ids : Integer := 0;
   --# Create a Symbol Table
   procedure Constructor (name: Unbounded_String) is
   begin
      Create(File => out_symbol_table_file, Mode => Out_File, Name => Current_Directory & '\' & To_String(name) & "_symbol_table.txt");
      filename := To_Unbounded_String(To_String(name) & "_symbol_table.txt"); 
      Close(out_symbol_table_file);
   end Constructor;

   procedure startSubroutine is  -- will be called when we close a jack / xml file
      temp_class : Unbounded_String := To_Unbounded_String("");
      temp_method : Unbounded_String := To_Unbounded_String("");

   begin
      -- reset constant vars for next xxxT.xml file that we read
      static_ids := 0;
      field_ids := 0;
      var_ids := 0;
      arg_ids := 0;
      --TODO: We may need to add loops that clear all the unwanted information from a method scope
      -- OR, we can add to the subroutine-scope and identify them all with the subroutine names . . . ?
      Open(File => in_symbol_table_file, Mode => In_File, Name => To_String(filename));
      Append(temp_class, To_Unbounded_String(Get_Line(in_symbol_table_file)));
    --  temp_class := To_Unbounded_String(To_String(temp_class) & Get_Line(in_symbol_table));
      while not End_Of_File(in_symbol_table_file) and To_String(temp_class)(1..14) /= "</class-scope>"  loop
         --  temp_class := To_Unbounded_String(temp_class & Get_Line(in_symbol_table));
               Append(temp_class, To_Unbounded_String(Get_Line(in_symbol_table_file)));
      end loop;
            Append(temp_class, To_Unbounded_String(Get_Line(in_symbol_table_file)));
     -- temp_class := To_Unbounded_String(temp_class & Get_Line(in_symbol_table));
      --  while not End_Of_File(in_symbol_table_file) loop
      --     temp_method := To_Unbounded_String(To_String(temp_method) & Get_Line(in_symbol_table));
      --  end loop;
      Close(in_symbol_table_file);
      Open(File => out_symbol_table_file, Mode => Out_File, Name => To_String(filename));
      Put_Line(File => out_symbol_table_file, Item => To_String(temp_class));
      Close(out_symbol_table_file);
   end startSubroutine;
   
   procedure define (name: Unbounded_String; var_type: Unbounded_String; kind: Unbounded_String) is
      index : Integer := 0;
      row : Unbounded_String := To_Unbounded_String("");
   begin
      Open(File => out_symbol_table_file, Mode => Append_File, Name => To_String(filename));
      if To_String(kind) = "STATIC" then
         index := static_ids;
         static_ids := static_ids + 1;
      elsif To_String(kind) = "FIELD" then
         index := field_ids;
         field_ids := field_ids + 1;
      elsif To_String(kind) = "ARG" then
         index := arg_ids;
         arg_ids := arg_ids + 1;
      elsif To_String(kind) = "VAR" then
         index := var_ids; 
         var_ids := var_ids + 1;
      end if;
      row := To_Unbounded_String(To_String(name) & " " & To_String(var_type) & " " & To_String(kind) & " " & index'Image);
      Put_Line(File => out_symbol_table_file, Item => To_String(row));
      Close(out_symbol_table_file);
   end define;
   
   function varCount (kind: Unbounded_String) return Integer is  -- Might need to create global counters
   begin
      if To_String(kind) = "STATIC" then
         return static_ids;
      elsif To_String(kind) = "FIELD" then
         return field_ids;
      elsif To_String(kind) = "ARG" then
         return arg_ids;
      elsif To_String(kind) = "VAR" then
         return var_ids; 
      else
         --noa add for default
         return 0; 
      end if;
   end varCount;
 
 function kindOf (name: Unbounded_String) return Unbounded_String is
      kind_of : Unbounded_String := To_Unbounded_String("");
      temp : Unbounded_String := To_unbounded_String("");
      ins : String_Array;  
   begin
       Open(File => in_symbol_table_file, Mode => In_File, Name => To_String(filename));   
      while not End_Of_File(in_symbol_table_file)  loop
         temp := To_Unbounded_String(Get_Line(File => in_symbol_table_file));
         if To_String(temp)(1..13) /= "<class-scope>" and To_String(temp)(1..13) /= "</class-scope" 
           and To_String(temp)(1..13) /= "<method-scope" and To_String(temp)(1..13) /= "</method-scop" then
            ins := Utils.split_string(To_String(temp));
            if To_String(ins(1)) = name then
               kind_of := ins(3);
            end if;
         end if;
      end loop;
      Close(in_symbol_table_file);
      return kind_of;
   end kindOf;
   
   function typeOf (name: Unbounded_String) return Unbounded_String is
      type_of : Unbounded_String := To_Unbounded_String("");
      temp : Unbounded_String := To_Unbounded_String("");
      ins : String_Array;  
   begin
       Open(File => in_symbol_table_file, Mode => In_File, Name => To_String(filename));   
      while not End_Of_File(in_symbol_table_file)  loop
         temp := To_Unbounded_String(Get_Line(File => in_symbol_table_file));
         if To_String(temp)(1..13) /= "<class-scope>" and To_String(temp)(1..13) /= "</class-scope" 
           and To_String(temp)(1..13) /= "<method-scope" and To_String(temp)(1..13) /= "</method-scop" then
            ins := Utils.split_string(To_String(temp));
            if To_String(ins(1)) = name then
               type_of := ins(2);
            end if;
         end if;
      end loop;
      Close(in_symbol_table_file);
      return type_of;
   end typeOf;
   
   function indexOf (name: Unbounded_String) return Integer is
      index_of : Integer := 0;
      temp : Unbounded_String := To_Unbounded_String("");
      ins : String_Array;
   begin
      Open(File => in_symbol_table_file, Mode => In_File, Name => To_String(filename));   
      while not End_Of_File(in_symbol_table_file) and index_of = 0 loop
         temp := To_Unbounded_String(Get_Line(File => in_symbol_table_file));
         if To_String(temp)(1..13) /= "<class-scope>" and To_String(temp)(1..13) /= "</class-scope" 
           and To_String(temp)(1..13) /= "<method-scope" and To_String(temp)(1..13) /= "</method-scop" then
            ins := Utils.split_string(To_String(temp));
            if To_String(ins(1)) = name then
               index_of := Utils.string_to_int(To_String(ins(4)));
            end if;
         end if;
      end loop;
      Close(in_symbol_table_file);
      return index_of;
   end indexOf;

end SymbolTable;
