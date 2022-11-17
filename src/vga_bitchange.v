`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:15:38 12/14/2017 
// Design Name: 
// Module Name:    vgaBitChange 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
// Date: 04/04/2020
// Author: Yue (Julien) Niu
// Description: Port from NEXYS3 to NEXYS4
//////////////////////////////////////////////////////////////////////////////////
module vga_bitchange(
	input clk,
	input bright,
	input button,
	input [9:0] hCount, vCount,
	output reg [11:0] rgb,
	output reg [15:0] score
   );
	
	parameter BLACK  = 12'b0000_0000_0000;
	parameter RED    = 12'b1111_0000_0000;
	parameter PINK   = 12'b1111_0010_1000;
	parameter PURPLE = 12'b0111_0000_1011;
	parameter BLUE   = 12'b0011_0000_1010;
	parameter TEAL   = 12'b0100_1100_1111;
	
	wire bottomLineZone;
	wire pinkBlock, purpleBlock, blueBlock, tealBlock;
	reg reset;
	reg[9:0] pinkBlockY, purpleBlockY, blueBlockY, tealBlockY;
	reg[49:0] pinkBlockSpeed, purpleBlockSpeed, blueBlockSpeed, tealBlockSpeed;

	initial begin
		blueBlockY = 10'd320;
		score = 15'd0;
		reset = 1'b0;
	end
	
	
    always@ (*)
    if (~bright)
        rgb = BLACK;
    else if (pinkBlock)
        rgb = PINK;
    else if (purpleBlock)
        rgb = PURPLE;
    else if (blueBlock == 1)
        rgb = BLUE;
    else if (tealBlock)
        rgb = TEAL;
	else if (bottomLineZone == 1)
		rgb = RED;
	else
		rgb = BLACK;

	
	always@ (posedge clk)
		begin
	pinkBlockSpeed = pinkBlockSpeed + 1'b1;
		if (blueBlockSpeed >= 50'd500000) //500 thousand
			begin
			pinkBlockY = pinkBlockY + 10'd1;
			pinkBlockSpeed = 50'd0;
			if (pinkBlockY == 10'd999)
				begin
				pinkBlockY = 10'd0;
				end
			end
		end
		
	always@ (posedge clk)
		begin
		purpleBlockSpeed = purpleBlockSpeed + 1'b1;
		if (purpleBlockSpeed >= 50'd500000) //500 thousand
			begin
			purpleBlockY = purpleBlockY + 10'd1;
			purpleBlockSpeed = 50'd0;
			if (purpleBlockY == 10'd1579)
				begin
				purpleBlockY = 10'd0;
				end
			end
		end
		
	always@ (posedge clk)
		begin
		blueBlockSpeed = blueBlockSpeed + 1'b1;
		if (blueBlockSpeed >= 50'd500000) //500 thousand
			begin
			blueBlockY = blueBlockY + 10'd1;
			blueBlockSpeed = 50'd0;
			if (blueBlockY == 10'd1279)
				begin
				blueBlockY = 10'd0;
				end
			end
		end
		
	always@ (posedge clk)
		begin
		tealBlockSpeed = tealBlockSpeed + 1'b1;
		if (tealBlockSpeed >= 50'd500000) //500 thousand
			begin
			tealBlockY = tealBlockY + 10'd1;
			tealBlockSpeed = 50'd0;
			if (tealBlockY == 10'd859)
				begin
				tealBlockY = 10'd0;
				end
			end
		end
	   

	always@ (posedge clk)
		if ((reset == 1'b0) && (button == 1'b1) && (hCount >= 10'd144) && (hCount <= 10'd784) && (blueBlockY >= 10'd400) && (blueBlockY <= 10'd475))
			begin
			score = score + 16'd1;
			reset = 1'b1;
			end
		else if (blueBlockY <= 10'd20)
			begin
			reset = 1'b0;
			end
	
	assign pinkBlock = ((10'd220 <= hCount) && (hCount <= 10'd280)) && ((blueBlockY <= vCount) && (vCount <= blueBlockY + 10'd60)) ? 1 : 0;
	assign purpleBlock = ((10'd320 <= hCount) && (hCount <= 10'd380)) && ((blueBlockY <= vCount) && (vCount <= blueBlockY + 10'd90)) ? 1 : 0;
	assign blueBlock = ((10'd420 <= hCount) && (hCount <= 10'd480)) && ((blueBlockY <= vCount) && (vCount <= blueBlockY + 10'd70)) ? 1 : 0;
	assign tealBlock = ((10'd520 <= hCount) && (hCount <= 10'd580)) && ((blueBlockY <= vCount) && (vCount <= blueBlockY + 10'd100)) ? 1 : 0;
	assign bottomLineZone = ((10'd144 <= hCount) && (hCount <= 10'd784)) && ((10'd500 <= vCount) && (vCount <= 10'd516)) ? 1 : 0;
	
endmodule
