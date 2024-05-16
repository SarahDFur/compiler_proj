package body Parser is

      procedure switch_ops (op: String, label : String, argument: String) is
      -- Group 1: (local, argument, this, that)
      -- Group 2 (temp)
      -- Group 3 (static)
      -- Group 4 (pointer 0, pointer 1)
      -- Group 5 (constant)
   begin
      case op is
         when "push" =>
            case label is
-- Group 1: (local, argument, this, that)
               when "local" =>
--  @SP  // Get the value from the top of the stack
--  M=D  // Store the value in a temporary register (D)
--  @i    // Replace "i" with the local variable index
--  A=LCL + A  // Calculate the memory address of the local variable
--  M=D  // Store the value from the stack into the local variable

               when "argument" =>
               when "this" =>
               when "that" =>
-- Group 2 (temp)
               when "temp" =>
-- Group 3 (static)
               when "static" =>
-- Group 4 (pointer 0, pointer 1)
               when "pointer 0" =>
               when "pointer 1" =>
-- Group 5 (constant)
               when "constant" =>
            end case;
         when "pop" =>
-- Group 1: (local, argument, this, that)
            case label is
               when "local" =>
               when "argument" =>
               when "this" =>
               when "that" =>
-- Group 2 (temp)
               when "temp" =>
-- Group 3 (static)
               when "static" =>
-- Group 4 (pointer 0, pointer 1)
               when "pointer 0" =>
               when "pointer 1" =>
-- Group 5 (constant)
               when "constant" =>
            end case;
      end case;
   end switch_ops;

   --------------------------------------------------------------------------------------------------------------------------
   procedure parse_Instruction (Line : String) is
   begin
   end parse_Instruction;

end Parser;
