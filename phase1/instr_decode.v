//指令译码模块
module instr_decode (
    input  wire [31:0] instruction,
    input  wire [1:0]  reg_dst,      // 来自控制单元
    output wire [5:0]  opcode,
    output wire [4:0]  rs,
    output wire [4:0]  rt,
    output wire [4:0]  num_write,    // 写回地址
    output wire [4:0]  shamt,
    output wire [5:0]  funct,
    output reg  [31:0] imm32
);
    // 提取字段
    assign opcode = instruction[31:26];
    assign rs = instruction[25:21];
    assign rt = instruction[20:16];
    wire [4:0] rd = instruction[15:11];
    assign shamt = instruction[10:6];
    assign funct = instruction[5:0];
    wire [15:0] imm16 = instruction[15:0];
    
    // 写回地址选择 - 纯粹的组合逻辑多路器
    assign num_write = (reg_dst == 2'b00) ? rt :
                       (reg_dst == 2'b01) ? rd :
                       (reg_dst == 2'b10) ? 5'b11111 : 5'b00000;
    
    // 立即数扩展
    always @(*) begin
        case (opcode)
            6'b001100, 6'b001101: imm32 = {16'b0, imm16};
            default: imm32 = {{16{imm16[15]}}, imm16};
        endcase
    end
endmodule