`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2017 08:49:25 PM
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


module imm_Gen (
input logic [31:0] inst_code ,
output logic [63:0] Imm_out );

logic [63:0] temp;

always_comb begin
    if (inst_code[6:0] == 7'b0000011) begin 
        temp = {{52{inst_code[31]}}, inst_code[31:20]};
    end
    else if (inst_code[6:0] == 7'b0010011)begin 
        temp = {{52{inst_code[31]}}, inst_code[31:20]};
    end
    else if (inst_code[6:0] == 7'b0100011) begin
        temp = {{52{inst_code[31]}}, inst_code[31:25], inst_code[11:7]};
    end
          
end
assign Imm_out = temp;

endmodule
