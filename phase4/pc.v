// PC寄存器模块
module pc (
    input  wire        clock,   //时钟信号
    input  wire        reset,   //复位信号，低电平有效
    input  wire [31:0] branch_offset, // 分支偏移量(在译码阶段完成拓展)
    input  wire [25:0] jump_offset,   // 跳转偏移量
    input  wire [31:0] jr_addr,     // jr指令使用的寄存器地址
    input  wire        zero,         // ALU零标志
    input  wire [1:0]  pc_src,       // PC选择信号
    output reg  [31:0] pc,
    output wire [31:0] pc_plus4
); 

    initial pc = 32'hxxxx_xxxx;    // 初始PC地址设置为0x00003000

    assign pc_plus4 = pc + 32'd4;
    wire [31:0] branch_addr = pc_plus4 + branch_offset;
    wire [31:0] jump_addr = {pc_plus4[31:28], jump_offset[25:0], 2'b00};
    
    always @(posedge clock) begin  //采用同步复位
        if (!reset)
            pc <= 32'h0000_3000;    // 复位时PC回到初始地址
        else if (pc_src == 2'b00)
            pc <= pc_plus4;   // 时钟上升沿更新PC
        else if (pc_src == 2'b01)
            pc <= zero ? branch_addr : pc_plus4; // 分支指令，根据zero标志选择分支地址或下一条指令地址
        else if (pc_src == 2'b10)
            pc <= jump_addr;   // 跳转指令，更新PC为跳转地址
        else if (pc_src == 2'b11)
            pc <= jr_addr;     // jr指令，更新PC为寄存器地址
    end

endmodule
