//寄存器模块
module gpr(
    output [31:0] a,
    output [31:0] b,
    output wire [31:0] data_write,
    input clock,
    input reg_write,
    input [4:0] rs,           // 读寄存器1地址
    input [4:0] rt,           // 读寄存器2地址
    input [4:0] num_write,    // 写寄存器地址

    input [31:0] result,      // alu结果
    input [31:0] mem_data,    // 内存数据

    input [1:0]  mem_to_reg
);

    reg [31:0] gp_registers [0:31];  // 32个32位寄存器
    integer i;

    // 初始化：所有寄存器清零
    initial begin
        for (i = 0; i < 32; i = i + 1)
            gp_registers[i] = 32'h0000_0000;
    end
    
    // 读操作
    assign a = (rs == 5'b0) ? 32'h0000_0000 : gp_registers[rs];
    assign b = (rt == 5'b0) ? 32'h0000_0000 : gp_registers[rt];
    assign data_write = (mem_to_reg == 2'b00) ? result : // ALU结果写回寄存器
                        (mem_to_reg == 2'b01) ? mem_data : 32'hxxxx_xxxx; // 内存数据写回寄存器

    // 写操作
    always @(posedge clock) begin
        if (reg_write && (num_write != 5'b0)) begin
            gp_registers[num_write] <= data_write; // 写入数据
        end
    end

endmodule