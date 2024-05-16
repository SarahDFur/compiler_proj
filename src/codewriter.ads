package CodeWriter is
   -- parser -> sends to appropriate write algorithm
   -- writes to file HACK code for "add x y"
   --  procedure write_add (arg1: Integer, arg2: Integer);
   
   
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
   procedure pop_static (file_name: String, argument: Integer);
   -- GROUP 4:
   procedure pop_ptr (argument: Integer);
   -- GROUP 5:
   procedure pop_const (argument: Integer);

end CodeWriter;
