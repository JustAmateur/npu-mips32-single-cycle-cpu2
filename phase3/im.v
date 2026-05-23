//指令存储器模块
module im(
    output wire [31:0] instruction,
    input  wire [31:0] pc
);

    reg [31:0] ins_memory [0:1023];  // 4KB 指令存储器

    // 取指令：使用 PC 的低 12 位作为地址
    assign instruction = ins_memory[pc[11:2]];  // 每条指令占 4 字节，地址右移 2 位

endmodule