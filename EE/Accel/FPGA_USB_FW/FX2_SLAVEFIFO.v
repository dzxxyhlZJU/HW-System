//-----------------------------------------------------------------------------
//Copyright(c) 2015, SVision Research Inc
//SVR Confidential Proprietary
//All rights reserved.
//-----------------------------------------------------------------------------
//
//IP LIB INDEX      :    
//IP Name           :                                                                                
//File Name         :                                                                                
//Module name       :  FX2_SLAVEFIFO                                                                              
//Full name         :  FX2_SLAVEFIFO                                                                              
//                                                                                                   
//Author            :  HYan                                                                 
//Email             :                                                                                
//Data              :  2018.06.15                                                                              
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

//-----------------------------
//DEFINE MODULE PORT
//-----------------------------
module FX2_SLAVEFIFO(
	input clk,					//clock input
	input reset_n,				//reset, active low
	inout [15:0] fdata,			//data bus between FPGA and 68013
	output [1:0] faddr,			//usb endpoint address
	output slrd,				//usb read, active low
	output slwr,				//usb write enable, active low
	output sloe,				//usb read enable, active low
	output pktend,				//usb pktend
	input flaga,				//cmd_ep_empty, not empty: high, empty: low
	input flagd,				//data_ep_full; not full: high, full: low
	input [15:0] data_in,		//data input
	output reg [15:0] cmd_out,	//command output
	output cmd_wen,				//command write enable, active high
	output data_ren,			//data read enable, active high
	input cmd_fifo_full,		//CMDFIFO full flag, active high
	input data_fifo_empty,		//DATAFIFO empty flag, active high
	input ROMRDoneF,
	input SendCMDDoneFlag,
	output reg [2:0] current_state//for debug
); 

reg slrd_n;
reg slwr_n;
reg sloe_n;
reg pktend_n;
reg [15:0] data_out;
reg [1:0] faddr_n;
//reg [2:0] current_state;
reg [2:0] next_state;
reg slwr_d1_;
reg flaga_d;
reg flagd_d;

parameter [2:0] idle       = 3'd0;
parameter [2:0] read       = 3'd1;
parameter [2:0] write      = 3'd2;
parameter [2:0] write_end  = 3'd3;

assign slwr = slwr_d1_;
assign slrd = slrd_n;
assign sloe = sloe_n;
assign faddr = faddr_n;
assign pktend = pktend_n;
assign fdata = data_out;
assign cmd_wen = ((slrd_n == 1'b0) & (cmd_fifo_full == 1'b0));
assign data_ren = ((slwr_n == 1'b0) & (data_fifo_empty == 1'b0));

always@(posedge clk)
if(!reset_n)
begin
	slwr_d1_ <= 1'b1;
	flaga_d <= 1'b0;
	flagd_d <= 1'b0;
end
else
begin
	slwr_d1_ <= slwr_n;
	flaga_d <= flaga;
	flagd_d <= flagd;
end

always@(*)
if((current_state == idle) | (current_state == read))
	faddr_n = 2'b00;
else 
	faddr_n = 2'b10;

always@(*)
if((current_state == write_end) && (ROMRDoneF||SendCMDDoneFlag))
	pktend_n = 1'b0;
else
	pktend_n = 1'b1;

//read control signal generation
always@(*)
if((current_state == read) & (flaga_d == 1'b1))
begin
	slrd_n = 1'b0;
	sloe_n = 1'b0;
end 
else 
begin
	slrd_n = 1'b1;
	sloe_n = 1'b1;
end

always@(*)
if(slrd_n == 1'b0)
	cmd_out = fdata;
else
	cmd_out = 16'h0;

//write control signal generation
always@(*)
if((current_state == write) & (flagd_d == 1'b1))
	slwr_n <= 1'b0;
else
	slwr_n <= 1'b1;

//state machine 
always@(posedge clk, negedge reset_n) 
if(reset_n == 1'b0)
	current_state <= idle;
else
	current_state <= next_state;

//state machine combo
always@(*) 
begin
	next_state = current_state;
	case(current_state)
	idle:				//0
	begin
		if(flaga_d == 1'b1)
			next_state = read;
		else if((flagd_d == 1'b1) & (data_fifo_empty == 1'b0))
			next_state = write;
		else
			next_state = idle;
	end
	
	read:				//1
	begin
		if(flaga_d == 1'b0)
			next_state = idle;
		else
			next_state = read;
	end
	
	write:				//2
	begin
		if((flagd_d == 1'b0) | (data_fifo_empty == 1'b1))
			next_state = write_end;
		else 
			next_state = write;
	end
	
	write_end:			//3
	begin
		next_state = idle;
	end

	default: 
		next_state = idle;
	endcase		
end

always@(*)
if(slwr_n == 1'b1)
	data_out = 16'dz;
else
	data_out = data_in;

endmodule
