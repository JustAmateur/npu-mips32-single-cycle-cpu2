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
    wire [25:0] jump_offset;
    wire [31:0] branch_offset;
    


    //寄存器堆信号
    wire [31:0] a;
    wire [31:0] b;
    wire [31:0] data_write;

    
    //ALU相关信号
    wire        overflow;
    wire        zero;

    //主控制信号
    wire [3:0] alu_op;
    wire       reg_write;
    wire [1:0] reg_dst;
    wire       alu_src;
    wire       mem_write;
    wire [1:0] pc_src;
    wire [1:0] mem_to_reg;
    
    //内存数据
    wire [31:0] data_out;

    //PC模块
    pc PC (
        .clock(clock),
        .reset(reset),
        .jump_offset(jump_offset),
        .jr_addr(a), // jr指令使用寄存器a的值作为下一PC
        .zero(zero),
        .pc_src(pc_src),
        .pc(pc),
        .branch_offset(branch_offset),
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
        .imm32(imm32),
        .jump_offset(jump_offset),
        .branch_offset(branch_offset)
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
        .alu_op(alu_op),
        .pc_src(pc_src),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg)
    );

    //寄存器堆 GPR
    gpr GPR (
        .a(a),
        .b(b),
        .clock(clock),
        .data_write(data_write),
        .reg_write(reg_write),
        .rs(rs),
        .rt(rt),
        .num_write(num_write),
        .result(result),
        .mem_data(data_out),
        .pc_plus4(pc_plus4),
        .mem_to_reg(mem_to_reg)
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

    //DM
    dm DM (
        .clock(clock),
        .mem_write(mem_write),
        .address(result),
        .data_in(b),
        .data_out(data_out)
    );

endmodule
