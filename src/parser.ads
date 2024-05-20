package Parser is

   type instruction_record is record
      op: String (1.. 30);
      label : String (1.. 30);
      arg: Integer;
   end record;
   
   procedure init_parser(full_ofname: String); -- initializes the parser - CALLED FROM MAIN
   procedure read_file(if_name: String);
   -- Will have a switch, in which all instructions 
   -- Instruction Line will be sent to the appropriate write_to_file functions
   function parse_Instruction (Line : String) return instruction_record;
   procedure switch_stack_ops (op: String; label : String; argument: Integer);
   procedure switch_arith_ops (op: String);

end Parser;
