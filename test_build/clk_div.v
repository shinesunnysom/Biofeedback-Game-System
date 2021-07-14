`timescale 1ns / 1ps
/***************************************************************************
* 
* Filename:	clk_div.v
* Version:	1.0
*
* Notes: 	This clock divider divides the main 100 Mhz clock of the Nexys 4 
*				DDR into a 25 Mhz signal for the benefit of the pixel clock 
*				for VGA implementation.
*
***************************************************************************/
module clk_div(clk, rst, clk_25mhz);
	input 	  clk, rst; 	// Master clock 100 Mhz
	output reg clk_25mhz;	   // Pixel clock 25 Mhz
	
	reg q;
	
	parameter max = 2;
	
	// Change edge every (max) clocks
	always@(posedge clk, posedge rst) begin
		if(rst) begin
			clk_25mhz <= 0;
			q <= 0;
		end	
		else if(q == max - 1) begin
			q <= 0;
			clk_25mhz <= ~clk_25mhz;
		end
		else begin
			q <= q + 1;	 
		end
	end	

endmodule
