// 指令译码模块
module instr_decode (
    input  wire [31:0] instruction,
    input  wire [1:0]  reg_dst,
    output wire [5:0]  opcode,
    output wire [4:0]  rs,
    output wire [4:0]  rt,
    output wire [4:0]  num_write,
	output wire [4:0]  shamt,
    output wire [5:0]  funct,
    output reg  [31:0] imm32
);
    assign opcode  = instruction[31:26];  
    assign rs = instruction[25:21];
    assign rt = instruction[20:16];
    assign num_write = (reg_dst == 2'b00) ? rt : // I-type指令写回rt寄存器
                       (reg_dst == 2'b01) ? instruction[15:11] : rt;// R-type指令写回rd寄存器
    assign shamt   = instruction[10:6];
    assign funct   = instruction[5:0];
    wire [15:0] imm16 = instruction[15:0];

    always @(*) begin
        case (opcode)
            6'b001100,  // andi
            6'b001101:  // ori

            imm32 = {16'b0, imm16};     // 零扩展
        default:
            imm32 = {{16{imm16[15]}}, imm16};  // 符号扩展
        endcase
    end
endmodule