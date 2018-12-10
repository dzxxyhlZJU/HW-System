//synopsys translate_off
`timescale 1 ns / 100 ps
//synopsys translate_on
module MCB_Top(
	input clk_pad,
	output wire Accel_scl,
	inout Accel_sda
);

//////clock wire list/////////
wire clk_25M;		//25MHz
wire clk_40M;
wire clk_10M;		//10MHz
wire clk_400K;

//////Reset wire list/////////
wire sw_rst;						//software reset
wire pll_locked;					//PLL locked
wire reset_n;						//reset; active low
wire local_rst;						//local reset after power on
wire aclr;							//aclr; active high


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

Accel_top Accel_top(
	.clk_in(clk_25M),
	.clk_I2C(clk_400K),
	.reset_n(reset_n),
	.Accel_scl(Accel_scl),	
	.Accel_sda(Accel_sda)
);

endmodule







