
`timescale 1ps/1ps 
module I2C_main(
	input reset_n,
	input clk_in,
	input clk_I2C,
	output TempI2C_scl,
	output TempI2C_sda_out,
	input TempI2C_sda_in,
	output TempI2C_ACKflg,
	input [7:0] TempI2C_error_NM,
	input configure_en,
	output reg feedback_en,
	output reg I2C_reconfig,
	input DelayClk,				//1MHz
//	output reg [7:0] PROMData[15:0],
	output [23:0] ADCResultData,
	output reg [5:0] current_state,
	output reg [5:0] next_state,
	output reg PROMDataOk,
	output reg TempDataOk,
	output I2CIOStatus,
	input CSB,
	output [15:0] PROMData0,
	output [15:0] PROMData1,
	output [15:0] PROMData2,
	output [15:0] PROMData3,
	output [15:0] PROMData4
);

/////////////I2C BUS///////////////
reg I2C_en;
reg I2C_wr;
reg [31:0] I2C_wdata;
reg [4:0] I2C_NM;
reg [31:0] I2C_rdata;
wire I2C_done;
parameter I2C_error_trig=0;
wire I2C_error;
wire [7:0] I2C_error_time;
wire [23:0] ReadData;
//////////////I2C BUS///////////////
/////Device address///////////
wire [7:0] TempAddrW;
wire [7:0] TempAddrR;
parameter Temp0AddrW = 8'hEE;		//CSB=0;
parameter Temp0AddrR = 8'hEF;		//CSB=0;
parameter Temp1AddrW = 8'hEC;		//CSB=1;
parameter Temp1AddrR = 8'hED;		//CSB=1;
assign TempAddrW = CSB ? 8'hEC : 8'hEE;
assign TempAddrR = CSB ? 8'hED : 8'hEF;

//////////////Temp Addr///////////////
parameter RstAddr = 8'h1E;			//
parameter StartCvtAddr = 8'h48;		//
parameter ReadADCAddr = 8'h00;		//				
parameter PROM0Addr = 8'hA0;		//
parameter PROM1Addr = 8'hA2; 		//
parameter PROM2Addr = 8'hA4; 		//
parameter PROM3Addr = 8'hA6; 		//
parameter PROM4Addr = 8'hA8; 		//
parameter PROM5Addr = 8'hAA; 		//
parameter PROM6Addr = 8'hAC; 		//
parameter PROM7Addr = 8'hAE; 		//



//////////////Data Num///////////////
parameter RstNum = 4'h2;
parameter StartCvtNum = 4'h2;
parameter PROMCMDNum = 4'h2;
parameter PROMReadNum = 4'h3;
parameter ResultCMDNum = 4'h2;
parameter ResultReadNum = 4'h4;
parameter PROMNum = 4'h9;


//////////////state/////////////////
//reg [5:0] current_state = 0;
//reg [5:0] next_state = 0;
parameter Temp_init = 6'h0;  	
parameter Temp_rst = 6'h1;
parameter Delay3ms = 6'h11;
parameter PROMReadStep1 = 6'h2;	
parameter PROMReadStep2 = 6'h3;
parameter PROMReadDone = 6'h4;		
parameter StartCvt = 6'h5;			
parameter Delay10ms = 6'h12;	
parameter ReadADCResultStep1 = 6'h6;
parameter ReadADCResultStep2 = 6'h7;
parameter ReadADCResultDone = 6'h8;
parameter Temp_done = 6'h9;
parameter TempI2C_error = 6'hA;

//////////////Data Reg/////////////////
reg [15:0] PROMData[7:0];
reg [23:0] ADCResultDataTemp;
assign PROMData0 = I2C_error ? 16'h0 : PROMData[5];
assign PROMData1 = I2C_error ? 16'h0 : PROMData[4];
assign PROMData2 = I2C_error ? 16'h0 : PROMData[3];
assign PROMData3 = I2C_error ? 16'h0 : PROMData[2];
assign PROMData4 = I2C_error ? 16'h0 : PROMData[1];
assign ADCResultData = I2C_error ? 24'h0 : ADCResultDataTemp;
//catch configure_en posedge////
reg [1:0] configure_en_cnt;
reg configure_en_temp;
reg [7:0] cnt_r;
reg [7:0] PROMAddrTemp;


///////////////////Delay count/////////////////
reg DelayEnable;
reg [15:0] DelayTime;
wire DelayDone;


always @(negedge reset_n or posedge clk_in)
begin
	if(!reset_n)
		configure_en_temp <= 0;
	else if(configure_en_cnt==2'b01)
		configure_en_temp <= 1;
	else if(next_state==ReadADCResultStep2 || next_state==TempI2C_error)
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
	current_state <= Temp_init;
else
	current_state <= next_state;

//always @(current_state or configure_en_temp or DelayDone or I2C_done or I2C_error_time or cnt_r)
always @(*)
begin	
	next_state = current_state;
	case(current_state)	
	Temp_init:						//0
	begin
		next_state = Temp_rst;
	end
	
	Temp_rst:					//1
	begin
		if(I2C_done)
		begin
			next_state = Delay3ms;			//Delay3ms
		end
		else 
		begin
			next_state = Temp_rst;
		end

		if(I2C_error_time>TempI2C_error_NM)
		begin
			next_state = TempI2C_error;
		end	
	end
	
	Delay3ms:				//17
	begin
		if(DelayDone)
		begin
			next_state = PROMReadStep1;
		end
		else 
		begin
			next_state = Delay3ms;
		end
	end
	
	PROMReadStep1:				//2
	begin
		if(cnt_r < PROMNum)
		begin
			if(I2C_done)
			begin		
				next_state = PROMReadStep2;
			end
			else
			begin		
				next_state = PROMReadStep1;
			end
				
			if(I2C_error_time>TempI2C_error_NM)
			begin
				next_state = TempI2C_error;
			end		
		end
		if((cnt_r+1)==PROMNum)
		begin
			next_state = PROMReadDone;
		end
	end
	
	PROMReadStep2:
	begin
		if(cnt_r < PROMNum)
		begin
			if(I2C_done)
			begin		
				next_state = PROMReadStep1;				
			end
			else
			begin		
				next_state = PROMReadStep2;
			end

			if(I2C_error_time>TempI2C_error_NM)
			begin
				next_state = TempI2C_error;
			end			
		end
	end
	
	PROMReadDone:
	begin
		next_state = StartCvt;
	end
	
	StartCvt:
	begin
		if(I2C_done)
		begin
			next_state = Delay10ms;				//Delay10ms
		end	
		else 
		begin
			next_state = StartCvt;
		end

		if(I2C_error_time>TempI2C_error_NM)
		begin
			next_state = TempI2C_error;
		end	
	end	

	Delay10ms:
	begin
		if(DelayDone)
		begin
			next_state = ReadADCResultStep1;
		end	
		else 
		begin
			next_state = Delay10ms;
		end
	end
	
	ReadADCResultStep1:
	begin
		if(I2C_done)
		begin
			next_state = ReadADCResultStep2;
		end	
		else 
		begin
			next_state = ReadADCResultStep1;
		end

		if(I2C_error_time>TempI2C_error_NM)
		begin
			next_state = TempI2C_error;
		end	
	end	
	
	ReadADCResultStep2:
	begin
		if(I2C_done)
		begin
			next_state = ReadADCResultDone;
		end	
		else 
		begin
			next_state = ReadADCResultStep2;
		end

		if(I2C_error_time>TempI2C_error_NM)
		begin
			next_state = TempI2C_error;
		end	
	end		
	
	ReadADCResultDone:
	begin
		next_state = Temp_done;
	end
	
	Temp_done:
	begin
		if(configure_en_temp)
		begin
			next_state = Temp_init;
		end
		else
			next_state = Temp_done;
	end	
	
	TempI2C_error:
	begin
		if(configure_en_temp)
		begin
			next_state = Temp_init;
		end
		else
			next_state = TempI2C_error;
	end
			
	default:  next_state = Temp_init;	
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
	ADCResultDataTemp <= 0;
	PROMDataOk <= 0;
	TempDataOk <= 0;	
end 
else
begin	
	case(next_state)
	
	Temp_init:						//0
	begin
		I2C_wdata <= 0;
		feedback_en <= 0;
		I2C_reconfig <= 0;
		DelayTime <= 0;
		DelayEnable <= 0;
		ADCResultDataTemp <= 0;
		PROMDataOk <= 0;
		TempDataOk <= 0;
	end
	
	Temp_rst:						//1			
	begin
		I2C_wdata <= {TempAddrW,RstAddr};		//16'EC1E 
		I2C_wr <= 0;
		I2C_NM <= RstNum;
		I2C_en <= 1;
		feedback_en <= 0;
		I2C_reconfig <= 0;
		PROMAddrTemp = PROM0Addr;
		DelayTime <= 0;
		DelayEnable <= 0;
		ADCResultDataTemp <= 0;
		PROMDataOk <= 0;
		TempDataOk <= 0;		
		if(I2C_done)
		begin
			I2C_en <= 0;
		end
			
		if(I2C_error_trig)
		begin
			I2C_en <= 0;
		end	
		if(I2C_error_time>TempI2C_error_NM)
		begin
			I2C_en <= 0;
		end	
	end
	
	Delay3ms:
	begin
		I2C_en <= 0;
		DelayTime <= 3500;			//3.5ms
		DelayEnable <= 1;
		PROMAddrTemp <= PROM0Addr;
	end
	
	PROMReadStep1:								//2
	begin	
		DelayTime <= 0;
		DelayEnable <= 0;
		if(cnt_r < PROMNum)
		begin
			I2C_wdata <= {TempAddrW,PROMAddrTemp};	//16'hECA0
			I2C_wr <= 0;
			I2C_NM <= PROMCMDNum;
			I2C_en <= 1;
			if(I2C_done)
			begin
				I2C_en <= 0;
				PROMData[cnt_r-1'b1] <= ReadData[15:0];
			end
				
			if(I2C_error_trig)
			begin
				I2C_en <= 0;
			end	
			if(I2C_error_time>TempI2C_error_NM)
			begin
				I2C_en <= 0;
			end	
		end
		else
		begin
			cnt_r <= cnt_r;
			I2C_wr <= I2C_wr;
		end
	end
	
	PROMReadStep2:					//3
	begin
		if(cnt_r < PROMNum)
		begin
			I2C_rdata <= {TempAddrR,16'h0};		//32'h00ED0000
			I2C_wr <= 1;
			I2C_NM <= PROMReadNum;
			I2C_en <= 1;
			if(I2C_done)
			begin
				I2C_en <= 0;
				PROMAddrTemp <= PROMAddrTemp + 8'h2;
				cnt_r <= cnt_r+4'h1;				
			end
				
			if(I2C_error_trig)
			begin
				I2C_en <= 0;
			end	
			if(I2C_error_time>TempI2C_error_NM)
			begin
				I2C_en <= 0;
			end	
		end
		else
		begin
			cnt_r <= 0;
			I2C_wr <= I2C_wr;
		end
	end
	
	PROMReadDone:          //4
	begin
		cnt_r <= 0;
		I2C_en <= 0;
		I2C_wdata <= 0;
		I2C_rdata <= 0;
		I2C_wr <= 0;
		feedback_en <= 0;
		I2C_reconfig <= 0;
		PROMDataOk <= 1;
		TempDataOk <= 0;		
	end
	
	StartCvt:						//5			
	begin
		I2C_wdata <= {TempAddrW,StartCvtAddr};		//  32'h0000EC48
		I2C_NM <= StartCvtNum;
		I2C_en <= 1;
		feedback_en <= 0;
		I2C_reconfig <= 0;
		if(I2C_done)
		begin
			I2C_en <= 0;
			PROMDataOk <= 1;
			TempDataOk <= 0;
		end
			
		if(I2C_error_trig)
		begin
			I2C_en <= 0;
		end	
		if(I2C_error_time>TempI2C_error_NM)
		begin
			I2C_en <= 0;
		end	
	end		
	
	Delay10ms:          //13
	begin
		I2C_en <= 0;
		DelayTime <= 10000;
		DelayEnable <= 1;
		PROMAddrTemp <= PROM0Addr;
	end	
	
	ReadADCResultStep1:				//6  
	begin
		DelayTime <= 0;
		DelayEnable <= 0;
		I2C_wdata <= {TempAddrW,ReadADCAddr};		//32'h0000EC00  
		I2C_NM <= ResultCMDNum;
		I2C_en <= 1;
		feedback_en <= 0;
		I2C_reconfig <= 0;
		if(I2C_done)
		begin
			I2C_en <= 0;
		end
			
		if(I2C_error_trig)
		begin
			I2C_en <= 0;
		end	
		if(I2C_error_time>TempI2C_error_NM)
		begin
			I2C_en <= 0;
		end	
	end	
	
	ReadADCResultStep2:				//7  
	begin
		I2C_rdata <= {TempAddrR,24'h0};		//32'hED000000  
		I2C_wr <= 1;
		I2C_NM <= ResultReadNum;
		I2C_en <= 1;
		feedback_en <= 0;
		I2C_reconfig <= 0;
		if(I2C_done)
		begin
			I2C_en <= 0;
		end
			
		if(I2C_error_trig)
		begin
			I2C_en <= 0;
		end	
		if(I2C_error_time>TempI2C_error_NM)
		begin
			I2C_en <= 0;
		end	
	end	
	
	ReadADCResultDone:				//8  
	begin
		ADCResultDataTemp <= ReadData;	
		cnt_r <= 0;
		I2C_en <= 0;
		I2C_wdata <= 0;
		I2C_rdata <= 0;
		I2C_wr <= 0;
		feedback_en <= 0;
		I2C_reconfig <= 0;
		PROMDataOk <= 1;
		TempDataOk <= 1;
	end	
	
	Temp_done:				//9  
	begin
		DelayTime <= 0;
		DelayEnable <= 0;	
		ADCResultDataTemp <= ReadData;	
		cnt_r <= 0;
		I2C_en <= 0;
		I2C_wdata <= 0;
		I2C_rdata <= 0;
		I2C_wr <= 0;
		feedback_en <= 0;
		I2C_reconfig <= 0;
		I2C_NM <= 0;
		PROMAddrTemp <= PROM0Addr;
		PROMDataOk <= 1;
		TempDataOk <= 0;		
	end	
	
	TempI2C_error:				//10
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
.I2C_scl(TempI2C_scl),
.I2C_sda_out(TempI2C_sda_out),
.I2C_sda_in(TempI2C_sda_in),
.I2C_wr(I2C_wr),
.I2C_wdata(I2C_wdata),
.I2C_rdata(I2C_rdata),
.I2C_en(I2C_en),
.I2C_NM(I2C_NM),
.I2C_done(I2C_done),
.I2C_error(I2C_error),
.I2C_error_time(I2C_error_time),
.I2C_ACKflg(TempI2C_ACKflg),
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



