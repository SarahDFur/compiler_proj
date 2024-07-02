with Ada.Directories; use Ada.Directories;
with Ada.Text_IO; use Ada.Text_IO;
with Syntax_Analyzer; use Syntax_Analyzer;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure analyzer_main is
   Filter  : constant Filter_Type := (Ordinary_File => True, others => False); -- Files only.
   Search : Search_Type;
   Dir_Entry : Directory_Entry_Type;
begin
   -- in a loop, load file names to read (that are in the current directory)
   -- files have extenssion of ".jack"
   -- send one file at a time to tokenizer init function
   -- creates files with the name and extenssion:  "...T.xml"
   Start_Search(Search, Current_Directory, "*T.xml", Filter); -- Start searching
   while More_Entries(Search) loop
      Get_Next_Entry(Search, Dir_Entry);
      init_analyzer(To_Unbounded_String(Simple_Name(Dir_Entry)));
   end loop;
   End_Search(Search);
   null;
end analyzer_main;
