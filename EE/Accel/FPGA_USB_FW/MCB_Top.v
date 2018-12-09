//-----------------------------------------------------------------------------
//Copyright(c) 2015, SVision Research Inc
//SVR Confidential Proprietary
//All rights reserved.
//-----------------------------------------------------------------------------
//
//IP LIB INDEX      :    
//IP Name           :                                                                                
//File Name         :                                                                                
//Module name       :  MCB Top                                                                            
//Full name         :                                                                                
//                                                                                                   
//Author            :  Honglei.Yan                                                                  
//Email             :                                                                                
//Data              :  2018.01.18                                                                              
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
module MCB_Top(
	input clk_pad,				// system clock; 25MHz
	inout [15:0] fdata,			//usb control chip data bus
	output wire [1:0] faddr,			//usb endpoint address
	output wire slrd,				//usb read, active low
	output wire slwr,				//usb read enable, active low
	output wire sloe,				//usb write enable, active low
	output wire pktend,				//usb pktend
	output wire ifclk,				//usb IFCLK
	input flaga,				//cmd_ep_empty
	input flagd				//data_ep_full
);  
wire pll_locked;		//PLL locked
//////clock wire list/////////
wire clk_40M;
wire clk_25M;		//25MHz
wire clk_1M;		//1MHz
wire clk_10M;		//10MHz
wire clk_400K;
wire clk_25M_;
wire clk_10M_;
assign clk_25M_ = ! clk_25M;
assign clk_10M_ = ! clk_10M;

//////Reset wire list/////////
wire reset_n;						//reset; active low
wire local_rst;						//local reset after power on
wire aclr;							//aclr; active high
wire sw_rst;						//software reset

//////ADC wire list/////////
wire [15:0] adc_ch0_data;			//ADC Ch0 data 
wire [15:0] adc_ch1_data;			//ADC Ch1 data 
wire [15:0] adc_ch2_data;			//ADC Ch2 data 
wire [15:0] adc_ch3_data;			//ADC Ch3 data 
wire [15:0] adc_ch4_data;			//ADC Ch4 data 
wire [15:0] adc_ch5_data;			//ADC Ch5 data 
wire [15:0] adc_ch6_data;			//ADC Ch6 data 
wire [15:0] adc_ch7_data;			//ADC Ch7 data

//////Command wire list/////////
wire [15:0] FixationPattern;
wire [1:0] BlinkSpeed;
wire [15:0] cmd_th;
wire [15:0] cmd_led;
wire [15:0] data_to_fifo;		//data input to DATAFIFO
wire [15:0] data_to_usb;		//data input to usb module
wire [15:0] cmd_out;			//command output from usb module
wire cmd_wen;					//command write enable
wire data_ren;					//data read enable
wire cmd_fifo_full;				//command FIFO full flag
wire data_fifo_empty;			//data FIFO empty flag
wire [15:0] cmd;				//input of the command module
wire cmd_fifo_empty;			//command FIFO empty flag
wire [15:0] cmd_in;				//output of the command module
wire cmd_ren;					//command read enable;high active
wire data_wen;					//write enable of DATAFIFO
wire xy_galvo_rst; 				//OCT galvo monitor reset from SW; active high
wire laser_pwr_rst;				//OCT laser power monitor reset from SW; active high  
wire [15:0] safety_status;		//OCT safety control signal status 	



/////Temperature module////////
wire [15:0] PROM0Data0;
wire [15:0] PROM0Data1;
wire [15:0] PROM0Data2;
wire [15:0] PROM0Data3;
wire [15:0] PROM0Data4;
wire [23:0] ADCResultData0;
wire [15:0] PROM1Data0;
wire [15:0] PROM1Data1;
wire [15:0] PROM1Data2;
wire [15:0] PROM1Data3;
wire [15:0] PROM1Data4;
wire [23:0] ADCResultData1;
wire [15:0] PROM2Data0;
wire [15:0] PROM2Data1;
wire [15:0] PROM2Data2;
wire [15:0] PROM2Data3;
wire [15:0] PROM2Data4;
wire [23:0] ADCResultData2;
wire [15:0] PROM3Data0;
wire [15:0] PROM3Data1;
wire [15:0] PROM3Data2;
wire [15:0] PROM3Data3;
wire [15:0] PROM3Data4;
wire [23:0] ADCResultData3;


assign DataFifoWen = ROMRF ? ROMRFifoEn_RClk : data_wen;
assign DataFifoWData = ROMRF ? ROMRFifoData : data_to_fifo;
assign GalvoTopRst = reset_n && !GalvoRst;

//command module
CMD U_CMD(
	.clk_in(clk_10M),
	.reset_n(reset_n),
	.cmd(cmd),
	.cmd_in(cmd_in),
	.GalvoCMDFlag(GalvoCMDFlag),
	.GalvoCMDBack(GalvoCMDBack),
	.cmd_fifo_empty(cmd_fifo_empty),
	.sw_rst(sw_rst),
	.cmd_ren(cmd_ren),
	.xy_galvo_rst(xy_galvo_rst),
	.laser_pwr_rst(laser_pwr_rst),
	.exter_target(exter_target),
	.cmd_led(cmd_led),
	.cmd_th(cmd_th),
	.RAMWSum(RAMWSumTest),
	.WStartAddr(WStartAddr),
	.RAMWEn(RAMWEn),
	.RAMWDone(RAMWDone),
	.FixationPattern(FixationPattern),
	.BlinkSpeed(BlinkSpeed),
	.GalvoStart(GalvoStart),
	.GalvoRst(GalvoRst),
	.GalvoLaserSyncFlag(GalvoLaserSyncFlag),
	.LineRepeatSum(LineRepeatSum),
	.ScanStartAddr(ScanStartAddr),
	.ScanLineSum(ScanLineSum),
	.MarkDelay(MarkDelay),
	.FrameTrigDelay(FrameTrigDelay),
	.JumpDelay(JumpDelay),	
	.JumpInterval(JumpInterval),
	.XIdlePos(XIdlePos),
	.YIdlePos(YIdlePos),
	.ROMWPageDoneF(ROMWPageDoneF),
	.ROMWEn(ROMWEn),
	.ROMWritingF(ROMWritingF),
	.PageIndex(PageIndex),
	.ROMRDoneF(ROMRDoneF),
	.ROMREn(ROMREn),
	.ROMRSum(ROMRSum),
	.ROMRF(ROMRF),
	.ROMEEn(ROMEEn),
	.ROMEDoneF(ROMEDoneF)
);



//command fifo
CMDFIFO U_CMDFIFO(
	.aclr    ( aclr           ),
	.data    ( cmd_out        ),
	.rdclk   ( clk_10M_       ),
	.rdreq   ( cmd_ren | ROMWFifoEn),
	.wrclk   ( clk_25M_       ),
	.wrreq   ( cmd_wen        ),
	.q       ( cmd            ),
	.rdempty ( cmd_fifo_empty ),
	.wrfull  ( cmd_fifo_full  )
);

FX2_SLAVEFIFO U_FX2_SLAVEFIFO(
	.clk(clk_25M),
	.reset_n(reset_n),
	.fdata(fdata), 
	.faddr(faddr),
	.slrd(slrd),
	.slwr(slwr),
	.sloe(sloe),
	.pktend(pktend),
	.flaga(flaga),
	.flagd(flagd),
	.data_in(data_to_usb),				//??
	.cmd_out(cmd_out),
	.cmd_wen(cmd_wen),
	.data_ren(data_ren),
	.cmd_fifo_full(cmd_fifo_full),
	.data_fifo_empty(data_fifo_empty),
	.ROMRDoneF(ROMRDoneF),
	.SendCMDDoneFlag(SendCMDDoneFlag)
);

DATAFIFO  U_DATAFIFO(
	.aclr(aclr),
	.wrclk(clk_25M),
	.wrreq(DataFifoWen),
	.data(DataFifoWData),
	.rdclk(clk_25M_),
	.rdreq(data_ren),
	.q(data_to_usb),
	.rdempty(data_fifo_empty)
);

DATA U_DATA(
	.clk(clk_25M_), 
	.reset_n(reset_n), 
	.GalvoCMDFlag(GalvoCMDFlag),
	.GalvoCMDBack(GalvoCMDBack),
	.safety_status(safety_status),
	.data_fifo_empty(data_fifo_empty),
	.data_to_fifo(data_to_fifo),
	.data_wen(data_wen),
	.GalvoStatus(GalvoStatus),
	.GalvoWait(GalvoWait),
	.GalvoErrorFlag(GalvoErrorFlag),
	.XGalvoReady(XGalvoReady),
	.YGalvoReady(YGalvoReady),
	.GalvoLaserSyncFlag(GalvoLaserSyncFlag),
	.ScanLineIndex(RStartAddr[13:3]),
	.SendCMDDoneFlag(SendCMDDoneFlag),
	.ROMRF(ROMRF),
	.adc_ch0_data   (adc_ch0_data   ), 
	.adc_ch1_data   (adc_ch1_data   ), 
	.adc_ch2_data   (adc_ch2_data   ), 
	.adc_ch3_data   (adc_ch3_data   ), 
	.adc_ch4_data   (adc_ch4_data   ), 
	.adc_ch5_data   (adc_ch5_data   ), 
	.adc_ch6_data   (adc_ch6_data   ), 
	.adc_ch7_data   (adc_ch7_data   ), 
	.PROM0Data0     (PROM0Data0    ),
	.PROM0Data1     (PROM0Data1    ),
	.PROM0Data2     (PROM0Data2    ),
	.PROM0Data3     (PROM0Data3    ),
	.PROM0Data4     (PROM0Data4    ),
	.ADCResultData0 (ADCResultData0),
	.PROM1Data0     (PROM1Data0    ),
	.PROM1Data1     (PROM1Data1    ),
	.PROM1Data2     (PROM1Data2    ),
	.PROM1Data3     (PROM1Data3    ),
	.PROM1Data4     (PROM1Data4    ),
	.ADCResultData1 (ADCResultData1),
	.PROM2Data0     (PROM2Data0    ),
	.PROM2Data1     (PROM2Data1    ),
	.PROM2Data2     (PROM2Data2    ),
	.PROM2Data3     (PROM2Data3    ),
	.PROM2Data4     (PROM2Data4    ),
	.ADCResultData2 (ADCResultData2),
	.PROM3Data0     (PROM3Data0    ),
	.PROM3Data1     (PROM3Data1    ),
	.PROM3Data2     (PROM3Data2    ),
	.PROM3Data3     (PROM3Data3    ),
	.PROM3Data4     (PROM3Data4    ),
	.ADCResultData3 (ADCResultData3)
);

Temp_top U_Temp_top(
	.clk_in         (clk_25M       ),
	.clk_I2C        (clk_400K      ),
	.DelayClk       (clk_1M        ),
	.reset_n		(reset_n		),
	.TempI2C_scl0   (TempI2C_scl0  ),	
	.TempI2C_scl1   (TempI2C_scl1  ),
	.TempI2C_sda0   (TempI2C_sda0  ),	
	.TempI2C_sda1   (TempI2C_sda1  ),
	.PROM0Data0     (PROM0Data0    ),
	.PROM0Data1     (PROM0Data1    ),
	.PROM0Data2     (PROM0Data2    ),
	.PROM0Data3     (PROM0Data3    ),
	.PROM0Data4     (PROM0Data4    ),
	.ADCResultData0 (ADCResultData0),
	.PROM1Data0     (PROM1Data0    ),
	.PROM1Data1     (PROM1Data1    ),
	.PROM1Data2     (PROM1Data2    ),
	.PROM1Data3     (PROM1Data3    ),
	.PROM1Data4     (PROM1Data4    ),
	.ADCResultData1 (ADCResultData1),
	.PROM2Data0     (PROM2Data0    ),
	.PROM2Data1     (PROM2Data1    ),
	.PROM2Data2     (PROM2Data2    ),
	.PROM2Data3     (PROM2Data3    ),
	.PROM2Data4     (PROM2Data4    ),
	.ADCResultData2 (ADCResultData2),
	.PROM3Data0     (PROM3Data0    ),
	.PROM3Data1     (PROM3Data1    ),
	.PROM3Data2     (PROM3Data2    ),
	.PROM3Data3     (PROM3Data3    ),
	.PROM3Data4     (PROM3Data4    ),
	.ADCResultData3 (ADCResultData3)	
);

InitMCB U_InitMCB(
	.DelayClk(clk_400K),		//400KHz 
	.reset_n(local_rst),
	.InitDelayDone(InitDelayDone)
);

//PLL
MCB_PLL U_MCB_PLL (
	.inclk0(clk_pad),
	.c0(clk_25M),
	.c1(clk_40M),
	.c2(clk_10M),
	.c3(clk_400K),
	.locked(pll_locked)
);

CLK_PLL U_CLK_PLL(
	.inclk0(clk_pad),
	.c0(clk_1M)
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

//USB 2.0 clock
USB_CLK U_USB_CLK(
	.datain_h(1'b0),
	.datain_l(1'b1),
	.outclock(clk_25M),
	.dataout (ifclk)
);

/* DAC_MAX5702 U10_DAC_MAX5702(
	.clk      (clk_10M ),
	.reset_n  (reset_n ),
	.cmd      (cmd_led ),
	.dac_csb  (led_csb ),
	.dac_sclk (led_sclk),
	.dac_din  (led_din ),
	.dac_clr  (led_clr ) 
); */

/* DAC_MAX5702 U50_DAC_MAX5702(
	.clk      (clk_10M),
	.reset_n  (reset_n),
	.cmd      (cmd_th ),
	.dac_csb  (th_csb ),
	.dac_sclk (th_sclk),
	.dac_din  (th_din ),
	.dac_clr  (th_clr ) 
);

OCT_SAFETY_CONTROL U_OCT_SAFETY_CONTROL(
	.clk(clk_10M),
	.reset_n(local_rst),
	.x_pos(x_pos),
	.y_pos(y_pos),
	.xy_galvo(xy_galvo),
	.laser_pwr(laser_pwr),
	.xy_galvo_rst(xy_galvo_rst),
	.laser_pwr_rst(laser_pwr_rst),
	.laser_interlock(laser_interlock),
	.oct_engine_on_off(oct_engine_on_off),
	.ROMWritingF(ROMWritingF),
	.ROMErasingF(ROMErasingF),
	.safety_status(safety_status) 
); */

/* ADC U_ADC(
	.clk       (clk_10M      ) ,
	.reset_n   (reset_n      ) ,
	.cs_       (adc_cs_      ) ,
	.sclk      (adc_sclk     ) ,
	.din       (adc_dout     ) , // din connected to adc_dout
	.dout      (adc_din      ) , // dout connected to adc_din
	.ch0_data  (adc_ch0_data ) ,
	.ch1_data  (adc_ch1_data ) ,
	.ch2_data  (adc_ch2_data ) ,
	.ch3_data  (adc_ch3_data ) ,
	.ch4_data  (adc_ch4_data ) ,
	.ch5_data  (adc_ch5_data ) ,
	.ch6_data  (adc_ch6_data ) ,
	.ch7_data  (adc_ch7_data )
); */

endmodule
