module tb_sanity_test_core;

    logic        clk_i;
    logic        rst_ni;
    logic        fetch_en_i;
    logic [31:0] mem_flag;
    logic [31:0] mem_result;
    logic [31:0] instr_addr_0;

    sanity_soc dut
    (
        .clk_i          (clk_i       ),
        .rst_ni         (rst_ni      ),
        .fetch_enable_i (fetch_en_i  ),
        .instr_addr_o_0 (instr_addr_0)
    );

    initial begin
        // https://www.hdlworks.com/hdl_corner/verilog_ref/items/SystemFileTasks.htm
        reg [639:0] err_str;
        integer error;
        integer file; // file descriptor
        static integer start = 32; // Start position in memory words (4-bytes) to start copying
        // start = 32 is the position equivalent to position 0x80 (bytes), and this is the start address for
        // the zero-riscy core
        static integer count = 15; // Number of words (4-bytes) to copy from the file to memory

        file = $fopen("input_files/fibonacci.bin", "r");
        error = $ferror(file, err_str);
        if (error != 0) begin
            $display("erro = %s", err_str);
        end
        $display("file = %b", file);
        $fread(dut.inst_mem.mem, file, start, count);
    end

    initial clk_i = 0;
    always #1 clk_i = ~clk_i;

    assign mem_flag = dut.data_mem.mem[0];
    assign mem_result = dut.data_mem.mem[1];
      
    initial begin
        $display("time | inst_addr_0 | mem_flag | mem_result |\n");
        $monitor ("%4t | %11h | %8b | %10d |", $time, instr_addr_0, mem_flag, mem_result);

        rst_ni = 0;
        fetch_en_i = 0;
        #1;

        rst_ni = 1;
        fetch_en_i = 1;
        #600 $finish;
    end

    always @*
      if (mem_flag)
          #1 $finish;

endmodule
