package Parser is

   -- Will have a switch, in which all instructions 
   -- Instruction Line will be sent to the appropriate write_to_file functions
   procedure parse_Instruction (i_fname: String, Line : String);
   procedure switch_stack_ops (op: String, label : String, argument: String);
   procedure switch_arith_ops (op: String, label: String, argument: String);
   procedure switch_logic_ops (op: String, label: String, argument: String);

end Parser;
