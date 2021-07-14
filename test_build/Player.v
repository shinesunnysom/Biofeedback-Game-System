`timescale 1ns / 1ps
/***************************************************************************
* 
* Filename:	top.v
* Version:	1.0
*
* Notes: 	Player module. Controls player look and gameplay design.
*
***************************************************************************/
module Player(clk, rst, state, hc, vc, ref_tick, player_draw, player_color);
	input 		clk, rst;
	input			ref_tick;
	input [9:0] hc, vc;
	input [4:0] state;
	
	output reg player_draw;		// Signal to draw player
	output reg player_color;	// Color pallete
	
	
	parameter MAX_X = 640;
	parameter MAX_Y = 475;
	
	
	//////////////////////////////////////////////////////////////////
	//		Player Movement Control												 //
	//////////////////////////////////////////////////////////////////
	reg [9:0] player_left;		// Player left border
	reg [9:0] player_right;		// Player right border
	reg [9:0] player_up;			// Player upper border
	reg [9:0] player_down;		// Player bottom border

	always@(posedge clk, posedge rst) begin
		// Initial Position 
		if(rst) begin
			player_left <= 1;
			player_right <= 21;
			player_up <= 1;
			player_down <= 21;
		end
		// Movement 
		else if(ref_tick) begin
			if(state[0]) begin
				if(player_up >= 5) begin
					player_up <= player_up - 5;
					player_down <= player_down - 5;
				end
			end
			if(state[1]) begin
				if(player_down <= MAX_Y) begin
					player_up <= player_up + 5;
					player_down <= player_down + 5;
				end
			end
			if(state[2]) begin
				if(player_left >= 5) begin
					player_left <= player_left - 5;
					player_right <= player_right - 5;
				end
			end
			if(state[3]) begin
				if(player_right <= MAX_X) begin
					player_left <= player_left + 5;
					player_right <= player_right + 5;
				end
			end
		end
	end
	
	//////////////////////////////////////////////////////////////////
	//		Player Shoot Mechanic												 //
	//////////////////////////////////////////////////////////////////
	
	
	//////////////////////////////////////////////////////////////////
	//		Player Look Design													 //
	//////////////////////////////////////////////////////////////////
	
	reg		  	color;
	reg  [19:0] player_figure [0:19];
	wire [19:0] x;
	wire [19:0] y;
	
	assign x = hc - player_left;
	assign y = vc - player_up;
	
	always@(posedge rst) begin
		if(rst) begin
			player_figure[0][19:0]  <= 20'b00000000000000000000;
			player_figure[1][19:0]  <= 20'b00000000110000000000;
			player_figure[2][19:0]  <= 20'b00000001111000000000;
			player_figure[3][19:0]  <= 20'b00000001111000000000;
			player_figure[4][19:0]  <= 20'b00000001111000000000;
			player_figure[5][19:0]  <= 20'b00000001111000000000;
			player_figure[6][19:0]  <= 20'b00000111111110000000;
			player_figure[7][19:0]  <= 20'b11000111111110001100;
			player_figure[8][19:0]  <= 20'b11000111111110001100;
			player_figure[9][19:0]  <= 20'b11111111111111111100;
			player_figure[10][19:0] <= 20'b11111111111111111100;
			player_figure[11][19:0] <= 20'b11111111111111111100;
			player_figure[12][19:0] <= 20'b11111111111111111100;
			player_figure[13][19:0] <= 20'b00011111111111100000;
			player_figure[14][19:0] <= 20'b00011111111111100000;
			player_figure[15][19:0] <= 20'b00011111111111100000;
			player_figure[16][19:0] <= 20'b00011111111111100000;
			player_figure[17][19:0] <= 20'b00001110000111000000;
			player_figure[18][19:0] <= 20'b00001110000111000000;
			player_figure[19][19:0] <= 20'b00000000000000000000;
		end
	end
	
	//////////////////////////////////////////////////////////////////
	//		VGA OUTPUT																 //
	//////////////////////////////////////////////////////////////////
	
	// Player Display
	always@(*) begin
		if(hc > player_left && hc < player_right && vc > player_up && vc < player_down) begin
			player_draw = 1'b1;
			if(player_figure[y][x] == 1) begin
				// Draw Red
				player_color = 1'b1;
			end
			else begin
				// Draw Black
				player_color = 1'b0;
			end
		end
		else begin
			player_draw = 1'b0;
		end
	end
	

endmodule
