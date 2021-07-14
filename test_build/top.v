`timescale 1ns / 1ps
/***************************************************************************
* 
* Filename:	top.v
* Version:	1.0
*
* Notes: 	Top Level Module
*
***************************************************************************/
module top(clk, rst, ps2_clk, ps2_data, hsync, vsync, state, red, green, blue);
	
	input clk, rst;
	input ps2_clk, ps2_data;
	
	output 		 hsync, vsync;				// Horizontal and Vertical Sync
	output [4:0] state; 						// Command Signals 
	output [3:0] red, blue, green;		// 12-bit Color Out
	
	
	/////////////////////////////////////////////////////////////////////////////
	// CLOCK DIVIDER (Divides to 25 Mhz)													//
	/////////////////////////////////////////////////////////////////////////////
	
	wire 		  clk_25mhz; // 25Mhz Clock
	
	clk_div clk_div(.clk(clk), 
						 .rst(rst), 
						 .clk_25mhz(clk_25mhz));
	
	/////////////////////////////////////////////////////////////////////////////
	// CONTROLLER																					//
	/////////////////////////////////////////////////////////////////////////////
	
	wire [31:0] keycode; // Keyboard Scan Codes
	
	Keyboard Keyboard(.clk(clk_25mhz),
							.ps2_clk(ps2_clk),
							.ps2_data(ps2_data),
							.keycodeout(keycode));
							
	/////////////////////////////////////////////////////////////////////////////
	// CONTROL SCHEME																				//
	/////////////////////////////////////////////////////////////////////////////				
	
	Control_Scheme Control_Scheme(.clk(clk),
											.keycode(keycode),
											.state(state));
											
	/////////////////////////////////////////////////////////////////////////////
	// VGA CONTROLLER																			   //
	/////////////////////////////////////////////////////////////////////////////	
	
	wire [9:0] hc, vc;
	
	vga_sync vga_sync(.clk(clk_25mhz),
							.rst(rst),
							.hsync(hsync),
							.vsync(vsync),
							.hc(hc),
							.vc(vc));
											
	/////////////////////////////////////////////////////////////////////////////
	// CHARACTER DESIGN																			//
	/////////////////////////////////////////////////////////////////////////////		
	
	wire		  player_draw;		// Signal to draw Player
	wire		  player_color;   // Player Color Pallete
	wire [9:0] player_left;		// Player left border
	wire [9:0] player_right;	// Player right border
	wire [9:0] player_up;		// Player upper border
	wire [9:0] player_down;		// Player bottom border
	
	wire 		  pellet_draw;		// Signal to draw pellet
	
	Player Player(.clk(clk_25mhz),
					  .rst(rst),
					  .ref_tick(ref_tick),
					  .state(state),
					  .hc(hc),
					  .vc(vc),
					  .player_draw(player_draw),
					  .player_color(player_color));
					  
	/////////////////////////////////////////////////////////////////////////////
	// BACKGROUND DESIGN																			//
	/////////////////////////////////////////////////////////////////////////////	
	
	wire BG_draw;
	
	Background Background(.hc(hc),
								 .vc(vc),
								 .BG_draw(BG_draw));
							
	/////////////////////////////////////////////////////////////////////////////
	// GRAPHIC CONTROLLER																		//
	/////////////////////////////////////////////////////////////////////////////	

	
	Graphics Graphics(.clk(clk_25mhz),
							.rst(rst),
							.ref_tick(ref_tick),
							.hc(hc),
							.vc(vc),
							.player_draw(player_draw),
							.player_color(player_color),
							.BG_draw(BG_draw),
							.red(red),
							.green(green),
							.blue(blue));
	

endmodule
