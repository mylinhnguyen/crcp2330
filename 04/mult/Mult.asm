// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

@2
M=0 //zero out product register

(loop)
	@0
	D=M
	@done
	D;JEQ	//check if done with calculation

	@1
	D=M 	//D= r2
	@2
	D=D+M 	//D= 0 + r2
	M=D 	//stores current product calculation in r2

	@0
	D=M
	D=D-1	//subtracts 1 from counter (which is r0)

	@loop
	JMP

(done)
	@done
	JMP	//infinite loop



