`timescale 1ns / 1ps
/***************************************************************************
* 
* Filename:	clk_div.v
* Version:	1.0
*
* Notes: 	Receives data bits from keyboard. Reads in scan codes and saves 
*				them for later use. 
*
***************************************************************************/
module Keyboard(clk, ps2_clk, ps2_data, keycodeout);
	input clk;						// 25 Mhz clock 
	input ps2_clk, ps2_data;	// Clock and Data from Keyboard
	
	output [31:0] keycodeout;	// Scan codes from Keyboard
	
	// Additional Registers
	reg		  flag;				// Checks when parity bit is read
	reg [7:0]  data_cur;			// Current Data
	reg [7:0]  data_prev;		// Previous Data
	reg [3:0]  count;				// Count for receiving PS/2 data
	reg [31:0] keycode;			// Holds scan codes from Keyboard

	// Additional Wire
	wire debounced_clk, debounced_data;

	initial begin
		keycode <= 32'h0;
		count   <= 4'b0000;
		flag    <= 1'b0;
	end
	
	debouncer debounce(
		.clk(clk),
		.I0(ps2_clk),
		.I1(ps2_data),
		.O0(debounced_clk),
		.O1(debounced_data)
	);

	
	// Saves 8-bit scan code from keyboard
	always@(negedge(debounced_clk)) begin
		case(count)
			0:                         		;	  // Start Bit
			1:  data_cur[0] <= debounced_data;
			2:  data_cur[1] <= debounced_data;
			3:  data_cur[2] <= debounced_data;
			4:  data_cur[3] <= debounced_data;
			5:  data_cur[4] <= debounced_data;
			6:  data_cur[5] <= debounced_data;
			7:  data_cur[6] <= debounced_data;
			8:  data_cur[7] <= debounced_data;
			9:  flag <= 1'b1;							 // Parity Bit
			10: flag <= 1'b0; 						 // Stop Bit
		endcase
		
		if(count <= 9)       count <= count + 1'b1;
		else if(count == 10) count <= 0;
	end
	
	always@(posedge flag) begin
		keycode[31:24] <= keycode[23:16];
		keycode[23:16] <= keycode[15:8];
		keycode[15:8]  <= data_prev;
		keycode[7:0]   <= data_cur;
		data_prev      <= data_cur;
	end
	
	assign keycodeout = keycode;

endmodule
