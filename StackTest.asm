//PUSH CONST
@17
D = A
@SP
A = M
M = D
@SP
M = M + 1
//PUSH CONST
@17
D = A
@SP
A = M
M = D
@SP
M = M + 1
//EQ
@SP
A=M-1
D=M
A=A-1
D=M-D
@IF_TRUEStackTest0
D;JEQ
D=0
@SP
A=M-1
A=A-1
M=D
@IF_FALSEStackTest0
0;JMP
(IF_TRUEStackTest0)
D=-1
@SP
A=M-1
A=A-1
M=D
(IF_FALSEStackTest0)
@SP
M=M-1
//PUSH CONST
@17
D = A
@SP
A = M
M = D
@SP
M = M + 1
//PUSH CONST
@16
D = A
@SP
A = M
M = D
@SP
M = M + 1
//EQ
@SP
A=M-1
D=M
A=A-1
D=M-D
@IF_TRUEStackTest1
D;JEQ
D=0
@SP
A=M-1
A=A-1
M=D
@IF_FALSEStackTest1
0;JMP
(IF_TRUEStackTest1)
D=-1
@SP
A=M-1
A=A-1
M=D
(IF_FALSEStackTest1)
@SP
M=M-1
//PUSH CONST
@16
D = A
@SP
A = M
M = D
@SP
M = M + 1
//PUSH CONST
@17
D = A
@SP
A = M
M = D
@SP
M = M + 1
//EQ
@SP
A=M-1
D=M
A=A-1
D=M-D
@IF_TRUEStackTest2
D;JEQ
D=0
@SP
A=M-1
A=A-1
M=D
@IF_FALSEStackTest2
0;JMP
(IF_TRUEStackTest2)
D=-1
@SP
A=M-1
A=A-1
M=D
(IF_FALSEStackTest2)
@SP
M=M-1
//PUSH CONST
@892
D = A
@SP
A = M
M = D
@SP
M = M + 1
//PUSH CONST
@891
D = A
@SP
A = M
M = D
@SP
M = M + 1
//LT
@SP
A=M-1
D=M
A=A-1
D=M-D
@IF_TRUEStackTest3
D;JLT
D=0
@SP
A=M-1
A=A-1
M=D
@IF_FALSEStackTest3
0;JMP
(IF_TRUEStackTest3)
D=-1
@SP
A=M-1
A=A-1
M=D
(IF_FALSEStackTest3)
@SP
M=M-1
//PUSH CONST
@891
D = A
@SP
A = M
M = D
@SP
M = M + 1
//PUSH CONST
@892
D = A
@SP
A = M
M = D
@SP
M = M + 1
//LT
@SP
A=M-1
D=M
A=A-1
D=M-D
@IF_TRUEStackTest4
D;JLT
D=0
@SP
A=M-1
A=A-1
M=D
@IF_FALSEStackTest4
0;JMP
(IF_TRUEStackTest4)
D=-1
@SP
A=M-1
A=A-1
M=D
(IF_FALSEStackTest4)
@SP
M=M-1
//PUSH CONST
@891
D = A
@SP
A = M
M = D
@SP
M = M + 1
//PUSH CONST
@891
D = A
@SP
A = M
M = D
@SP
M = M + 1
//LT
@SP
A=M-1
D=M
A=A-1
D=M-D
@IF_TRUEStackTest5
D;JLT
D=0
@SP
A=M-1
A=A-1
M=D
@IF_FALSEStackTest5
0;JMP
(IF_TRUEStackTest5)
D=-1
@SP
A=M-1
A=A-1
M=D
(IF_FALSEStackTest5)
@SP
M=M-1
//PUSH CONST
@32767
D = A
@SP
A = M
M = D
@SP
M = M + 1
//PUSH CONST
@32766
D = A
@SP
A = M
M = D
@SP
M = M + 1
//GT
@SP
A=M-1
D=M
A=A-1
D=M-D
@IF_TRUEStackTest6
D;JGT
D=0
@SP
A=M-1
A=A-1
M=D
@IF_FALSEStackTest6
0;JMP
(IF_TRUEStackTest6)
D=-1
@SP
A=M-1
A=A-1
M=D
(IF_FALSEStackTest6)
@SP
M=M-1
//PUSH CONST
@32766
D = A
@SP
A = M
M = D
@SP
M = M + 1
//PUSH CONST
@32767
D = A
@SP
A = M
M = D
@SP
M = M + 1
//GT
@SP
A=M-1
D=M
A=A-1
D=M-D
@IF_TRUEStackTest7
D;JGT
D=0
@SP
A=M-1
A=A-1
M=D
@IF_FALSEStackTest7
0;JMP
(IF_TRUEStackTest7)
D=-1
@SP
A=M-1
A=A-1
M=D
(IF_FALSEStackTest7)
@SP
M=M-1
//PUSH CONST
@32766
D = A
@SP
A = M
M = D
@SP
M = M + 1
//PUSH CONST
@32766
D = A
@SP
A = M
M = D
@SP
M = M + 1
//GT
@SP
A=M-1
D=M
A=A-1
D=M-D
@IF_TRUEStackTest8
D;JGT
D=0
@SP
A=M-1
A=A-1
M=D
@IF_FALSEStackTest8
0;JMP
(IF_TRUEStackTest8)
D=-1
@SP
A=M-1
A=A-1
M=D
(IF_FALSEStackTest8)
@SP
M=M-1
//PUSH CONST
@57
D = A
@SP
A = M
M = D
@SP
M = M + 1
//PUSH CONST
@31
D = A
@SP
A = M
M = D
@SP
M = M + 1
//PUSH CONST
@53
D = A
@SP
A = M
M = D
@SP
M = M + 1
//ADD
@SP
A=M-1
D=M
A=A-1
M=D+M
@SP
M=M-1
//PUSH CONST
@112
D = A
@SP
A = M
M = D
@SP
M = M + 1
//SUB
@SP
 A=M-1
D=M
A=A-1
M=M-D
@SP
M=M-1
@SP
A=M-1
M=-M
//AND
@SP
A=M-1
 D=M
A=A-1
M=M&D
@SP
M=M-1
//PUSH CONST
@82
D = A
@SP
A = M
M = D
@SP
M = M + 1
//OR
@SP
A=M-1
 D=M
A=A-1
M=M|D
@SP
M=M-1
//NOT
@SP
A=M-1
 M=!M
