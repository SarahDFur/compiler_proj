//PUSH CONST
@3030
D = A
@SP
A = M
M = D
@SP
M = M + 1
//PUSH PTR 0
@THIS
D = M
@SP
A = M
M = D
@SP
M = M + 1
//PUSH CONST
@3040
D = A
@SP
A = M
M = D
@SP
M = M + 1
//PUSH PTR 1
@THAT
D = M
@SP
A = M
M = D
@SP
M = M + 1
//PUSH CONST
@32
D = A
@SP
A = M
M = D
@SP
M = M + 1
//POP THIS
@SP
A = M - 1
D = M
@THIS
A = M
A = A + 1
M = D
@SP
M = M - 1
//PUSH CONST
@46
D = A
@SP
A = M
M = D
@SP
M = M + 1
//POP THAT
@SP
A = M - 1
D = M
@THAT
A = M
A = A + 1
A = A + 1
A = A + 1
A = A + 1
A = A + 1
M = D
@SP
M = M - 1
//PUSH PTR 0
@THIS
D = M
@SP
A = M
M = D
@SP
M = M + 1
//PUSH PTR 1
@THAT
D = M
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
//PUSH THIS
@2
D = A
@THIS
A = M + D
D = M
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
//PUSH THAT
@6
D = A
@THAT
A = M + D
D = M
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
