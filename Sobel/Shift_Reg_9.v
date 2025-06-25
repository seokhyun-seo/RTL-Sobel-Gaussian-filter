`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/10 02:10:18
// Design Name: 
// Module Name: Shift_Reg_9
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


module Shift_Reg_9(
    input [7:0] din,
    input rst_n,
    input clk,
    input en,
    output [7:0] window00,window01,window02,
    output [7:0] window10,window11,window12,
    output [7:0] window20,window21,window22,
    output start_conv
    );
    reg [7:0] window [2:0][2:0];
    reg [3:0] count;
    reg post_en;
    
    assign window00 = window[0][0]; assign window01 = window[0][1]; assign window02 = window[0][2];
    assign window10 = window[1][0]; assign window11 = window[1][1]; assign window12 = window[1][2];
    assign window20 = window[2][0]; assign window21 = window[2][1]; assign window22 = window[2][2];
    
    assign start_conv = (count == 4'd9);
    
    reg en_d1, en_d2;

    always @(posedge clk) begin
        if (!rst_n) begin
            en_d1 <= 0;
            en_d2 <= 0;
        end else begin
            en_d1 <= en;        // 1클럭 지연
            en_d2 <= en_d1;
            post_en <= en_d2;    // 2클럭 지연
        end
    end
    
 
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            count <= 4'd0;
        end
        else begin
            if(post_en) begin
                if(count == 4'd9) count <= 4'd1;
                else count <= count+1;
            end
        end
    end
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            window[0][0] <= 8'b0; window[0][1] <= 8'b0; window[0][2] <= 8'b0;
            window[1][0] <= 8'b0; window[1][1] <= 8'b0; window[1][2] <= 8'b0;
            window[2][0] <= 8'b0; window[2][1] <= 8'b0; window[2][2] <= 8'b0;
        end
        else begin
            if(post_en) begin
                window[2][2] <= din;
                window[1][2] <= window[2][2];
                window[0][2] <= window[1][2];
                window[2][1] <= window[0][2];
                window[1][1] <= window[2][1];
                window[0][1] <= window[1][1];
                window[2][0] <= window[0][1];
                window[1][0] <= window[2][0];
                window[0][0] <= window[1][0];
            end
        end
    end
    
    
endmodule
