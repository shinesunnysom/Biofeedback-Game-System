`timescale 1ns / 1ps
/***************************************************************************
* 
* Filename:	clk_div.v
* Version:	1.0
*
* Notes: 	Using the codes received from the keyboard, determines player's 
*				action 
*
***************************************************************************/
module Control_Scheme(clk, keycode, state);

	input 		 clk;
	input [31:0] keycode;	// Keyboard Scan Codes
	 
	output reg [4:0] state;		// Command Signals

	always@(posedge clk) begin
		// MOVEMENT CONTROL
		if(keycode[7:0] == 8'h75) 			state[0] <= 1'b1;
		if(keycode[7:0] == 8'h72)			state[1] <= 1'b1;
		if(keycode[7:0] == 8'h6B)			state[2] <= 1'b1;
		if(keycode[7:0] == 8'h74)			state[3] <= 1'b1;
		if(keycode[15:0] == 16'hF075)		state[0] <= 1'b0;
		if(keycode[15:0] == 16'hF072)		state[1] <= 1'b0;
		if(keycode[15:0] == 16'hF06B)		state[2] <= 1'b0;
		if(keycode[15:0] == 16'hF074)		state[3] <= 1'b0;
		// SHOOT
		if(keycode[7:0] == 8'h22)			state[4] <= 1'b1;
		if(keycode[15:0] == 16'hF022)		state[4] <= 1'b0;
	end


endmodule
