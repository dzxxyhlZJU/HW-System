`timescale 1ps/1ps 
module I2C_main_tb();

reg reset_n;
reg clk_in;
reg clk_I2C;
reg Accel_sda_in;
reg [7:0] AccelI2C_error_NM;
reg configure_en;


I2C_main I2C_main(
	.reset_n(reset_n),
	.clk_in(clk_in),
	.DelayClk(clk_I2C),
	.clk_I2C(clk_I2C),
	.Accel_sda_in(Accel_sda_in),
	.AccelI2C_error_NM(AccelI2C_error_NM),
	.configure_en(configure_en)
);


initial
begin
	reset_n = 0;
	clk_in = 0;
	clk_I2C = 0;
	Accel_sda_in = 0;
	AccelI2C_error_NM = 8'd16;
	configure_en = 0;

	#400
	reset_n = 1;	

end

always
begin
	#10
	clk_in = ~clk_in;		//25MHz
end

always
begin
	#625
	clk_I2C = ~clk_I2C;
end



endmodule