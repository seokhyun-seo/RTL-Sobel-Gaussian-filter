`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/10 03:44:11
// Design Name: 
// Module Name: conv_9
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


module conv_9(
    input clk,
    input rst_n,
    input start_conv,
    input [7:0] window00,window01,window02,
    input [7:0] window10,window11,window12,
    input [7:0] window20,window21,window22,
    output reg [31:0] output_word
    );
    reg signed [17:0] conv_temp_x, conv_temp_y;
    
    // Sobel Gx Kernel (signed 8-bit)
    localparam signed [7:0] k00 = -1, k01 = 0,  k02 = 1;
    localparam signed [7:0] k10 = -2, k11 = 0,  k12 = 2;
    localparam signed [7:0] k20 = -1, k21 = 0,  k22 = 1;

    // Sobel Gy Kernel (signed 8-bit)
    localparam signed [7:0] kGx00 = -1, kGx01 = -2, kGx02 = -1;
    localparam signed [7:0] kGx10 = 0,  kGx11 = 0,  kGx12 = 0;
    localparam signed [7:0] kGx20 = 1,  kGx21 = 2,  kGx22 = 1;
    
    
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            output_word <= 32'd0;
            conv_temp_x <= 18'd0;
            conv_temp_y <= 18'd0;
        end
        else begin
            if (start_conv) begin
                // 1. Sobel X (Gx) direction convolution
                conv_temp_x <=
                      k00 * $signed({1'b0, window00}) + k01 * $signed({1'b0, window01}) + k02 * $signed({1'b0, window02})
                    + k10 * $signed({1'b0, window10}) + k11 * $signed({1'b0, window11}) + k12 * $signed({1'b0, window12})
                    + k20 * $signed({1'b0, window20}) + k21 * $signed({1'b0, window21}) + k22 * $signed({1'b0, window22});
    
                // 2. Sobel Y (Gy) direction convolution
                conv_temp_y <=
                      kGx00 * $signed({1'b0, window00}) + kGx01 * $signed({1'b0, window01}) + kGx02 * $signed({1'b0, window02})
                    + kGx10 * $signed({1'b0, window10}) + kGx11 * $signed({1'b0, window11}) + kGx12 * $signed({1'b0, window12})
                    + kGx20 * $signed({1'b0, window20}) + kGx21 * $signed({1'b0, window21}) + kGx22 * $signed({1'b0, window22});
    
                // 3. Concatenate Sobel X and Sobel Y to form 32-bit output
                output_word <= {conv_temp_x[15:0], conv_temp_y[15:0]}; // {sobel_x[15:0], sobel_y[15:0]}
            end
        end
    end

endmodule
