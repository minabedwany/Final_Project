`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2017 08:48:37 PM
// Design Name: 
// Module Name: regfile
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


module regfile #(
parameter DATA_WIDTH = 64,
parameter ADDRESS_WIDTH = 5,
parameter REGISTER_SIZE = 2** ADDRESS_WIDTH
)(
input logic clk , reset, // Clock Signal
input logic RegWrite , // Register Write Signal , comes from control unit
input logic [ ADDRESS_WIDTH -1:0] ra1 , ra2 , wa , // Read address 1 // Read address 2 // Write address
input logic [ DATA_WIDTH -1:0] wd , // Write Data
output logic [ DATA_WIDTH -1:0] rd1 , rd2 // Read Data 1, Read Data 2
);

logic [DATA_WIDTH - 1:0]temp1;
logic [DATA_WIDTH - 1:0]temp2;
//logic [31:0]temp3;

logic [ DATA_WIDTH -1:0] reg_file [REGISTER_SIZE -1:0];


always_ff @(negedge clk) begin
    if (reset == 1'b1) begin
        for (int i=0; i <32; i= i+1) begin
            reg_file[i] = 'b0;
        end
        temp1 <= 32'b0; 
        temp2 <= 32'b0;
        
    end
    else if (RegWrite == 1'b1) begin
        reg_file[wa] <= wd;
    end
    else if (RegWrite == 1'b0) begin
        temp1 <= reg_file[ra1];
        temp2 <= reg_file[ra2];
    end
end

assign rd1 = temp1;
assign rd2 = temp2;

endmodule
