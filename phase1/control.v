//主控单元模块
module control (
    input  wire [5:0] opcode,
    input  wire [5:0] funct,
    output reg  [1:0] reg_dst,
    output reg        reg_write,
    output reg        alu_src,
    output reg  [3:0] alu_op
);
    always @(*) begin
        // 默认值
        reg_dst     = 2'bxx;
        reg_write   = 1'bx;
        alu_src     = 1'bx;
        alu_op      = 4'bxxxx;

        case (opcode)
            6'b000000: begin  // 本次实验只需要实现R-type
                reg_dst   = 2'b01; // R-type指令写回rd寄存器
                case (funct)
                    6'b000000: begin // SLL
                        alu_op = 4'b1000; // SLL操作
                        reg_write = 1'b1; 
                    end
   
                    6'b100000: begin // ADD
                        alu_op = 4'b0000; // 加法操作
                        reg_write = 1'b1;
                    end
                    6'b100001: begin // ADDU
                        alu_op = 4'b0001; // 无符号加法操作
                        reg_write = 1'b1;
                    end
                    6'b100011: begin // SUBU 
                        alu_op = 4'b0010; // 无符号减法操作
                        reg_write = 1'b1;
                    end
                    6'b100100: begin // AND
                        alu_op = 4'b0011; // AND操作
                        reg_write = 1'b1;
                    end
                    6'b100101: begin // OR
                        alu_op = 4'b0100; // OR操作
                        reg_write = 1'b1;
                    end
                    6'b101010: begin // SLT
                        alu_op = 4'b0110; // SLT操作
                        reg_write = 1'b1;
                    end                    
                    default: begin
                        alu_op = 4'bxxxx; // 未定义功能码，ALU操作未知
                        reg_write = 1'bx;
                    end
                endcase
                alu_src   = 1'b0; // ALU第二操作数来自寄存器
            end

            6'b001000:begin //addi
                reg_dst = 2'b00; // I-type指令写回rt寄存器
                reg_write = 1'b1;
                alu_src = 1'b1; // ALU第二操作数来自立即数
                alu_op = 4'b0000; // 加法操作

            end

            6'b001001:begin //addiu
                reg_dst = 2'b00; // I-type指令写回rt寄存器
                reg_write = 1'b1;
                alu_src = 1'b1; // ALU第二操作数来自立即数
                alu_op = 4'b0001; // 加法操作
            end

            6'b001100:begin //andi
                reg_dst = 2'b00; // I-type指令写回rt寄存器
                reg_write = 1'b1;
                alu_src = 1'b1; // ALU第二操作数来自立即数
                alu_op = 4'b0011; // AND操作

            end

            6'b001101:begin //ori
                reg_dst = 2'b00; // I-type指令写回rt寄存器
                reg_write = 1'b1;
                alu_src = 1'b1; // ALU第二操作数来自立即数
                alu_op = 4'b0100; // OR操作

            end

            6'b001111:begin //lui
                reg_dst = 2'b00; // I-type指令写回rt寄存器
                reg_write = 1'b1;
                alu_src = 1'b1; // ALU第二操作数来自立即数
                alu_op = 4'b1111; // LUI操作

            end

            default: begin
                reg_write = 1'bx;
                alu_op    = 4'bxxxx;
                reg_dst   = 2'bxx;
            end
        endcase
    end
endmodule