`timescale 1ns / 1ps

module conv_9(
    input clk,
    input rst_n,
    input start_conv,
    
    input [7:0] R_window00,R_window01,R_window02,
    input [7:0] R_window10,R_window11,R_window12,
    input [7:0] R_window20,R_window21,R_window22,
    
    input [7:0] G_window00,G_window01,G_window02,
    input [7:0] G_window10,G_window11,G_window12,
    input [7:0] G_window20,G_window21,G_window22,
    
    input [7:0] B_window00,B_window01,B_window02,
    input [7:0] B_window10,B_window11,B_window12,
    input [7:0] B_window20,B_window21,B_window22,
    
    output reg [47:0] output_word
    );
    reg signed [15:0] conv_temp_r, conv_temp_g, conv_temp_b;
    
    // Gaussian 
localparam  [7:0] k00 = 1, k01 = 2, k02 = 1;
localparam   [7:0] k10 = 2, k11 = 4, k12 = 2;
localparam   [7:0] k20 = 1, k21 = 2, k22 = 1;

    
    
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            output_word <= 48'd0;
            conv_temp_r <=8'd0;
        end
        else begin
            if (start_conv) begin
                
                conv_temp_r <=
                      k00 * ({1'b0, R_window00}) + k01 * ({1'b0, R_window01}) + k02 * ({1'b0, R_window02})
                    + k10 * ({1'b0, R_window10}) + k11 * ({1'b0, R_window11}) + k12 * ({1'b0, R_window12})
                    + k20 * ({1'b0, R_window20}) + k21 * ({1'b0, R_window21}) + k22 * ({1'b0, R_window22});
    
              conv_temp_g <=
                      k00 * ({1'b0, G_window00}) + k01 * ({1'b0, G_window01}) + k02 * ({1'b0, G_window02})
                    + k10 * ({1'b0, G_window10}) + k11 * ({1'b0, G_window11}) + k12 * ({1'b0, G_window12})
                    + k20 * ({1'b0, G_window20}) + k21 * ({1'b0, G_window21}) + k22 * ({1'b0, G_window22});
    
    conv_temp_b <=
                      k00 * ({1'b0, B_window00}) + k01 * ({1'b0, B_window01}) + k02 * ({1'b0, B_window02})
                    + k10 * ({1'b0, B_window10}) + k11 * ({1'b0, B_window11}) + k12 * ({1'b0, B_window12})
                    + k20 * ({1'b0, B_window20}) + k21 * ({1'b0, B_window21}) + k22 * ({1'b0, B_window22});
                
                output_word <= {(conv_temp_r>>4), (conv_temp_g>>4), (conv_temp_b>>4)}; 
            end
        end
    end


endmodule
