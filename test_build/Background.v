`timescale 1ns / 1ps
/***************************************************************************
* 
* Filename:	top.v
* Version:	1.0
*
* Notes: 	Background module. Controls what appears in background during 
*				gameplay. In this instance, it will be stars.
*
***************************************************************************/
module Background(hc, vc, BG_draw);
	input [9:0] hc, vc;
	
	output reg BG_draw;
	
	parameter MAX_X = 640;
	parameter MAX_Y = 480;
	
	wire stars;
	
	assign stars = (vc==2  && hc==2 )   | (vc==10  && hc==480) | (vc==50  && hc==220) |
						(vc==75 && hc==55)   | (vc==80  && hc==600) | (vc==100 && hc==150) |
						(vc==200 && hc==250) | (vc==260 && hc==300) | (vc==300 && hc==620) |
						(vc==400 && hc==340) | (vc==440 && hc==20);
	
	always@(*) begin
		if(stars) begin
			BG_draw = 1'b1;
		end
		else begin
			BG_draw = 1'b0;
		end
	end

endmodule
