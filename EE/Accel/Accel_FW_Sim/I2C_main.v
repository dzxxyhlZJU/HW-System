
`timescale 1ps/1ps 
module I2C_main(
	input reset_n,
	input clk_in,
	input DelayClk,					//400KHz
	input clk_I2C,
	output Accel_scl,
	output Accel_sda_out,
	input Accel_sda_in,
	output Accel_ACKflg,
	input [7:0] AccelI2C_error_NM,
	input configure_en,
	output reg feedback_en,
	output reg I2C_reconfig,
	output reg AccelDataOk,
	output I2CIOStatus,
	output reg [5:0] current_state,
	output reg [5:0] next_state
);

/////////////I2C BUS///////////////
reg I2C_en;
reg I2C_wr;
reg [31:0] I2C_wdata;
reg [4:0] I2C_NM;
reg [31:0] I2C_rdata;
wire I2C_done;
parameter I2C_error_trig = 0;
wire I2C_error;
wire [7:0] I2C_error_time;
wire [23:0] ReadData;
//////////////I2C BUS///////////////
/////Device address set AD0 to GND////
parameter AccelAddrW = 8'hD0;		//AD0=0;
parameter AccelAddrR = 8'hD1;		//AD1=1;

//////////////Accel Addr//////////////
parameter RstValue = 8'h40;
parameter SignalRstValue = 8'h07;
parameter ConfigValue = 8'h01;
parameter SmprtDivValue = 8'h00;
parameter GyroConfigValue = 8'h00;
parameter AccelConfigValue = 8'h00;
parameter IntEnableValue = 8'h01;

//////////////Accel Addr//////////////
parameter RstAddr = 8'd107;			//
parameter SignalRstAddr = 8'd104;	//
parameter IDAddr = 8'd117;			//	
parameter ConfigAddr = 8'd26;		//	
parameter SmprtDivAddr = 8'd25;		//	
parameter GyroConfigAddr = 8'd27;	//	
parameter AccelConfigAddr = 8'd28;	//	
parameter IntEnableAddr = 8'd56;	//	
parameter RStartAddr = 8'd59;		//	
parameter RSum = 8'd13;				//	

//////////////Data Num///////////////
parameter RstNum = 4'h3;
parameter SignalRstNum = 4'h3;
parameter IDCMDNum = 8'd2;
parameter IDReadNum = 8'd2;

parameter PROMCMDNum = 4'h2;
parameter PROMReadNum = 4'h3;
parameter ResultCMDNum = 4'h2;
parameter ResultReadNum = 4'h4;
parameter PROMNum = 4'h9;


//////////////state/////////////////
//reg [5:0] current_state = 0;
//reg [5:0] next_state = 0;
parameter AccelInit = 6'd0;  	
parameter AccelRst = 6'd1;
parameter Delay1_100ms = 6'd2;
parameter SignalRst = 6'd3;	
parameter Delay2_100ms = 6'd4;
parameter CheckIDStep1 = 6'd5;		
parameter CheckIDStep2 = 6'd6;			
/* parameter SmprtDiv = 6'd7;	
parameter GyroConfig = 6'd8;
parameter AccelConfig = 6'd9;
parameter IntEnable = 6'd10;
parameter StartReadData = 6'd11;
parameter ReadDataDone = 6'd12; */
parameter AccelDone = 6'd13;
parameter AccelI2C_error = 6'd14;

//////////////Data Reg/////////////////
//catch configure_en posedge////
reg [1:0] configure_en_cnt;
reg configure_en_temp;
reg [7:0] cnt_r;


///////////////////Delay count/////////////////
reg DelayEnable;
reg [15:0] DelayTime;
wire DelayDone;

//////////////////Accel reg//////////////// 

always @(negedge reset_n or posedge clk_in)
begin
	if(!reset_n)
		configure_en_temp <= 0;
	else if(configure_en_cnt==2'b01)
		configure_en_temp <= 1;
//	else if(next_state==ReadADCResultStep2 || next_state==AccelI2C_error) ////modify
	else if( next_state==AccelI2C_error) ////modify
		configure_en_temp <= 0;
	else
		configure_en_temp <= configure_en_temp;
end

always@(posedge clk_I2C or negedge reset_n)
begin
	if(!reset_n)
		configure_en_cnt <= 0;
	else
		configure_en_cnt <= {configure_en_cnt[0], configure_en};
end

always @(posedge clk_I2C or negedge reset_n)
if(!reset_n)
	current_state <= AccelInit;
else
	current_state <= next_state;

//always @(current_state or configure_en_temp or DelayDone or I2C_done or I2C_error_time or cnt_r)
always @(*)
begin	
	next_state = current_state;
	case(current_state)	
	AccelInit:						//0
	begin
		next_state = AccelRst;
	end
	
	AccelRst:					//1
	begin
		if(I2C_done)
			next_state = Delay1_100ms;			//Delay3ms
		else
			next_state = AccelRst;

		if(I2C_error_time>AccelI2C_error_NM)
			next_state = AccelI2C_error;
	end
	
	Delay1_100ms:				//2
	begin
		if(DelayDone)
			next_state = SignalRst;
		else 
			next_state = Delay1_100ms;
	end
	
	SignalRst:					//1
	begin
		if(I2C_done)
			next_state = Delay2_100ms;			//Delay3ms
		else
			next_state = SignalRst;

		if(I2C_error_time>AccelI2C_error_NM)
			next_state = AccelI2C_error;
	end
	
	Delay2_100ms:				//2
	begin
		if(DelayDone)
			next_state = CheckIDStep1;
		else 
			next_state = Delay2_100ms;
	end
	
	CheckIDStep1:					//1
	begin
		if(I2C_done)
			next_state = CheckIDStep2;
		else 
			next_state = CheckIDStep1;

		if(I2C_error_time>AccelI2C_error_NM)
			next_state = AccelI2C_error;

	end
	
	CheckIDStep2:
	begin
		if(I2C_done)
			next_state = AccelDone;
		else 
			next_state = CheckIDStep2;

		if(I2C_error_time>AccelI2C_error_NM)
			next_state = AccelI2C_error;
	end	
	
	AccelDone:
	begin
		if(configure_en_temp)
			next_state = AccelInit;
		else
			next_state = AccelDone;
	end	
	
	AccelI2C_error:
	begin
		if(configure_en_temp)
			next_state = AccelInit;
		else
			next_state = AccelI2C_error;
	end
			
	default:  next_state = AccelInit;	
	endcase
end


always @(posedge clk_I2C or negedge reset_n )//or posedge finish_wr_status
if(!reset_n)   
begin
	feedback_en <= 0;
	cnt_r <= 0;
	I2C_en <= 0;
	I2C_wr <= 0;
	I2C_wdata <= 0;
	I2C_rdata <= 0;
	I2C_reconfig <= 0;
	DelayTime <= 0;
	DelayEnable <= 0;
	AccelDataOk <= 0;	
end 
else
begin	
	case(next_state)
	
	AccelInit:						//0
	begin
		I2C_wdata <= 0;
		feedback_en <= 0;
		I2C_reconfig <= 0;
		DelayTime <= 0;
		DelayEnable <= 0;
		AccelDataOk <= 0;
	end
	
	AccelRst:						//1			
	begin
		I2C_wdata <= {AccelAddrW,RstAddr,RstValue};		//16'EC1E 
		I2C_wr <= 0;
		I2C_NM <= RstNum;
		I2C_en <= 1;
		feedback_en <= 0;
		I2C_reconfig <= 0;
		DelayTime <= 0;
		DelayEnable <= 0;
		AccelDataOk <= 0;		
		if(I2C_done)
			I2C_en <= 0;
			
		if(I2C_error_trig)
			I2C_en <= 0;
		if(I2C_error_time>AccelI2C_error_NM)
			I2C_en <= 0;
	end
	
	Delay1_100ms:				//2
	begin
		I2C_en <= 0;
//		DelayTime <= 16'd4000;			//100ms
		DelayTime <= 16'd10;			//test
		DelayEnable <= 1;
	end
	
	SignalRst:					//3		
	begin
		I2C_wdata <= {AccelAddrW,SignalRstAddr,SignalRstValue};		//16'EC1E 
		I2C_wr <= 0;
		I2C_NM <= SignalRstNum;
		I2C_en <= 1;
		feedback_en <= 0;
		I2C_reconfig <= 0;
		DelayTime <= 0;
		DelayEnable <= 0;
		AccelDataOk <= 0;		
		if(I2C_done)
			I2C_en <= 0;
			
		if(I2C_error_trig)
			I2C_en <= 0;
		if(I2C_error_time>AccelI2C_error_NM)
			I2C_en <= 0;
	end
	
	Delay2_100ms:				//4
	begin
		I2C_en <= 0;
//		DelayTime <= 16'd4000;			//100ms
		DelayTime <= 16'd10;			//test
		DelayEnable <= 1;
	end	
	
	CheckIDStep1:				//5
	begin	
		DelayTime <= 0;
		DelayEnable <= 0;
		I2C_wdata <= {AccelAddrW,IDAddr};		//32'h0000EC00  
		I2C_NM <= IDCMDNum;
		I2C_en <= 1;
		feedback_en <= 0;
		I2C_reconfig <= 0;
		if(I2C_done)
			I2C_en <= 0;
			
		if(I2C_error_trig)
			I2C_en <= 0;
		if(I2C_error_time>AccelI2C_error_NM)
			I2C_en <= 0;
	end
	
	CheckIDStep2:				//6
	begin	
		I2C_rdata <= {AccelAddrR,24'h0};		//32'hED000000  
		I2C_wr <= 1;
		I2C_NM <= IDReadNum;
		I2C_en <= 1;
		feedback_en <= 0;
		I2C_reconfig <= 0;
		if(I2C_done)
			I2C_en <= 0;
			
		if(I2C_error_trig)
			I2C_en <= 0;
		if(I2C_error_time>AccelI2C_error_NM)
			I2C_en <= 0;
	end
	
	AccelDone:
	begin
		feedback_en <= 0;
		cnt_r <= 0;
		I2C_en <= 0;
		I2C_wr <= 0;
		I2C_wdata <= 0;
		I2C_rdata <= 0;
		I2C_reconfig <= 0;
		DelayTime <= 0;
		DelayEnable <= 0;
		AccelDataOk <= 1;	
	end
	
	AccelI2C_error:				//10
	begin
		I2C_en <= 0;
		feedback_en <= 1;
		I2C_reconfig <= 1;
	end

	default:  ;
	endcase
end

I2C_Bus I2C_Bus(
	.reset_n(reset_n),
	.clk_in(clk_I2C),		//I2C clk need to change 
	.I2C_scl(Accel_scl),
	.I2C_sda_out(Accel_sda_out),
	.I2C_sda_in(Accel_sda_in),
	.I2C_wr(I2C_wr),
	.I2C_wdata(I2C_wdata),
	.I2C_rdata(I2C_rdata),
	.I2C_en(I2C_en),
	.I2C_NM(I2C_NM),
	.I2C_done(I2C_done),
	.I2C_error(I2C_error),
	.I2C_error_time(I2C_error_time),
	.I2C_ACKflg(Accel_ACKflg),
	.ReadData(ReadData),
	.I2CIOStatus(I2CIOStatus)
);

DelayCount DelayCount(
	.reset_n(reset_n),
	.DelayClk(DelayClk),				//input clock 1MHz
	.DelayEnable(DelayEnable),
	.DelayTime(DelayTime),
	.DelayDone(DelayDone)
);



endmodule



