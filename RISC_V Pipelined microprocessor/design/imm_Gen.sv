`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:22:44 PM
// Design Name: 
// Module Name: imm_Gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module imm_Gen(
    input logic [31:0] inst_code,
    output logic [31:0] Imm_out);

always_comb
	case(inst_code[6:0])
        7'b0000011 /*I-type load*/     : 
            Imm_out = {inst_code[31]? 20'b1:20'b0 , inst_code[31:20]};
        7'b0010011 /*I-type*/     : 
			case(inst_code[14:12])
				3'b000: 	//addi
					Imm_out = {inst_code[31]? 20'b1:20'b0 , inst_code[31:20]};
				3'b010:		//slti
					Imm_out = {inst_code[31]? 20'b1:20'b0 , inst_code[31:20]};
				3'b011:		//sltiu
					Imm_out = {inst_code[31]? 20'b1:20'b0 , inst_code[31:20]};
				3'b100:		//xori
					Imm_out = {inst_code[31]? 20'b1:20'b0 , inst_code[31:20]};
				3'b110:		//ori
					Imm_out = {inst_code[31]? 20'b1:20'b0 , inst_code[31:20]};
				3'b111:		//andi
					Imm_out = {inst_code[31]? 20'b1:20'b0 , inst_code[31:20]};
				default: 	//shiftI
					Imm_out = {27'b0, inst_code[24:20]};
			endcase
        7'b0100011 /*S-type*/    : 
            Imm_out = {inst_code[31]? 20'b1:20'b0 , inst_code[31:25], inst_code[11:7]};
		7'b1100011: /*B-type Branch*/
			Imm_out = {inst_code[31]? 20'b1:20'b0 , inst_code[31:25], inst_code[11:7]};
		7'b0110111: //LUI
			Imm_out = {inst_code[31:12], 12'b0};
		7'b0010111: //AUIPC
			Imm_out = {inst_code[31:12], 12'b0};
		7'b1101111:	//Jal
			Imm_out = $signed({inst_code[31]? 20'hfffff:20'h0 , inst_code[31:12]}/32'h100);
		7'b1100111:	//Jalr
			Imm_out = $signed(inst_code[31:20]);
        default                    : 
            Imm_out = {32'b0};
    endcase
    
endmodule
