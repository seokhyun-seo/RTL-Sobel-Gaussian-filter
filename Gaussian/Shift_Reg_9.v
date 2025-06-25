`timescale 1ns / 1ps

module Shift_Reg_9(
    input [23:0] din,
    input rst_n,
    input clk,
    input en,
    output [7:0] R_window00,R_window01,R_window02,
    output [7:0] R_window10,R_window11,R_window12,
    output [7:0] R_window20,R_window21,R_window22,
    
    output [7:0] G_window00,G_window01,G_window02,
    output [7:0] G_window10,G_window11,G_window12,
    output [7:0] G_window20,G_window21,G_window22,
    
    output [7:0] B_window00,B_window01,B_window02,
    output [7:0] B_window10,B_window11,B_window12,
    output [7:0] B_window20,B_window21,B_window22,
    
   
    output start_conv
    );
    reg [7:0] R_window [2:0][2:0];
    reg [7:0] G_window [2:0][2:0];
    reg [7:0] B_window [2:0][2:0];
    reg [3:0] count;
    reg post_en;
    
    assign R_window00 = R_window[0][0]; assign R_window01 = R_window[0][1]; assign R_window02 = R_window[0][2];
    assign R_window10 = R_window[1][0]; assign R_window11 = R_window[1][1]; assign R_window12 = R_window[1][2];
    assign R_window20 = R_window[2][0]; assign R_window21 = R_window[2][1]; assign R_window22 = R_window[2][2];
    
    assign G_window00 = G_window[0][0]; assign G_window01 = G_window[0][1]; assign G_window02 = G_window[0][2];
    assign G_window10 = G_window[1][0]; assign G_window11 = G_window[1][1]; assign G_window12 = G_window[1][2];
    assign G_window20 = G_window[2][0]; assign G_window21 = G_window[2][1]; assign G_window22 = G_window[2][2];
    
    assign B_window00 = B_window[0][0]; assign B_window01 = B_window[0][1]; assign B_window02 = B_window[0][2];
    assign B_window10 = B_window[1][0]; assign B_window11 = B_window[1][1]; assign B_window12 = B_window[1][2];
    assign B_window20 = B_window[2][0]; assign B_window21 = B_window[2][1]; assign B_window22 = B_window[2][2];
    
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
            R_window[0][0] <= 8'b0; R_window[0][1] <= 8'b0; R_window[0][2] <= 8'b0;
            R_window[1][0] <= 8'b0; R_window[1][1] <= 8'b0; R_window[1][2] <= 8'b0;
            R_window[2][0] <= 8'b0; R_window[2][1] <= 8'b0; R_window[2][2] <= 8'b0;
              
        end
        else begin
            if(post_en) begin
                R_window[2][2] <= din[23:16];
                R_window[1][2] <= R_window[2][2];
                R_window[0][2] <= R_window[1][2];
                R_window[2][1] <= R_window[0][2];
                R_window[1][1] <= R_window[2][1];
                R_window[0][1] <= R_window[1][1];
                R_window[2][0] <= R_window[0][1];
                R_window[1][0] <= R_window[2][0];
                R_window[0][0] <= R_window[1][0];
            end
        end
    end
    
      always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            
            G_window[0][0] <= 8'b0; G_window[0][1] <= 8'b0; G_window[0][2] <= 8'b0;
            G_window[1][0] <= 8'b0; G_window[1][1] <= 8'b0; G_window[1][2] <= 8'b0;
            G_window[2][0] <= 8'b0; G_window[2][1] <= 8'b0; G_window[2][2] <= 8'b0;
            
            
            
        end
        else begin
            if(post_en) begin
                G_window[2][2] <= din[15:8];
                G_window[1][2] <= G_window[2][2];
                G_window[0][2] <= G_window[1][2];
                G_window[2][1] <= G_window[0][2];
                G_window[1][1] <= G_window[2][1];
                G_window[0][1] <= G_window[1][1];
                G_window[2][0] <= G_window[0][1];
                G_window[1][0] <= G_window[2][0];
                G_window[0][0] <= G_window[1][0];
            end
        end
    end
    
       always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            
            B_window[0][0] <= 8'b0; B_window[0][1] <= 8'b0; B_window[0][2] <= 8'b0;
            B_window[1][0] <= 8'b0; B_window[1][1] <= 8'b0; B_window[1][2] <= 8'b0;
            B_window[2][0] <= 8'b0; B_window[2][1] <= 8'b0; B_window[2][2] <= 8'b0;
            
            
            
        end
        else begin
            if(post_en) begin
                B_window[2][2] <= din[7:0];
                B_window[1][2] <= B_window[2][2];
                B_window[0][2] <= B_window[1][2];
                B_window[2][1] <= B_window[0][2];
                B_window[1][1] <= B_window[2][1];
                B_window[0][1] <= B_window[1][1];
                B_window[2][0] <= B_window[0][1];
                B_window[1][0] <= B_window[2][0];
                B_window[0][0] <= B_window[1][0];
            end
        end
    end
    
    
endmodule
