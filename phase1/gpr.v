//寄存器模块
module gpr(
    output wire [31:0] a,
    output wire [31:0] b,
    input wire clock,
    input wire reg_write,
    input wire [4:0] rs,           // 读寄存器1地址
    input wire [4:0] rt,           // 读寄存器2地址
    input wire [4:0] num_write,    // 写寄存器地址

    input wire [31:0] data_write    // alu结果
         

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
    
    // 写操作
    always @(posedge clock) begin
        if (reg_write && (num_write != 5'b0)) begin
            gp_registers[num_write] <= data_write;      // ALU结果写回寄存器
        end
    end

endmodule