with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;
package CodeWriter is
   
   -- parser -> sends to appropriate write algorithm
   -- writes to file HACK code for "add x y"
   --  procedure write_add (arg1: Integer, arg2: Integer);
   -- INIT FUNCTIONS / CONSTRUCTOR OF SORTS: --
   procedure init_f(n: Unbounded_String); -- inits the file name for when we want to exeute pop/push static 
   
   -- ARITHMATIC & LOGIC FUNCTIONS: --
   procedure write_add;
      -- writes to file HACK code for "sub x y"
   procedure write_sub ;
   -- writes to file HACK code for "-x"
   procedure write_neg ;
   -- writes to file HACK code for "x and y"
   procedure write_and ;
      -- writes to file HACK code for "x or y"
   procedure write_or ;
     -- writes to file HACK code for "not x"
   procedure write_not ;
   
   procedure write_eq;
   
   procedure write_lt;
   
   procedure write_gt;
   
   procedure write_hash_lt;
   -- PUSH WRITE FUNCTIONS: --
   -- GROUP 1:
   procedure push_local (argument: Integer);
   procedure push_argument (argument: Integer);
   procedure push_this (argument: Integer);
   procedure push_that (argument: Integer);
   -- GROUP 2:
   procedure push_temp (argument: Integer);
   -- GROUP 3;
   procedure push_static (argument: Integer);
   -- GROUP 4:
   procedure push_ptr (argument: Integer);
   -- GROUP 5:
   procedure push_const (argument: Integer);

   -- POP WRITE FUNCTIONS: --
   procedure pop_local (argument: Integer);
   procedure pop_argument (argument: Integer);
   procedure pop_this (argument: Integer);
   procedure pop_that (argument: Integer);
   -- GROUP 2:
   procedure pop_temp (argument: Integer);
   -- GROUP 3;
   procedure pop_static (argument: Integer);
   -- GROUP 4:
   procedure pop_ptr (argument: Integer);

end CodeWriter;
