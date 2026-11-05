// Standard ALU implementation a(32), b(32), sel(2), out(32)

module alu (

    input  logic [2:0]  alu_op_i, // sel(
    input  logic [31:0] rs1_data, // a(32)
    input  logic [31:0] rs2_data, // b(32)
    output logic [31:0] rd_data // out(32)

);

    always_comb begin
        rd_data = 'x;
        case (alu_op_i)
            3'b000:  rd_data = rs1_data + rs2_data;
            3'b001:  rd_data = rs1_data - rs2_data;
            3'b010:  rd_data = rs1_data << rs2_data[4:0];
            3'b011:  rd_data = rs1_data >> rs2_data[4:0];
            default: rd_data = '0; 
        endcase
    end

endmodule

