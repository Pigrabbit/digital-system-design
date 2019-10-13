# Terminology and concepts

- Nets: any hardware connection points, for instance wire. It must be driven by a primitive, continuos assignment, force ... release or module port.
- Variables; any data storage elements, for instance reg. It can be assigned value only within a procedural statement, task, or function. Reg, integer and time is initially state X. real and realtime is initially set to 0.0
- Named association: `.port_id1(port_expr1), ... , .port_idn(port_exprn)`
- Positional association: `port_expr1, ... ,port_exprn`
- propagation delay: time to propagate data from input to output of each logic gate
- wire delay: since wires have R,C components, there are RC delay
- inertial delay model vs transport delay model: Inertial delay model is used by default for continuous assignment. On the other hand, transport delay model is used by default for net declaration delay.
- glitch: unwanted short pulse
- transient time: the duration of those pulses
- static vs dynamic hazard:
- continuous assignment: the most basic statement of dataflow modeing. It continuously drives a value onto a net.
- Logical shift vs Arithmetic shift: for left shift, they both fill with zeros. However, for right shift, logical shift fill the bit with zeros while arithmetic shift fill the bit with MSBs(sign bits).
- Initial: this statement is used to initialize variables and set values into variables or nets.
- always: this statement is used to model the continuous operations required in the hardware modules. `always @(sensitivity-list) begin sequential-statements end`
- sensitivity list: In combinational always block, includes all signals that are used in the condition statement and on the right-hand side of the assignment. In sequential always blocks, usually contains edge-triggered events.
- Regular timing control vs Intra-Assignment delay control: Regular는 procdeural assignment 왼쪽에 delay를 선언하는 방법으로, entire statement를 실행할 때 delay를 먹인다. 한편, Intra-assignment는 assignment operator의 오른쪽에 delay를 선언하는 방법으로, 왼쪽에 있는 variable에 assign 하는것에 delay를 준다.
- event: variable이나 net의 value가 바뀌는 것을 event라 함. Edge-triggered 와 Level-sensitive 두가지가 있음.
- **while loop**은 expression이 false가 될 때까지 실행, **for loop**은 조건문에 따라 반복해서 실행. **repeat loop**은 고정된 반복 수 만큼 반복실행. **forever loop**은 계속 실행되기 때문에 clk signal 줄때 주로 사용.
- generate block structure: it allows selection and replication of some statements during elaboration time. The elaboration time is the time after a design has been parsed but before simulation begins. Can control the declaration of varaibles, functions, tasks, and module instantiation.
- Task vs Function: Don't Repeat Yourself. 코드를 재활용하자.

|Item|Tasks|Functions|
|----|-----|---------|
|Arguments|zero or more *input*, *output* and *inout*|input 최소 하나, *output*, *inout*은 불가능|
|Return values|multiple *output*, *inout*가능|only single value via function name|
|Timing control statements|Yes|No|
|Execution|In non-zero simulation time|In zero simulation time|
|Invoke|Functions and tasks|Functions only|

- Clock-to-Q delay: clock이 바뀐 후 Q output이 바뀔 때 까지의 시간.
- Setup time: clock의 active edge 전 input을 stable하게 지속시켜야 하는 시간.
- Hold time: clock의 active edge 후 input을 stable하게 지속시켜야 하는 시간.
- Clock skew & Clock jitter: Clock skew는 한 clock이 서로 다른 Flip-flop에 들어갈 때 edge차이가 발생하는 것이고 Clock jitter는 한 Flip-flop내에서 clk signal이 일정하지 않아 edge가 흔들리는 것이다.

# Things to consider

- module definitions cannot be nested.
- ports are considered **unsigned** as default. 사실 모든 operation이 unsigned가 default다.
- when ports are unconnected, inputs are driven to z, outputs are floating
- Instance name is necessary when instantiating designed module
- Array instantiations may be synthesis tool dependent. Need to check this before running synthesis.
- Precedence of operators: Unary `+, -, !, ~` -> Exponent `**` -> Multiply, divide, modulus `*, /, %` -> Add, subtract -> shift `<< , >>, <<<, >>>` -> Relational `<, <=, >, >=` -> Equality `==, !=, ===, !==` -> Reduction -> Logical -> Conditional
- Relational operation between two different sizes: If both operands are signed, sign-bit extention + signed comparison. At least one is unsigned, zero-padding + unsigned comparison.
- initial and always statements cannot be nested.
- blocking assignment 와 non-blocking assignment를 같은 block안에서 혼용하지말자. Blocking은 combinational, Non-blocking은 sequential logic을 짤 때 사용하자.
- 어떤 block이든 multiple statements가 들어가면 `begin...end` 으로 감싸주자
- Min delay(hold time violation)와 Max delay(setup time violation)둘을 모두 지켜야한다. Clock을 느리게 한다고 해서 hold time violation을 고칠 수 있는게 아니다.
- operand중 하나만 unsigned라고 하더라도 전체 operation은 unsigned가 되버린다. 따라서 signed operation을 하고 싶다면 모두 signed 선언을 해주는게 좋다.
- 작은 bit의 data를 더 큰 bit에 담으려고 할 때, `variable_in_larger_bit $unsigned(signal_in_smaller_bit);` 또는  `variable_in_larger_bit $signed(signal_in_smaller_bit);`의 **type casting**이 의미가 있다. unsigned는 input에 zero를 추가하고 signed는 sign extend를 한다. 
