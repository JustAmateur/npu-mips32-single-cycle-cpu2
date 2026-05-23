//数据存储器模块
module dm(
    input wire clock,
    input  wire        mem_write,       // 写使能
    input  wire [31:0] address,         // 内存地址
    input  wire [31:0] data_in,         // 写数据   
    output wire [31:0] data_out         // 读数据
);

    reg [31:0] data_memory [0:1023];  // 4KB 数据存储器

    // 写操作
    always @(posedge clock) begin
        if (mem_write) begin
            data_memory[address[11:2]] <= data_in; // 使用地址的低12位，右移2位对齐到字边界
        end
    end

    // 读操作
    assign data_out = data_memory[address[11:2]]; // 直接读取数据，地址同样右移2位对齐

endmodule