`timescale 1ns / 1ps
/***************************************************************************
* 
* Filename:	top.v
* Version:	1.0
*
* Notes: 	Graphics module. Sends color bits depending on request, so pictures
*				and models appear on the screen
*
***************************************************************************/
module Graphics(clk, rst, ref_tick, hc, vc, player_draw, player_color, BG_draw,
						red, green, blue);
	input 		clk, rst;
	input 		player_draw;
	input			player_color;
	input 		BG_draw;
	input [9:0]	hc, vc; 

	
	output wire 	  ref_tick;
	output reg [3:0] red, green, blue;
	
	// PARAMETERS
	
	parameter MAX_X = 640;
	parameter MAX_Y = 480;
	
	// Delays movement to every start of vsync or every refresh
	assign ref_tick = ((hc == 0) && (vc == MAX_Y + 1));
	
	
	/////////////////////////////////////////////////////////////////////
	//		VGA DISPLAY CONTROL														 //
	/////////////////////////////////////////////////////////////////////
	
	always@(*) begin 
		if(player_draw) begin
			if(player_color) begin
				red = 4'b1001;
				green = 4'b0000;
				blue = 4'b0000;
			end
			else begin
				red = 4'b0000;
				green = 4'b0000;
				blue = 4'b0000;
			end
		end
		else if(BG_draw) begin
			red = 4'b1111;
			green = 4'b1111;
			blue = 4'b1111;
		end
		else begin
			red = 4'b0000;
			green = 4'b0000;
			blue = 4'b0000;
		end	
	end

endmodule
