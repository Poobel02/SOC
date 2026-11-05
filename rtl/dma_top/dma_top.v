//=============================================================================
// Module : dma_top
// Purpose: SoC integration wrapper for dma_axi64
//=============================================================================

module dma_top (
    // Clock and reset
    input              clk,
    input              resetn,       // Active-low reset at wrapper interface
    input              scan_en,

    // Status / interrupt
    output             idle,
    output             INT,

    // Peripheral request / clear signals
    input      [31:1]  periph_tx_req,
    output     [31:1]  periph_tx_clr,
    input      [31:1]  periph_rx_req,
    output     [31:1]  periph_rx_clr,

    //-------------------------------------------------------------------------
    // APB slave interface - CPU configures DMA registers
    //-------------------------------------------------------------------------
    input              pclken,
    input              psel,
    input              penable,
    input      [12:0]  paddr,
    input              pwrite,
    input      [31:0]  pwdata,
    output     [31:0]  prdata,
    output             pslverr,
    output             pready,

    //-------------------------------------------------------------------------
    // AXI master write address channel
    //-------------------------------------------------------------------------
    output     [0:0]   AWID0,
    output     [31:0]  AWADDR0,
    output     [3:0]   AWLEN0,
    output     [1:0]   AWSIZE0,
    output             AWVALID0,
    input              AWREADY0,

    // AXI master write data channel
    output     [0:0]   WID0,
    output     [63:0]  WDATA0,
    output     [7:0]   WSTRB0,
    output             WLAST0,
    output             WVALID0,
    input              WREADY0,

    // AXI master write response channel
    input      [0:0]   BID0,
    input      [1:0]   BRESP0,
    input              BVALID0,
    output             BREADY0,

    //-------------------------------------------------------------------------
    // AXI master read address channel
    //-------------------------------------------------------------------------
    output     [0:0]   ARID0,
    output     [31:0]  ARADDR0,
    output     [3:0]   ARLEN0,
    output     [1:0]   ARSIZE0,
    output             ARVALID0,
    input              ARREADY0,

    // AXI master read data channel
    input      [0:0]   RID0,
    input      [63:0]  RDATA0,
    input      [1:0]   RRESP0,
    input              RLAST0,
    input              RVALID0,
    output             RREADY0
);

    // dma_axi64 uses an active-high reset input.
    wire reset;
    assign reset = ~resetn;

    //-------------------------------------------------------------------------
    // Instantiate the original DMA RTL top
    //-------------------------------------------------------------------------
    dma_axi64 u_dma_axi64 (
        .clk             (clk),
        .reset           (reset),
        .scan_en         (scan_en),

        .idle            (idle),
        .INT              (INT),

        .periph_tx_req   (periph_tx_req),
        .periph_tx_clr   (periph_tx_clr),
        .periph_rx_req   (periph_rx_req),
        .periph_rx_clr   (periph_rx_clr),

        // APB interface
        .pclken          (pclken),
        .psel            (psel),
        .penable          (penable),
        .paddr            (paddr),
        .pwrite           (pwrite),
        .pwdata           (pwdata),
        .prdata           (prdata),
        .pslverr          (pslverr),
        .pready           (pready),

        // AXI write address
        .AWID0            (AWID0),
        .AWADDR0          (AWADDR0),
        .AWLEN0           (AWLEN0),
        .AWSIZE0          (AWSIZE0),
        .AWVALID0         (AWVALID0),
        .AWREADY0         (AWREADY0),

        // AXI write data
        .WID0             (WID0),
        .WDATA0           (WDATA0),
        .WSTRB0           (WSTRB0),
        .WLAST0           (WLAST0),
        .WVALID0          (WVALID0),
        .WREADY0          (WREADY0),

        // AXI write response
        .BID0             (BID0),
        .BRESP0           (BRESP0),
        .BVALID0          (BVALID0),
        .BREADY0          (BREADY0),

        // AXI read address
        .ARID0            (ARID0),
        .ARADDR0          (ARADDR0),
        .ARLEN0           (ARLEN0),
        .ARSIZE0          (ARSIZE0),
        .ARVALID0         (ARVALID0),
        .ARREADY0         (ARREADY0),

        // AXI read data
        .RID0             (RID0),
        .RDATA0           (RDATA0),
        .RRESP0           (RRESP0),
        .RLAST0           (RLAST0),
        .RVALID0          (RVALID0),
        .RREADY0          (RREADY0)
    );

endmodule

