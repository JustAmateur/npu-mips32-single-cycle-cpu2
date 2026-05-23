//ALU模块
module alu(
    output reg [31:0] result,   
    output reg        overflow,
    output reg        zero,
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [31:0] imm32,
    input wire [3:0]  alu_op,
    input wire [4:0]  shamt,
    input wire        alu_src
);
    localparam OP_ADD  = 4'b0000;
	localparam OP_ADDU = 4'b0001;
	localparam OP_SUBU = 4'b0010;
	localparam OP_AND  = 4'b0011;
	localparam OP_OR   = 4'b0100;
	localparam OP_SLT  = 4'b0110;
	localparam OP_SLL  = 4'b1000;
    localparam OP_LUI  = 4'b1111;
    
    wire [31:0] a_data = a;
    wire [31:0] b_data = (alu_src) ? imm32 : b; // 根据alu_src选择ALU第二操作数

    always @(*) begin
        result = 32'h0;
        overflow = 1'b0;
        zero = 1'b0;

        case (alu_op)
            OP_ADD: begin
                result = a_data + b_data;
                // 检测有符号加法溢出
                if ((a_data[31] == b_data[31]) && (result[31] != a_data[31]))
                    overflow = 1'b1;
            end
            OP_ADDU: result = a_data + b_data;  // 无符号加法不检测溢出
            OP_SUBU:begin
                result = a_data - b_data;  // 无符号减法不检测溢出
                zero = (result == 32'h0) ? 1'b1 : 1'b0; // 设置zero标志
            end 
            OP_AND:  result = a_data & b_data;
            OP_OR:   result = a_data | b_data;
            OP_SLT:  result = ($signed(a_data) < $signed(b_data)) ? 32'h1 : 32'h0; // 有符号比较
            OP_SLL:  result = b_data << shamt;  // 左移
            OP_LUI:  result = {b_data[15:0], 16'h0000}; // 将立即数加载到高16位，低16位清零
            default: result = 32'hx; // 未定义操作
        endcase
    end

endmodule