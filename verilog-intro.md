# Verilog Introduction

Verilog and VHDL are two most commonly used HDL.

## Modules

In verilog, every digital hardware can be represented as a module.
Each module consists of a core circuit and an interface.
A core circuit, called as **internal** or **body** as well, performs the required function.
An interface, called **ports**, carries out the required communication between the core circuit and outside.

The format of modules in verilog looks like this

```verilog
module my_module(module interface list);
	// list of interface ports
	input input1;
	output output1;

	// net and variable declartions
	wire p;

	// funcitonal specification: body, internal

endmodule
```

## Number representation

The format of number representation looks like below.

\<size\>\'\<base format\>value

For example,

| Category | Number representation | explanation |
| -------- | --------------------- | ----------- |
| Sized Number | 4'b1001 | a 4-bit binary number, 9|
| Sized Number | 16'habcd | a 16-bit hexadecimal number, 43981|
| Unsized Number| 2007 | a 32-bit decimal number by default |
| Unsized Number| 'habcd | a 32-bit hexadecimal number |
| Negative Number | -4'b1001 | -9 |
| Negative Number | -16'habcd | -43981 |

