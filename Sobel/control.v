`timescale 1ns / 1ps

module control(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        en,
    output reg  [9:0]  addr,    // ROM 접근 주소 (0 ~ 1023)
    output reg conv_fin
);
    
    // ----------------
    // 1) Phase ring (one-hot, 9-bit)
    // ----------------
    reg [8:0] ring;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            ring <= 9'b100000000;        // phase0부터 시작
        else if (en)
            ring <= { ring[7:0], ring[8] };  // rotate right
    end

    // ----------------
    // 2) 9개의 카운터와 init 플래그
    // ----------------
    reg [9:0] count0, count1, count2,
              count3, count4, count5,
              count6, count7, count8;
    reg init0, init1, init2,
        init3, init4, init5,
        init6, init7, init8;

    // offset 값을 parameter로 정의 (00,01,02,32,33,34,64,65,66)
    localparam [9:0] OFF0 = 10'd00,
                     OFF1 = 10'd32,
                     OFF2 = 10'd64,
                     OFF3 = 10'd01,
                     OFF4 = 10'd33,
                     OFF5 = 10'd65,
                     OFF6 = 10'd02,
                     OFF7 = 10'd34,
                     OFF8 = 10'd66;
                     
    // 마지막 주소가 1023에 도달시 fin
    assign addr_fin = (count8 == 10'd1023);
    
    reg d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            d1       <= 1'b0;
            d2       <= 1'b0;
            d3       <= 1'b0;
            d4       <= 1'b0;
            d5       <= 1'b0;
            d6       <= 1'b0;
            d7       <= 1'b0;
            d8       <= 1'b0;
            d9       <= 1'b0;
            d10      <= 1'b0;
            d11      <= 1'b0;
            d12      <= 1'b0;
            
            conv_fin <= 1'b0;
        end
        else begin
            d1       <= addr_fin;
            d2       <= d1;
            d3       <= d2;
            d4       <= d3;
            d5       <= d4;
            d6       <= d5;
            d7       <= d6;
            d8       <= d7;
            d9       <= d8;
            d10      <= d9;
            d11      <= d10;
            d12      <= d11;
            conv_fin <= d12;
        end
    end
    
    // 각 phase별 count 블록 (예: phase0)
    always @(posedge ring[0] or negedge rst_n) begin
        if (!rst_n) begin
            count0 <= OFF0;
            init0  <= 1'b0;
        end else if (en) begin
            if (!init0) init0 <= 1'b1;
            else         
                if(count8 % 32 == 31) count0 <= count0+3;
                else count0 <= count0 + 1;
        end
    end

    // phase1
    always @(posedge ring[1] or negedge rst_n) begin
        if (!rst_n) begin
            count1 <= OFF1;
            init1  <= 1'b0;
        end else if (en) begin
            if (!init1) init1 <= 1'b1;
            else         
                if(count8 % 32 == 31) count1 <= count1+3;
                else count1 <= count1 + 1;
        end
    end

    // phase2
    always @(posedge ring[2] or negedge rst_n) begin
        if (!rst_n) begin
            count2 <= OFF2;
            init2  <= 1'b0;
        end else if (en) begin
            if (!init2) init2 <= 1'b1;
            else         
                if(count8 % 32 == 31) count2 <= count2+3;
                else count2 <= count2 + 1;
        end
    end

    // phase3
    always @(posedge ring[3] or negedge rst_n) begin
        if (!rst_n) begin
            count3 <= OFF3;
            init3  <= 1'b0;
        end else if (en) begin
            if (!init3) init3 <= 1'b1;
            else         
                if(count8 % 32 == 31) count3 <= count3 + 3;
                else count3 <= count3 + 1;
        end
    end

    // phase4
    always @(posedge ring[4] or negedge rst_n) begin
        if (!rst_n) begin
            count4 <= OFF4;
            init4  <= 1'b0;
        end else if (en) begin
            if (!init4) init4 <= 1'b1;
            else         
                if(count8 % 32 == 31) count4 <= count4 + 3;
                else count4 <= count4 + 1;
        end
    end

    // phase5
    always @(posedge ring[5] or negedge rst_n) begin
        if (!rst_n) begin
            count5 <= OFF5;
            init5  <= 1'b0;
        end else if (en) begin
            if (!init5) init5 <= 1'b1;
            else         
                if(count8 % 32 == 31) count5 <= count5+3;
                else count5 <= count5 + 1;
        end
    end

    // phase6
    always @(posedge ring[6] or negedge rst_n) begin
        if (!rst_n) begin
            count6 <= OFF6;
            init6  <= 1'b0;
        end else if (en) begin
            if (!init6) init6 <= 1'b1;
            else         
                if(count8 % 32 == 31) count6 <= count6 + 3;
                else count6 <= count6 + 1;
        end
    end

    // phase7
    always @(posedge ring[7] or negedge rst_n) begin
        if (!rst_n) begin
            count7 <= OFF7;
            init7  <= 1'b0;
        end else if (en) begin
            if (!init7) init7 <= 1'b1;
            else         
                if(count8 % 32 == 31) count7 <= count7 + 3;
                else count7 <= count7 + 1;
        end
    end

    // phase8
    always @(posedge ring[8] or negedge rst_n) begin
        if (!rst_n) begin
            count8 <= OFF8;
            init8  <= 1'b0;
        end else if (en) begin
            if (!init8) init8 <= 1'b1;
            else         
                if(count8 % 32 == 31) count8 <= count8 + 3;
                else count8 <= count8 + 1;
        end
    end

    // ----------------
    // 3) 현재 phase에 대응하는 addr 선택
    // ----------------
    reg [9:0] addr_next;
    always @(*) begin
        case (ring)
            9'b000000001: addr_next = init0 ? count0 : 10'b0;
            9'b000000010: addr_next = init1 ? count1 : 10'b0;
            9'b000000100: addr_next = init2 ? count2 : 10'b0;
            9'b000001000: addr_next = init3 ? count3 : 10'b0;
            9'b000010000: addr_next = init4 ? count4 : 10'b0;
            9'b000100000: addr_next = init5 ? count5 : 10'b0;
            9'b001000000: addr_next = init6 ? count6 : 10'b0;
            9'b010000000: addr_next = init7 ? count7 : 10'b0;
            9'b100000000: addr_next = init8 ? count8 : 10'b0;
            default:       addr_next = 10'b0;
        endcase
    end

    // ----------------
    // 4) addr 출력 레지스터
    // ----------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            addr <= 10'b0;
        else if (en)
            addr <= addr_next;
    end

endmodule
