`timescale 1ns / 1ps

module top(
    input clk,
    input rst_n,
    input en,
    output conv_fin,
    output [47:0] output_word
    );

wire [9:0] addr;
wire [23:0] image_data;

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
wire [7:0] R_window00,R_window01,R_window02;
wire [7:0] R_window10,R_window11,R_window12;
wire [7:0] R_window20,R_window21,R_window22;

wire [7:0] G_window00,G_window01,G_window02;
wire [7:0] G_window10,G_window11,G_window12;
wire [7:0] G_window20,G_window21,G_window22;

wire [7:0] B_window00,B_window01,B_window02;
wire [7:0] B_window10,B_window11,B_window12;
wire [7:0] B_window20,B_window21,B_window22;

Shift_Reg_9 sr9(
    .clk(clk),
    .rst_n(rst_n),
    .din(image_data),
    .en(en),
    .start_conv(start_conv),
    .R_window00(R_window00), .R_window01(R_window01), .R_window02(R_window02),
    .R_window10(R_window10), .R_window11(R_window11), .R_window12(R_window12),
    .R_window20(R_window20), .R_window21(R_window21), .R_window22(R_window22),
    .G_window00(G_window00), .G_window01(G_window01), .G_window02(G_window02),
    .G_window10(G_window10), .G_window11(G_window11), .G_window12(G_window12),
    .G_window20(G_window20), .G_window21(G_window21), .G_window22(G_window22),
    .B_window00(B_window00), .B_window01(B_window01), .B_window02(B_window02),
    .B_window10(B_window10), .B_window11(B_window11), .B_window12(B_window12),
    .B_window20(B_window20), .B_window21(B_window21), .B_window22(B_window22)
    
    
);

conv_9 cv(
    .clk(clk),
    .rst_n(rst_n),
    .start_conv(start_conv),
    .R_window00(R_window00), .R_window01(R_window01), .R_window02(R_window02),
    .R_window10(R_window10), .R_window11(R_window11), .R_window12(R_window12),
    .R_window20(R_window20), .R_window21(R_window21), .R_window22(R_window22),
    .G_window00(G_window00), .G_window01(G_window01), .G_window02(G_window02),
    .G_window10(G_window10), .G_window11(G_window11), .G_window12(G_window12),
    .G_window20(G_window20), .G_window21(G_window21), .G_window22(G_window22),
    .B_window00(B_window00), .B_window01(B_window01), .B_window02(B_window02),
    .B_window10(B_window10), .B_window11(B_window11), .B_window12(B_window12),
    .B_window20(B_window20), .B_window21(B_window21), .B_window22(B_window22),
    .output_word(output_word)
);


endmodule
