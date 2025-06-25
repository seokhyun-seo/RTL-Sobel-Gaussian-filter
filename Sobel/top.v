`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/31 19:28:25
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input clk,
    input rst_n,
    input en,
    output conv_fin,
    output [31:0] output_word
    );

wire [9:0] addr;
wire [7:0] image_data;

control contt(
    .clk(clk),
    .rst_n(rst_n),
    .addr(addr),
    .en(en),
    .conv_fin(conv_fin)
);


ImageROM IR(
    .clk(clk),
    .rst_n(rst_n),
    .en(en),
    .addr(addr),
    .data_out(image_data)
);

wire start_conv;
wire [7:0] window00,window01,window02;
wire [7:0] window10,window11,window12;
wire [7:0] window20,window21,window22;

Shift_Reg_9 sr9(
    .clk(clk),
    .rst_n(rst_n),
    .din(image_data),
    .en(en),
    .start_conv(start_conv),
    .window00(window00), .window01(window01), .window02(window02),
    .window10(window10), .window11(window11), .window12(window12),
    .window20(window20), .window21(window21), .window22(window22)
);

conv_9 cv(
    .clk(clk),
    .rst_n(rst_n),
    .start_conv(start_conv),
    .window00(window00), .window01(window01), .window02(window02),
    .window10(window10), .window11(window11), .window12(window12),
    .window20(window20), .window21(window21), .window22(window22),
    .output_word(output_word)
);


endmodule
