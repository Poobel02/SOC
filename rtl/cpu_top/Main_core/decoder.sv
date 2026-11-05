/* The purpose of a decoder is to look at the instruction and 
   figure out what the control signals (9-14) should be for the 
   register file and the various MUXs in the datapath */

module decoder (
    input logic [31:0] core_isram_rdata_i,
    output logic [4:0] rs1_addr_o,
    output logic [4:0] rs2_addr_o,
    output logic rd_write_en_o,              
    output logic [4:0] rd_addr_o,
    output logic is_beq_o,                   
    output logic [2:0] alu_op_o,

    output logic wb_sel_memory_o,            
    output logic dmem_wr_en_o,               
    output logic dmem_en_o,                  

    output logic alu_src_imm_o,              
    output logic is_ebreak_o,                
    output logic [31:0] imm_o                
);

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [7:0] funct7;

    assign opcode = core_isram_rdata_i[6:0];
    assign funct3 = core_isram_rdata_i[14:12];
    assign funct7 = core_isram_rdata_i[31:25];
    assign rs1_addr_o = core_isram_rdata_i[19:15];
    assign rs2_addr_o = core_isram_rdata_i[24:20];
    assign rd_addr_o = core_isram_rdata_i[11:7];

    always_comb begin
        // Set predictable safe defaults to prevent latches
        alu_op_o = 3'b000;
        rd_write_en_o = 1'b0;
        is_beq_o = 1'b0;
        wb_sel_memory_o = 1'b0;
        dmem_wr_en_o = 1'b0;
        dmem_en_o = 1'b0;
        alu_src_imm_o = 1'b0;
        is_ebreak_o = 1'b0;
        imm_o = '0;

        case (opcode)
            7'b0110011: begin // R-Type
                rd_write_en_o = 1'b1;
                case (funct3)
                    3'b000: begin // add, sub
                        if (funct7[5]) // Bit 30 identifies SUB
                            alu_op_o = 3'b001;
                        else
                            alu_op_o = 3'b000;
                    end
                    3'b001: alu_op_o = 3'b010; // sll
                    3'b101: alu_op_o = 3'b011; // srl
                endcase
            end
            
            7'b0010011: begin // I-Type (ADDI, etc)
                rd_write_en_o = 1'b1;
                alu_src_imm_o = 1'b1;
                // Reliable explicit sign extension block
                imm_o = {{20{core_isram_rdata_i[31]}}, core_isram_rdata_i[31:20]};
                case (funct3)
                    3'b000: alu_op_o = 3'b000; // addi
                endcase
            end
            
            7'b0000011: begin // L-Type (Load)
                wb_sel_memory_o = 1'b1;
                dmem_en_o = 1'b1;
                rd_write_en_o = 1'b1;
                alu_src_imm_o = 1'b1;
                imm_o = {{20{core_isram_rdata_i[31]}}, core_isram_rdata_i[31:20]};
                case (funct3)
                    3'b010: alu_op_o = 3'b000; // lw
                endcase
            end
            
            7'b0100011: begin // S-Type (Store)
                dmem_en_o = 1'b1;
                dmem_wr_en_o = 1'b1;
                alu_src_imm_o = 1'b1;
                imm_o = {{20{core_isram_rdata_i[31]}}, core_isram_rdata_i[31:25], core_isram_rdata_i[11:7]};
                case (funct3)
                    3'b010: alu_op_o = 3'b000; // sw
                endcase
            end
            
            7'b1100011: begin // B-Type (BEQ)
                is_beq_o = 1'b1;
                imm_o = {{20{core_isram_rdata_i[31]}}, core_isram_rdata_i[7], core_isram_rdata_i[30:25], core_isram_rdata_i[11:8], 1'b0};
            end
            
            7'b1110011: begin // System Instructions
               is_ebreak_o = 1'b1;
            end
        endcase
    end
endmodule


