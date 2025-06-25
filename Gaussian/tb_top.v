`timescale 1ns / 1ps

module tb_top;

    // Inputs
    reg          clk;
    reg          rst_n;
    reg          en;
    wire [47:0]  output_word;
    wire         conv_fin;

    // ---- 추가된 신호 선언 ----
    // 1. 내부 start_conv를 hierarchical 참조할 레지스터
    reg          start_conv_d;

    // 2. 저장용 메모리와 인덱스
    localparam   MEM_DEPTH = 1025;
    reg  [47:0]  out_mem [0:MEM_DEPTH-1];
   
    // --------------------------

    // Instantiate the Unit Under Test (UUT)
    top uut(
        .clk         (clk),
        .rst_n       (rst_n),
        .en          (en),
        .output_word (output_word),
        .conv_fin (conv_fin)
    );

    // Clock generation: 50MHz
    initial clk = 0;
    always #10 clk = ~clk;  // 20ns period

    // -----------------------------------------
    // start_conv 딜레이 + 첫 클럭 스킵 + 캡처
    // -----------------------------------------
    reg          seen_first;  // 첫 번째 이벤트를 봤는지
    integer      idx;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            start_conv_d <= 1'b0;
            seen_first   <= 1'b0;
            idx          <= 0;
        end
        else begin
            // 1clk 딜레이된 start_conv
            start_conv_d <= uut.start_conv;
    
            // 딜레이된 신호가 올라올 때만 처리
            if (start_conv_d) begin
                if (!seen_first) begin
                    // 첫 번째 start_conv_d: 플래그만 세우고 캡처 안 함
                    seen_first <= 1'b1;
                end
                else begin
                    // 그 다음부터는 output_word 캡처
                    out_mem[idx] = output_word;
                    idx = idx + 1;
                end
            end
        end
    end

    // ---- fin 감지시 덤프 & 종료 로직 추가 ----
    always @(posedge clk) begin
        if (conv_fin) begin
            $writememh("output_dump.mem", out_mem, 0, idx-1);
            $display("[%0t] fin detected! Dumped %0d words to output_dump.mem", $time, idx);
            $finish;
        end
    end
    // -----------------------------------------

    initial begin
        // Initialize inputs
        rst_n = 1;
        en    = 0;

        // Reset sequence
        #5  rst_n = 0;
        #2  rst_n = 1;

        // Enable convolution
        #23 en = 1;

        // (기존의 time-based 종료/덤프는 fin이 없으면 동작)
        #200_000;
        $writememh("output_dump.mem", out_mem, 0, idx-1);
        $display("Timeout reached. Dumped %0d words to output_dump.mem", idx);

        $display("Simulation finished.");
        $finish;
    end

endmodule
