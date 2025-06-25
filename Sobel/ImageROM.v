`timescale 1ns / 1ps


module ImageROM (
    input clk,
    input rst_n,
    input en,
    input [9:0] addr,
    output reg [7:0] data_out
);
    reg en_d;
    reg post_en;
    
    always @(posedge clk) begin
        if (!rst_n) begin
            en_d     <= 0;
            post_en  <= 0;
        end else begin
            en_d     <= en;             // 1클럭 전의 en 저장
            post_en  <= en_d;           // 1클럭 뒤에 반영
        end
    end

    reg [7:0] rom [0:1023];

    initial begin
        $readmemh("input.mem", rom);
    end

    always @(posedge clk) begin
        if(!rst_n) begin
            data_out <= 0;
        end
        else 
            if (post_en) data_out <= rom[addr];
            
    end

endmodule
