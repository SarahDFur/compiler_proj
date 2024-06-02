//PUSH CONST
@111
D = A
@SP
A = M
M = D
@SP
M = M + 1
//PUSH CONST
@333
D = A
@SP
A = M
M = D
@SP
M = M + 1
//PUSH CONST
@888
D = A
@SP
A = M
M = D
@SP
M = M + 1
//POP STATIC
@SP
A = M - 1
D = M
@StaticTest.8
M = D
@SP
M = M - 1
//POP STATIC
@SP
A = M - 1
D = M
@StaticTest.3
M = D
@SP
M = M - 1
//POP STATIC
@SP
A = M - 1
D = M
@StaticTest.1
M = D
@SP
M = M - 1
//PUSH STATIC
@StaticTest.3
D = M
@SP
A = M
M = D
@SP
M = M + 1
//PUSH STATIC
@StaticTest.1
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
//PUSH STATIC
@StaticTest.8
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
