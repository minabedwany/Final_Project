`timescale 1ns / 1ps

import my_112l_pkg::*;

module if_id_pipe(input clk, input rst, input enable, input if_id_reg d,  output if_id_reg  q);
    always @(posedge clk) begin
        if(rst)begin
			q <= '0;
        end 
		else if( enable ) begin
			q <= d;
        end
    end
endmodule
