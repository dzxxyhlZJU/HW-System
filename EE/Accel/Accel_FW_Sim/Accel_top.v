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
	input clk_in,			//25MHz
	input clk_I2C,			//400KHz
//	input DelayClk,			//1MHz
	input reset_n,
	output wire Accel_scl,	
	inout Accel_sda,
	output reg [15:0] PROM0Data0,
	output reg [15:0] PROM0Data1,
	output reg [15:0] PROM0Data2,
	output reg [15:0] PROM0Data3,
	output reg [15:0] PROM0Data4,
	output reg [23:0] ADCResultData0,
	output reg [2:0] AccelState
);

wire Accel_sda_in;
wire Accel_sda_out;

wire I2CIOStatus;
wire Accel_ACKflg;
wire I2C_reconfig;

reg CSB0;
reg CSB1;

wire feedback_en;

wire AccelDataOk;
wire TempDataOk1;

reg configure_en;
reg configure_en1;

wire [15:0] PROMData00;
wire [15:0] PROMData01;
wire [15:0] PROMData02;
wire [15:0] PROMData03;
wire [15:0] PROMData04;
wire [23:0] ADC0ResultData;
wire [15:0] PROMData10;
wire [15:0] PROMData11;
wire [15:0] PROMData12;
wire [15:0] PROMData13;
wire [15:0] PROMData14;
wire [23:0] ADC1ResultData;

//reg [2:0]AccelState;
parameter Init = 3'd0;
parameter ReadTemp0Pre = 3'd1;
parameter ReadTemp0Read = 3'd2;
parameter ReadTemp0Done = 3'd3;
parameter ReadTemp1Pre = 3'd4;
parameter ReadTemp1Read = 3'd5;
parameter ReadTemp1Done = 3'd6;

parameter AccelI2C_error_NM = 8'h32;
reg [7:0] cnt;

assign Accel_sda = I2CIOStatus ? 1'bz : Accel_sda_out;

assign Accel_sda_in = I2CIOStatus ? Accel_sda : 1'b0; 

always @(negedge reset_n or posedge clk_in)
if(!reset_n)
begin
	cnt <= 0;
	CSB0 <= 0;	
	CSB1 <= 0;
	configure_en <= 0;
	configure_en1 <= 0;
	PROM0Data0 <= 0;
	PROM0Data1 <= 0;
	PROM0Data2 <= 0;
	PROM0Data3 <= 0;
	PROM0Data4 <= 0;
	ADCResultData0 <= 0;
	AccelState <= 0;
end
else
begin
	case(AccelState)
	Init:		//0
	begin
		cnt <= 0;
		CSB0 <= 0;		
		CSB1 <= 0;
		configure_en <= 0;
		configure_en1 <= 0;
		AccelState <= ReadTemp0Pre;
	end
	ReadTemp0Pre:		//1
	begin
		CSB0 <= 0;	
		CSB1 <= 0;
		configure_en <= 0;
		configure_en1 <= 0;
		if(cnt>250)
		begin
			AccelState <= ReadTemp0Read;
			cnt <= 0;
		end
		else
		begin
			AccelState <= ReadTemp0Pre;	
			cnt <= cnt+1'b1;
		end		
	end
	ReadTemp0Read:		//2
	begin
		CSB0 <= 0;	
		CSB1 <= 0;
		configure_en <= 1;
		configure_en1 <= 1;
		if(AccelDataOk & TempDataOk1)
			AccelState <= ReadTemp0Done;	
		else
			AccelState <= ReadTemp0Read;			
	end
	ReadTemp0Done:			//3
	begin
		CSB0 <= 0;	
		CSB1 <= 0;
		configure_en <= 0;
		configure_en1 <= 0;
		PROM0Data0 <= PROMData00;
		PROM0Data1 <= PROMData01;
		PROM0Data2 <= PROMData02;
		PROM0Data3 <= PROMData03;
		PROM0Data4 <= PROMData04;
		ADCResultData0 <= ADC0ResultData;
		AccelState <= ReadTemp1Pre;			
	end
	ReadTemp1Pre:			//4
	begin
		CSB0 <= 1;	
		CSB1 <= 1;
		configure_en <= 0;
		configure_en1 <= 0;
		if(cnt>250)
		begin
			AccelState <= ReadTemp1Read;
			cnt <= 0;
		end
		else
		begin
			AccelState <= ReadTemp1Pre;	
			cnt <= cnt+1'b1;
		end
	end
	ReadTemp1Read:				//5
	begin
		CSB0 <= 1;	
		CSB1 <= 1;
		configure_en <= 1;
		configure_en1 <= 1;
		if(AccelDataOk & TempDataOk1)
			AccelState <= ReadTemp1Done;	
		else
			AccelState <= ReadTemp1Read;			
	end
	ReadTemp1Done:				//6
	begin
		CSB0 <= 1;	
		CSB1 <= 1;
		configure_en <= 0;
		configure_en1 <= 0;
		PROM1Data0 <= PROMData00;
		PROM1Data1 <= PROMData01;
		PROM1Data2 <= PROMData02;
		PROM1Data3 <= PROMData03;
		PROM1Data4 <= PROMData04;
		ADCResultData1 <= ADC0ResultData;
		PROM3Data0 <= PROMData10;
		PROM3Data1 <= PROMData11;
		PROM3Data2 <= PROMData12;
		PROM3Data3 <= PROMData13;
		PROM3Data4 <= PROMData14;
		ADCResultData3 <= ADC1ResultData;
		AccelState <= ReadTemp0Pre;			
	end
	
	default:
	begin
		AccelState <= Init;	
	end
	endcase
end

I2C_main I2C_main(
	.reset_n(reset_n),
	.clk_in(clk_in),
	.DelayClk(clk_I2C),
	.clk_I2C(clk_I2C),
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

endmodule




