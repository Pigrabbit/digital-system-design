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

## Lexical Conventions

The format of number representation looks like below.

\<size\>\'\<base format\>value

For example,

| Category | Number representation | explanation |
| -------- | --------------------- | ----------- |
| Sized Number | 4'b1001 | a 4-bit binary number, 9|
| Sized Number | 16'habcd | a 16-bit hexadecimal number, 43981|
| Unsized Number| 2007 | a 32-bit decimal number by default |
| Unsized Number| 'habcd | a 32-bit hexadecimal number |
| Negative Number | -4'b1001 | a 4-bit binary number |
| Negative Number | -16'habcd | a 16-bit binary number |

It is four value logic system: **0, 1, X** and **Z**

| Value | Meaning |
|-------|---------|
| 0 | Logic 0, false condition |
| 1 | Logic 1, true condition |
| X | Unknown logic value |
| Z | High impedance |

## Typical Coding style

- signal name, variable name, port name는 lowercase letter로 쓴다.
- constants, user-defined types 는 uppercase letter로 쓴다.
- signals, ports, functions, parameter의 이름을 붙일 때는 의미있는 것으로 한다.
- module과 file의 이름을 일치시킨다.

## Data Types

**Nets**는 any hardware connection points를 나타내며 **wire**가 많이 사용된다.
Primitive, continuous assginment, force... release or module port들로 drive되어야 한다.

**Variables**는 any data storage elements를 나타며 **reg**가 가장 자주 사용된다.
Procedural statement, task, function 안에서만 value를 assign 받을 수 있으며 module 의 input, inout port는 될 수 없다.

**Array**는 같은 attribute을 가진 object들의 collection이며 **Vector**는 bit signal의 one-dimensional array이다.

## Module Modeling Levels

크게 Structural level, Dataflow level, Behavioral level로 3가지가 있다.
Structural level는 built-in primitives, user-defined primitives 및 다른 module들을 wire를 통해 connect하는 방식이다.

Dataflow level은 registers 사이에서 data가 어떻게 이동하는지를 specify하여 modeling한다.

Behavoiral level에서는 hardware implementation을 고민하지 않고 high-level programming language (C or Python)으로 프로그래밍 하듯이 원하는 동작을 modeling 한다.

실제로는 세가지 방법을 혼합하여 design 한다.

## Ports

port 선언은 아래와 같이 하며 signed로 명시되지 않은 경우 unsigned가 default이다.

```verilog
input [net_type] [signed] [range] port_names;
output [net_or_variable_type] [signed] [range] port_names;
inout [net_type] [signed] [range] port_names;
```

port를 connect하는 방법에는 **named association**과 **positional association** 두가지가 있다.
각 port_expr에는 net 또는 variable의 id, vector의 bit-select, part-select등이 들어갈 수 있다.

```verilog
	// Named association
	.port_id1(port_expr1)
	// positional association
	port_expr1
```

만약 port가 connect되지 않았다면, input은 Z로 driven되고 output은 floating 한다.

## Half adder and Full adder in verilog

아래는 half adder와 full adder의 sturctural modeling code이다.

```verilog
module half_adder(x, y, s, c);
	input x, y;
	output s, c;
	
	xor xor1 (s, x, y);
	and and1 (c, x, y);
endmodule

module full_adder(x, y, cin, s, cout);
	input x, y, cin;
	output s, cout;
	wire s1, c1, c2;

	half_adder ha_1 (x, y, s1, c1); // instance name is necessary. Connect by using positional association
	half_adder ha_2 (.x(cin), .y(s1), .s(s), .c(c2)); // Connect by using named association
	or (cout, c1, c2);
endmodule
```

위 code를 dataflow level로 짜보면

```verilog
module full_adder_dataflow(x, y, c_in, sum, c_out);
	input x, y, c_in;
	output sum, c_out;

	assign #5 {c_out, sum} = x + y + c_in;
endmodule
```

코드가 훨씬 짧고 간단하진 것을 확인할 수 있다.
문제는 이렇게 코딩하고 나서 synthesizable한지 확인하는 것이 중요하다.

다시 behavioral level로 같은 full adder를 짜보면
```verilog
module full_adder_behavioral(x, y, c_in, sum, c_out);
	input x, y ,c_in;
	output sum, c_out;

	reg sum, c_out; // they need to be declared as reg types

	always @(x, y ,c_in)
		#5 {c_out, sum} = x + y + c_in;
endmodule
```

## Time scale for simulations

`timescale time_unit/time_precision`의 방식으로 delay의 단위와 얼마나 자세히 볼 것인지 정할 수 있다.
일반적으로 1ns/1ps를 많이 사용한다.
