
module s_cycle_cpu(
    input  wire        clock,
    input  wire        reset,
    output wire [31:0] pc,
    output wire [31:0] result

);

    //PC相关信号
    wire [31:0] pc_plus4;

    //指令寄存器相关信号
    wire [31:0] instruction;

    //指令译码相关信号
    wire [5:0]  opcode;
    wire [4:0]  rs;
    wire [4:0]  rt;
    wire [4:0]  num_write;
    wire [4:0]  shamt;
    wire [5:0]  funct;
    wire [31:0] imm32;


    //寄存器堆信号
    wire [31:0] a;
    wire [31:0] b;
    wire [31:0] data_write; // 连接到ALU结果输出，方便调试观察
    
    //ALU相关信号
    wire        overflow;
    wire        zero;

    //主控制信号
    wire [3:0] alu_op;
    wire       reg_write;
    wire [1:0] reg_dst;
    wire       alu_src;

    //PC模块
    pc PC (
        .clock(clock),
        .reset(reset),
        .pc(pc),
        .pc_plus4(pc_plus4)
    );

    //指令译码模块
    instr_decode INSTR_DECODE (
        .instruction(instruction),
        .reg_dst(reg_dst),
        .opcode(opcode),
        .rs(rs),
        .rt(rt),
        .num_write(num_write),
        .shamt(shamt),
        .funct(funct),
        .imm32(imm32)
    );

    //指令存储器 IM
    im IM (
        .pc(pc),
        .instruction(instruction)
    );
    
    //主控制单元
    control CONTROL (
        .opcode(opcode),
        .funct(funct),
        .reg_dst(reg_dst),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .alu_op(alu_op)
    );

    //寄存器堆 GPR
    gpr GPR (
        .a(a),
        .b(b),
        .clock(clock),
        .reg_write(reg_write),
        .rs(rs),
        .rt(rt),
        .num_write(num_write),
        .data_write(result) // 连接到ALU结果输出，方便调试观察

    );
    
    //ALU
    alu ALU (
        .result(result),
        .a(a),
        .b(b),
        .imm32(imm32),
        .alu_op(alu_op),
        .shamt(shamt),
        .alu_src(alu_src),
        .zero(zero),
        .overflow(overflow)
    );


endmodule