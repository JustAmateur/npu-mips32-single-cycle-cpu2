// PC寄存器模块
module pc (
    input  wire        clock,   //时钟信号
    input  wire        reset,   //复位信号，低电平有效
    output reg  [31:0] pc,
    output wire [31:0] pc_plus4
); 

    initial pc = 32'hxxxx_xxxx;    // 初始PC地址设置为0x00003000

    assign pc_plus4 = pc + 32'd4;

    always @(posedge clock) begin  //采用同步复位
        if (!reset)
            pc <= 32'h0000_3000;    // 复位时PC回到初始地址
        else 
            pc <= pc_plus4;   // 时钟上升沿更新PC
    end

endmodule