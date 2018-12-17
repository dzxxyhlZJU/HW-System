//-----------------------------------------------------------------------------
//Copyright(c) 2015, SVision Research Inc
//SVR Confidential Proprietary
//All rights reserved.
//-----------------------------------------------------------------------------
//
//IP LIB INDEX      :    
//IP Name           :                                                                                
//File Name         :                                                                                
//Module name       :  Time delay                                                                              
//Full name         :  Only For Interface Test                                                                              
//                                                                                                   
//Author            :  Honglei.Yan                                                                  
//Email             :                                                                                
//Data              :  2017.10.08                                                                              
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

module DelayCount(
	input reset_n,
	input DelayClk,				//input clock 10KHz
	input DelayEnable,
	input [15:0] DelayTime,
	output reg DelayDone
);


reg [16:0] CountReg;

always @(negedge reset_n or posedge DelayClk or negedge DelayEnable)
begin
	if(!reset_n)
	begin
		CountReg <= 0;
		DelayDone <= 0;
	end
	else if(!DelayEnable)
	begin
		CountReg <= 0;
		DelayDone <= 0;
	end
	else 
	begin
		if(CountReg>DelayTime)
		begin
			CountReg <= 0;
			DelayDone <= 1;
		end
		else
		begin
			CountReg <= CountReg + 1'b1;
			DelayDone <= 0;
		end	
	end
end

endmodule



