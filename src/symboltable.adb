with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Utils; use Utils;
with Ada.Directories; use Ada.Directories;
with Ada.Characters.Conversions; use Ada.Characters.Conversions;
with SymbolTable; use SymbolTable;

--# File Mode Types:
--    In_File: Opens an existing file for reading.
--    Out_File: Creates a new file for writing (overwrites if the file already exists).
--    Append_File: Opens an existing file for appending data to the end.

package body SymbolTable is
   in_symbol_table_file, out_symbol_table_file : File_Type;  -- 2 variables for both operations
   procedure Consturctor is
   begin
      Create(File => out_symbol_table_file, Mode => Out_File, Name => Current_Directory & '\' & "symbol_table.txt");
      Close(out_symbol_table_file);
   end Constructor;

   procedure define (name: Unbounded_String; var_type: Unbounded_String; kind: Unbounded_String) is
   begin
      
   end define;
   
   function varCount (kind: Unbounded_String) return int is  -- Might need to create global counters
   begin
      
   end varCount;
 
   function kindOf (name: Unbounded_String) return Unbounded_String is
   begin
      
   end kindOf;
   
   function typeOf (name: Unbounded_String) return Unbounded_String is
   begin
      
   end typeOf;
   
   function indexOf (name: Unbounded_String) return int is
   begin
      
   end indexOf;

end SymbolTable;
