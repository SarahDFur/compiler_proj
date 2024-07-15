with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package SymbolTable is

   type String_Array is array (Positive range <>) of Unbounded_String;
   
   procedure Consturctor (name: Unbounded_String);
   procedure startSubroutine; 
   procedure define (name: Unbounded_String; var_type: Unbounded_String; kind: Unbounded_String);
   function varCount (kind: Unbounded_String) return Integer;  -- Might need to create global counters
   function kindOf (name: Unbounded_String) return Unbounded_String;
   function typeOf (name: Unbounded_String) return Unbounded_String;
   function indexOf (name: Unbounded_String) return Integer;

end SymbolTable;
