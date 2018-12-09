`timescale 1ps/1ps 
module I2C_Bus(
	reset_n,
	clk_in,
	I2C_scl,
	I2C_sda_out,
	I2C_sda_in,
	I2C_wr,
	I2C_wdata,
	I2C_rdata,
	I2C_en,
	I2C_NM,
	I2C_done,
	I2C_error,
	I2C_error_time,
	I2C_ACKflg,
	ReadData,
	I2CIOStatus
);

input reset_n;
input clk_in;
input I2C_en;
input I2C_wr;
input [31:0] I2C_wdata;
input [31:0] I2C_rdata;
input [4:0] I2C_NM;

output reg I2C_scl;
output reg I2C_done;
output I2C_ACKflg;
output reg I2C_error;
output I2CIOStatus;

//reg I2C_sda;
reg [5:0] cnt;
reg [4:0] NMnow;
output I2C_sda_out;
input I2C_sda_in;
reg [4:0] Data_Num;
reg [7:0] I2C_rdata_temp;

reg [5:0] temp;
reg I2C_sda_out_temp;
output reg [7:0] I2C_error_time;
reg [23:0] ReadData_temp;
output reg [23:0] ReadData;

//assign I2C_ACKflg = ((cnt>=0)&&(cnt<=3)&&(NMnow))||(I2C_wr&&(NMnow==(I2C_NM-1))&&(cnt>=5)&&(cnt<=35));
assign I2C_ACKflg = ((cnt>=0)&&(cnt<=3)&&(NMnow));
assign I2C_sda_out = I2C_ACKflg ? 1'b0 : I2C_sda_out_temp;

assign I2CIOStatus = I2C_wr ? ((NMnow>0 && NMnow<I2C_NM) ? ((NMnow==1 && I2C_ACKflg) ? 1'b1 : !I2C_ACKflg):1'b0 ) :I2C_ACKflg;

always @(posedge clk_in or negedge reset_n)
if(!reset_n)
begin
	I2C_scl <= 1;
	I2C_sda_out_temp <= 1;
	cnt <= 0;
//	I2C_rdata <= 0;
	NMnow <= 0;
	Data_Num <= 0;
	I2C_done <= 0;
	//I2C_error <= 0;
	I2C_error_time <= 0;
	ReadData_temp <= 0;
	ReadData <= 0;
end
else
begin
	if(I2C_en==1)
	begin
		if(!I2C_wr)						//write mode
		begin
			if(NMnow < I2C_NM)
			begin
				begin
					if(cnt[1]==1)
						I2C_scl <= 0;
					else
					begin
						I2C_scl <= 1;
						if((cnt>=0)&&(cnt<=3)&&(NMnow)&&I2C_sda_in)
						begin
							//Data_Num <= 0;
							Data_Num <= (I2C_NM-1'b1)<<3;
						end
					end	
				end
				
				if((cnt==2)&&(NMnow)&&(I2C_sda_in))					
				begin
					I2C_error <= 1;
					I2C_error_time <= I2C_error_time+1'b1;
				end
				
				if(cnt==0)
				begin
					I2C_sda_out_temp <= 1;
					Data_Num <= (I2C_NM-NMnow-1'b1)<<3;
				end
				if(cnt==1)
				begin
					I2C_sda_out_temp <= 0;
				end	
				if(cnt[1:0]==3)	
				begin
					temp <= Data_Num+4'h7-cnt[4:2];
					I2C_sda_out_temp <= I2C_wdata[Data_Num+4'h7-cnt[4:2]];								
				end				
				if(cnt==35)
				begin
					cnt <= 0;
					NMnow <= NMnow+4'h1;
				end
				
				else
					cnt <= cnt+4'h1;				
			end
			else
			begin
				if(cnt==0 || cnt==1 || cnt>3)
					I2C_scl <= 1;
				else
					I2C_scl <= 0;
				if(cnt<6)
				begin
					I2C_sda_out_temp <= 0;
				end
				if(cnt==6)
				begin
					I2C_sda_out_temp <= 1;
					I2C_done <= 1;
					I2C_error_time <= 0;
					cnt <= cnt+4'h1;
				end
				if(cnt==7)
				begin
					I2C_done <= 0;
				end
				else if(cnt<12)
				begin
					cnt <= cnt+4'h1;
				end
			end
		end
		else								//read mode
		begin
			if(NMnow < 1)			//read order write
			begin
				begin
					if(cnt[1]==1)
						I2C_scl <= 0;
					else
					begin
						I2C_scl <= 1;
						if((cnt>=0)&&(cnt<=3)&&(NMnow)&&I2C_sda_in)	//ack time
						begin
							Data_Num <= (I2C_NM-4'h1)<<3;
						end
					end	
				end
				
				if((cnt==2)&&(NMnow)&&(I2C_sda_in))					
				begin
					I2C_error <= 1;
					I2C_error_time <= I2C_error_time+4'h1;
				end
				
				if(cnt==0)
				begin
					I2C_sda_out_temp <= 1;
					Data_Num <= (I2C_NM-NMnow-4'h1)<<3;
				end
				if(cnt==1)
				begin
					I2C_sda_out_temp <= 0;
				end	
				if(cnt[1:0]==3)	
				begin
					temp <= Data_Num+4'h7-cnt[4:2];
					I2C_sda_out_temp <= I2C_rdata[Data_Num+7-cnt[4:2]];								
				end
				if(cnt==35)
				begin
					cnt <= 0;
					NMnow <= NMnow+4'h1;
				end
				
				else
					cnt <= cnt+4'h1;				
			end
			else if(NMnow < I2C_NM)			//read input
			begin
				begin
					if(cnt[1]==1)
						I2C_scl <= 0;
					else
					begin
						I2C_scl <= 1;
						if((cnt>=0)&&(cnt<=3)&&(NMnow)&&I2C_sda_in)	//ack time: wrong ack back
						begin
							Data_Num <= (I2C_NM-4'h1)<<3;
						end
					end	
				end
				
				if((cnt==2)&&(NMnow)&&(I2C_sda_in))					
				begin
					I2C_error <= 1;
					I2C_error_time <= I2C_error_time+4'h1;
				end
				
				if(cnt==0)
				begin
					I2C_sda_out_temp <= 1;
					Data_Num <= (I2C_NM-NMnow-4'h1)<<3;
				end
				if(cnt==1)
				begin
					I2C_sda_out_temp <= 0;
				end	
				if(cnt[1:0]==3)	
				begin
					temp <= Data_Num+4'h7-cnt[4:2];
					I2C_sda_out_temp <= I2C_rdata[Data_Num+7-cnt[4:2]];								
				end
				if(cnt==35)
				begin
					cnt <= 0;
					NMnow <= NMnow+4'h1;
				end
				
				else
					cnt <= cnt+4'h1;	
				begin
					if(cnt[1:0]==1 && cnt>2)
						ReadData_temp[temp] <= I2C_sda_in;				
				end
				
			end	
			
			else		//stop signal
			begin
				if(cnt==0 || cnt==1 || cnt>3)
					I2C_scl <= 1;
				else
					I2C_scl <= 0;
				if(cnt<6)
				begin
					I2C_sda_out_temp <= 0;
				end
				if(cnt==6)
				begin
					I2C_sda_out_temp <= 1;
					I2C_done <= 1;
					ReadData <= ReadData_temp;
					I2C_error_time <= 0;
					cnt <= cnt+4'h1;
				end
				if(cnt==7)
				begin
					I2C_done <= 0;
				end
				else if(cnt<12)
				begin
					cnt <= cnt+4'h1;
				end
			end
		end
	end	
			
	else
	begin
		cnt <= 0;
		NMnow <= 0;
		I2C_error <= 0;
		I2C_done <= 0;
	end
end





endmodule






