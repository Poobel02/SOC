module cpu_wrapper (

    // Clock and Reset
    input  logic        clk,
    input  logic        rst,
    input  logic        en,

    // CPU Status
    output logic        halted,

    // Instruction Memory Interface
    output logic        isram_en,
    output logic [9:0]  isram_addr,
    input  logic [31:0] isram_rdata,
    input  logic        isram_rready,

    // Data Memory Interface
    output logic        dsram_en,
    output logic        dsram_write_en,
    output logic [9:0]  dsram_addr,
    output logic [31:0] dsram_wdata,
    input  logic [31:0] dsram_rdata,
    input  logic        dsram_rready

);

    // Existing CPU instance
    cpu_top u_cpu (

        .clk           (clk),
        .rst           (rst),
        .en            (en),
        .halted        (halted),

        .isram_en      (isram_en),
        .isram_addr    (isram_addr),
        .isram_rdata   (isram_rdata),
        .isram_rready  (isram_rready),

        .dsram_en      (dsram_en),
        .dsram_write_en(dsram_write_en),
        .dsram_addr    (dsram_addr),
        .dsram_wdata   (dsram_wdata),
        .dsram_rdata   (dsram_rdata),
        .dsram_rready  (dsram_rready)

    );

endmodule

