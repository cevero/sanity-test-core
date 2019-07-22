

module tb_sanity_test_core;
    parameter test_file = "fibonacci.bin";

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
        static integer start = 32;  // Start position in memory words (4-bytes) to start copying
                                    // start = 32 is the position equivalent to position 0x80 (bytes), and this is the start address for
                                    // the zero-riscy core
        static integer count = 15;  // Number of words (4-bytes) to copy from the file to memory

        $display("file = %s", {"input_files/", test_file});
        file = $fopen({"input_files/", test_file}, "r");
        error = $ferror(file, err_str);
        if (error != 0) begin
            $display("erro = %s", err_str);
        end
        $display("file = %b", file);
        $fread(dut.inst_mem.mem, file, start);
    end

    initial clk_i = 0;
    always #1 clk_i = ~clk_i;

    string inst_program;

    initial begin
        rst_ni = 0;
        fetch_en_i = 0;
        #1;

        rst_ni = 1;
        fetch_en_i = 1;
        #600 $finish;
    end

    logic [31:0] instruction;
    assign instruction = dut.core_0.id_stage_i.instr_rdata_i;

    always @(posedge clk_i) begin
        if (dut.core_0.id_stage_i.id_ready_o &&
            dut.core_0.id_stage_i.id_valid_o &&
            dut.core_0.id_stage_i.is_decoding_o &&
            dut.core_0.ex_block_i.ex_ready_o) begin
            string inst;
            $sformat(inst, "%8h", instruction);
            inst_program = {inst_program,inst};
        end

        if (^(dut.core_0.id_stage_i.instr_rdata_i)=== 1'bX) begin
            $display("executed instructions - hex dump: %s",inst_program);
            #1 $finish;
        end
    end

endmodule
