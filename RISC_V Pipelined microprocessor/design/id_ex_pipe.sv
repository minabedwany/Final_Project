`timescale 1ns / 1ps

import my_112l_pkg::*;

module id_ex_pipe(input clk, input rst, input id_ex_reg   d,  output id_ex_reg  q);
    always @(posedge clk) begin
        if(rst)begin
			q <= '0;
        end 
		else q <= d;
    end
endmodule