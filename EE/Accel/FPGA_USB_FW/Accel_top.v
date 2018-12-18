//-----------------------------------------------------------------------------
//Copyright(c) 2015, SVision Research Inc
//SVR Confidential Proprietary
//All rights reserved.
//-----------------------------------------------------------------------------
//
//IP LIB INDEX      :    
//IP Name           :                                                                                
//File Name         :                                                                                
//Module name       :  Temp_top                                                                              
//Full name         :  Temperature top                                                                              
//                                                                                                   
//Author            :  Honglei.Yan                                                                  
//Email             :                                                                                
//Data              :  2018.03.06                                                                              
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

module Accel_top(
	input clk_pad,			//25MHz
//	input clk_I2C,			//400KHz
//	input reset_n,
	output wire Accel_scl,	
	inout Accel_sda,
	output reg [2:0] AccelState
);

//////clock//////////
wire clk_40M;
wire clk_25M;		//25MHz
wire clk_10M;		//10MHz
wire clk_400K;
wire pll_locked;		//PLL locked
//////Reset wire list/////////
wire reset_n;						//reset; active low
wire local_rst;						//local reset after power on
wire aclr;							//aclr; active high
wire sw_rst;

wire Accel_sda_in;
wire Accel_sda_out;

wire I2CIOStatus;
wire Accel_ACKflg;
wire I2C_reconfig;
wire AccelDataOk;

wire feedback_en;
reg configure_en;


//reg [2:0]AccelState;
parameter Init = 3'd0;
parameter ReadAccelPre = 3'd1;
parameter ReadAccelRead = 3'd2;
parameter ReadAccelDone = 3'd3;
/* parameter ReadTemp1Pre = 3'd4;
parameter ReadTemp1Read = 3'd5;
parameter ReadTemp1Done = 3'd6; */

parameter AccelI2C_error_NM = 8'h32;
reg [7:0] cnt;

assign Accel_sda = I2CIOStatus ? 1'bz : Accel_sda_out;

assign Accel_sda_in = I2CIOStatus ? Accel_sda : 1'b0; 

always @(negedge reset_n or posedge clk_25M)
if(!reset_n)
begin
	cnt <= 0;
	configure_en <= 0;
	AccelState <= Init;
end
else
begin
	case(AccelState)
	Init:		//0
	begin
		cnt <= 0;
		configure_en <= 0;
		AccelState <= ReadAccelPre;
	end
	
	ReadAccelPre:		//1
	begin
		configure_en <= 0;
		if(cnt>250)
		begin
			AccelState <= ReadAccelRead;
			cnt <= 0;
		end
		else
		begin
			AccelState <= ReadAccelPre;	
			cnt <= cnt+1'b1;
		end		
	end
	
	ReadAccelRead:		//2
	begin
		configure_en <= 1;
		if(AccelDataOk)
			AccelState <= ReadAccelDone;	
		else
			AccelState <= ReadAccelRead;			
	end
	
	ReadAccelDone:			//3
	begin
		cnt <= 0;
		configure_en <= 0;
		AccelState <= ReadAccelPre;			
	end
	
	default:
	begin
		AccelState <= Init;	
	end
	endcase
end

I2C_main I2C_main(
	.reset_n(reset_n),
	.clk_in(clk_25M),
	.DelayClk(clk_400K),
	.clk_I2C(clk_400K),
	.Accel_scl(Accel_scl),
	.Accel_sda_out(Accel_sda_out),
	.Accel_sda_in(Accel_sda_in),
	.Accel_ACKflg(Accel_ACKflg),
	.AccelI2C_error_NM(AccelI2C_error_NM),
	.configure_en(configure_en),
	.feedback_en(feedback_en),
	.I2C_reconfig(I2C_reconfig),
	.AccelDataOk(AccelDataOk),
	.I2CIOStatus(I2CIOStatus)
);

//Reset
RESET U_RESET(
	.clk(clk_25M),
	.sw_rst(sw_rst),
	.pll_locked(pll_locked),
	.reset_n(reset_n),
	.local_rst(local_rst),
	.clr(aclr) 
);

//PLL
MCB_PLL U_MCB_PLL(
	.inclk0(clk_pad),
	.c0(clk_25M),
	.c1(clk_40M),
	.c2(clk_10M),
	.c3(clk_400K),
	.locked(pll_locked)
);




endmodule




