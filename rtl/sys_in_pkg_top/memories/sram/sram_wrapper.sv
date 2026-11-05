`timescale 1ns/1ps

module sram_wrapper #(
    parameter int DATA_WIDTH = 32,
    parameter int ADDR_WIDTH = 16,
    parameter int ID_WIDTH   = 4,
    parameter int MEM_DEPTH  = 1024,

    // System address map
    parameter logic [ADDR_WIDTH-1:0] SRAM0_BASE = 16'h1000,
    parameter logic [ADDR_WIDTH-1:0] SRAM1_BASE = 16'h2000
)(
    input logic aclk,
    input logic aresetn,

    // =====================================================
    // AXI PORT 0 : SYSTEM INTERCONNECT -> SRAM0
    // =====================================================

    // Write Address Channel
    input  logic [ID_WIDTH-1:0]   s0_awid,
    input  logic [ADDR_WIDTH-1:0] s0_awaddr,
    input  logic [7:0]            s0_awlen,
    input  logic [2:0]            s0_awsize,
    input  logic [1:0]            s0_awburst,
    input  logic                  s0_awvalid,
    output logic                  s0_awready,

    // Write Data Channel
    input  logic [DATA_WIDTH-1:0] s0_wdata,
    input  logic [DATA_WIDTH/8-1:0] s0_wstrb,
    input  logic                  s0_wlast,
    input  logic                  s0_wvalid,
    output logic                  s0_wready,

    // Write Response Channel
    output logic [ID_WIDTH-1:0]   s0_bid,
    output logic [1:0]            s0_bresp,
    output logic                  s0_bvalid,
    input  logic                  s0_bready,

    // Read Address Channel
    input  logic [ID_WIDTH-1:0]   s0_arid,
    input  logic [ADDR_WIDTH-1:0] s0_araddr,
    input  logic [7:0]            s0_arlen,
    input  logic [2:0]            s0_arsize,
    input  logic [1:0]            s0_arburst,
    input  logic                  s0_arvalid,
    output logic                  s0_arready,

    // Read Data Channel
    output logic [ID_WIDTH-1:0]   s0_rid,
    output logic [DATA_WIDTH-1:0] s0_rdata,
    output logic [1:0]            s0_rresp,
    output logic                  s0_rlast,
    output logic                  s0_rvalid,
    input  logic                  s0_rready,


    // =====================================================
    // AXI PORT 1 : SYSTEM INTERCONNECT -> SRAM1
    // =====================================================

    // Write Address Channel
    input  logic [ID_WIDTH-1:0]   s1_awid,
    input  logic [ADDR_WIDTH-1:0] s1_awaddr,
    input  logic [7:0]            s1_awlen,
    input  logic [2:0]            s1_awsize,
    input  logic [1:0]            s1_awburst,
    input  logic                  s1_awvalid,
    output logic                  s1_awready,

    // Write Data Channel
    input  logic [DATA_WIDTH-1:0] s1_wdata,
    input  logic [DATA_WIDTH/8-1:0] s1_wstrb,
    input  logic                  s1_wlast,
    input  logic                  s1_wvalid,
    output logic                  s1_wready,

    // Write Response Channel
    output logic [ID_WIDTH-1:0]   s1_bid,
    output logic [1:0]            s1_bresp,
    output logic                  s1_bvalid,
    input  logic                  s1_bready,

    // Read Address Channel
    input  logic [ID_WIDTH-1:0]   s1_arid,
    input  logic [ADDR_WIDTH-1:0] s1_araddr,
    input  logic [7:0]            s1_arlen,
    input  logic [2:0]            s1_arsize,
    input  logic [1:0]            s1_arburst,
    input  logic                  s1_arvalid,
    output logic                  s1_arready,

    // Read Data Channel
    output logic [ID_WIDTH-1:0]   s1_rid,
    output logic [DATA_WIDTH-1:0] s1_rdata,
    output logic [1:0]            s1_rresp,
    output logic                  s1_rlast,
    output logic                  s1_rvalid,
    input  logic                  s1_rready
);

    // =====================================================
    // LOCAL ADDRESS GENERATION
    // =====================================================

    logic [ADDR_WIDTH-1:0] sram0_awaddr_local;
    logic [ADDR_WIDTH-1:0] sram0_araddr_local;

    logic [ADDR_WIDTH-1:0] sram1_awaddr_local;
    logic [ADDR_WIDTH-1:0] sram1_araddr_local;

    // Convert system addresses into local SRAM addresses.
    assign sram0_awaddr_local = s0_awaddr - SRAM0_BASE;
    assign sram0_araddr_local = s0_araddr - SRAM0_BASE;

    assign sram1_awaddr_local = s1_awaddr - SRAM1_BASE;
    assign sram1_araddr_local = s1_araddr - SRAM1_BASE;


    // =====================================================
    // SRAM0 INSTANCE
    // =====================================================

    sram0 #(
        .DATA_WIDTH (DATA_WIDTH),
        .ADDR_WIDTH (ADDR_WIDTH),
        .ID_WIDTH   (ID_WIDTH),
        .MEM_DEPTH  (MEM_DEPTH)
    ) u_sram0 (

        .aclk       (aclk),
        .aresetn    (aresetn),

        // Write Address
        .awid       (s0_awid),
        .awaddr     (sram0_awaddr_local),
        .awlen      (s0_awlen),
        .awsize     (s0_awsize),
        .awburst    (s0_awburst),
        .awvalid    (s0_awvalid),
        .awready    (s0_awready),

        // Write Data
        .wdata      (s0_wdata),
        .wstrb      (s0_wstrb),
        .wlast      (s0_wlast),
        .wvalid     (s0_wvalid),
        .wready     (s0_wready),

        // Write Response
        .bid        (s0_bid),
        .bresp      (s0_bresp),
        .bvalid     (s0_bvalid),
        .bready     (s0_bready),

        // Read Address
        .arid       (s0_arid),
        .araddr     (sram0_araddr_local),
        .arlen      (s0_arlen),
        .arsize     (s0_arsize),
        .arburst    (s0_arburst),
        .arvalid    (s0_arvalid),
        .arready    (s0_arready),

        // Read Data
        .rid        (s0_rid),
        .rdata      (s0_rdata),
        .rresp      (s0_rresp),
        .rlast      (s0_rlast),
        .rvalid     (s0_rvalid),
        .rready     (s0_rready)
    );


    // =====================================================
    // SRAM1 INSTANCE
    // =====================================================

    sram1 #(
        .DATA_WIDTH (DATA_WIDTH),
        .ADDR_WIDTH (ADDR_WIDTH),
        .ID_WIDTH   (ID_WIDTH),
        .MEM_DEPTH  (MEM_DEPTH)
    ) u_sram1 (

        .aclk       (aclk),
        .aresetn    (aresetn),

        // Write Address
        .awid       (s1_awid),
        .awaddr     (sram1_awaddr_local),
        .awlen      (s1_awlen),
        .awsize     (s1_awsize),
        .awburst    (s1_awburst),
        .awvalid    (s1_awvalid),
        .awready    (s1_awready),

        // Write Data
        .wdata      (s1_wdata),
        .wstrb      (s1_wstrb),
        .wlast      (s1_wlast),
        .wvalid     (s1_wvalid),
        .wready     (s1_wready),

        // Write Response
        .bid        (s1_bid),
        .bresp      (s1_bresp),
        .bvalid     (s1_bvalid),
        .bready     (s1_bready),

        // Read Address
        .arid       (s1_arid),
        .araddr     (sram1_araddr_local),
        .arlen      (s1_arlen),
        .arsize     (s1_arsize),
        .arburst    (s1_arburst),
        .arvalid    (s1_arvalid),
        .arready    (s1_arready),

        // Read Data
        .rid        (s1_rid),
        .rdata      (s1_rdata),
        .rresp      (s1_rresp),
        .rlast      (s1_rlast),
        .rvalid     (s1_rvalid),
        .rready     (s1_rready)
    );

endmodule
