`timescale 1ns / 1ps
/***************************************************************************
* 
* Filename:	top.v
* Version:	1.0
*
* Notes: 	VGA controller. Cycles through the pixels of a 640x480 resolution.
*				Triggers Horizontal and Vertical Sync at each ends. 
*
***************************************************************************/
module vga_sync(clk, rst, hsync, vsync, hc, vc);

	input       clk, rst;
	
	output 		 	  hsync, vsync;		// Horizontal Sync/Vertical Sync
	output reg [9:0] hc, vc;				// Horizontal Counter/Vertical Counter

	

	// Video Structure Constants 640 x 480 (60 Hz) with 25 Mhz Pixel Clock
	parameter HD = 640,  // horizontal display area
				 HF = 16,   // left border/front porch
				 HB = 48,   // right border/back porch
				 HR = 96,   // horizontal retrace
				 VD = 480,  // vertical display area
				 VF = 10,   // bottom border/front porch
				 VB = 33,   // top border/back porch
				 VR = 2;    // vertical retrace
				 
	//////////////////////////////////////////////////////////////////
	//		VGA SYNC CONTROLLER													 //
	//////////////////////////////////////////////////////////////////
	
	// Wires to check for horizontal and vertical ends
	wire h_end;
	wire v_end;
	
	// end of horizontal counter 
	assign h_end = (hc == (HD+HF+HB+HR-1));

	// end of vertical counter
	assign v_end = (vc == (VD+VF+VB+VR-1));
	
	// This is where we move through the pixels
	always@(posedge clk, posedge rst) begin
		if(rst) begin
			hc <= 0; 
			vc <= 0;
		end
		else begin
			if(h_end) begin
				hc <= 10'b0;
				if(v_end) vc <= 10'b0;
				else 		 vc <= vc + 1'b1;
			end
			else begin
				hc <= hc + 1'b1;
			end
		end
	end
	
	// Establish Horizontal and Vertical Sync Signals
	assign hsync = ~(hc >= (HD+HF) && hc <= (HD+HF+HR - 1));
	assign vsync = ~(vc >= (VD+VF) && vc <= (VD+VF+VR - 1));
	
endmodule
