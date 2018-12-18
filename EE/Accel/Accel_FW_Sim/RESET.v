//-----------------------------------------------------------------------------
//Copyright(c) 2015, SVision Research Inc
//SVR Confidential Proprietary
//All rights reserved.
//-----------------------------------------------------------------------------
//
//IP LIB INDEX      :    
//IP Name           :                                                                                
//File Name         :                                                                                
//Module name       :  RESET                                                                              
//Full name         :  System Reset                                                                              
//                                                                                                   
//Author            :  HYan                                                                 
//Email             :                                                                                
//Data              :  2018.6.15                                                                             
//Version           :  V1.0                                                                              
//                                                                                                   
//Abstract          :                                                                                
//                                                                                                   
//Called  by        :
//
//Modification history
//------------------------------------------------------------------------------
//
//$Log$
//
//-----------------------------------------------------------------------------
//-----------------------------
//DEFINE MACRO
//-----------------------------

//synopsys translate_off
`timescale 1 ns / 100 ps
//synopsys translate_on

module RESET(
	input clk,                                    
	input sw_rst, 
	input pll_locked,  
	output reset_n,
	output reg local_rst, 
	output clr
); 
 
reg sw_rst_;

assign reset_n = sw_rst_ && local_rst;
assign clr = ~reset_n;

reg [7:0] i;
reg [7:0] j;
reg [1:0] sw_rst_reg; 
reg [1:0] state;

always@(posedge clk)
if(!pll_locked)
begin
	i <= 1'b0;
	local_rst <= 1'b0;
end
else
begin
	if(i >= 8'hF)
		local_rst <= 1'b1;
	else
	begin
		i <= i + 1'b1;
		local_rst <= 1'b0;
	end
end

always@(posedge clk)
if(!pll_locked)
begin
	j <= 1'b0;
	sw_rst_ <= 1'b1;
	state <= 2'd0;
end
else
begin
	sw_rst_reg[1:0] <= {sw_rst_reg[0],sw_rst};
	case(state)
	2'd0:
	begin
		if((sw_rst_reg[0] == 1'b0) && (sw_rst_reg[1] == 1'b1))
			state <= 2'd1;
		else
			state <= 2'd0;
	end
	2'd1:
	begin
		if(j >= 8'hF)
		begin
			j <= 8'h0;
			sw_rst_ <= 1'b1;
			state <= 2'd0;
		end
		else
		begin
			j <= j + 1'b1;
			sw_rst_ <= 1'b0;
			state <= 2'd1;
		end
	end
	endcase
end 


endmodule