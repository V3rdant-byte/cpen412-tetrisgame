// Copyright (C) 2018  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition"
// CREATED		"Sun Apr 14 21:13:58 2024"

module vga_interface(
	Clk,
	Reset_L,
	GraphicsCS_L,
	WE_L,
	AS_L,
	Address,
	Data_in,
	VGA_BLANK_N,
	VGA_CLK,
	VGA_HS,
	VGA_SYNC_N,
	VGA_VS,
	B,
	DataOut,
	G,
	R,
	state
);


input wire	Clk;
input wire	Reset_L;
input wire	GraphicsCS_L;
input wire	WE_L;
input wire	AS_L;
input wire	[11:0] Address;
input wire	[7:0] Data_in;
output wire	VGA_BLANK_N;
output wire	VGA_CLK;
output wire	VGA_HS;
output wire	VGA_SYNC_N;
output wire	VGA_VS;
output wire	[7:0] B;
output wire	[7:0] DataOut;
output wire	[7:0] G;
output wire	[7:0] R;
output wire	[4:0] state;

wire	SYNTHESIZED_WIRE_0;
wire	[7:0] SYNTHESIZED_WIRE_1;
wire	[7:0] SYNTHESIZED_WIRE_2;
wire	[7:0] SYNTHESIZED_WIRE_3;
wire	[7:0] SYNTHESIZED_WIRE_4;
wire	[7:0] SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_22;
wire	[11:0] SYNTHESIZED_WIRE_7;
wire	SYNTHESIZED_WIRE_23;
wire	SYNTHESIZED_WIRE_9;
wire	SYNTHESIZED_WIRE_24;
wire	SYNTHESIZED_WIRE_12;
wire	[11:0] SYNTHESIZED_WIRE_13;
wire	[7:0] SYNTHESIZED_WIRE_14;
wire	SYNTHESIZED_WIRE_15;
wire	[7:0] SYNTHESIZED_WIRE_16;
wire	SYNTHESIZED_WIRE_19;
wire	SYNTHESIZED_WIRE_20;
wire	SYNTHESIZED_WIRE_21;

assign	VGA_BLANK_N = 1;
assign	VGA_CLK = Clk;
assign	VGA_SYNC_N = 0;




vga80x40	b2v_inst(
	.reset(SYNTHESIZED_WIRE_0),
	.clk25MHz(Clk),
	.FONT_D(SYNTHESIZED_WIRE_1),
	.ocrx(SYNTHESIZED_WIRE_2),
	.ocry(SYNTHESIZED_WIRE_3),
	.octl(SYNTHESIZED_WIRE_4),
	.TEXT_D(SYNTHESIZED_WIRE_5),
	.R(SYNTHESIZED_WIRE_19),
	.G(SYNTHESIZED_WIRE_20),
	.B(SYNTHESIZED_WIRE_21),
	.hsync(VGA_HS),
	.vsync(VGA_VS),
	.FONT_A(SYNTHESIZED_WIRE_7),
	.TEXT_A(SYNTHESIZED_WIRE_13));

assign	SYNTHESIZED_WIRE_0 =  ~Reset_L;




VGA_controller	b2v_inst12(
	.Clk(Clk),
	.Reset_L(Reset_L),
	.WREN(SYNTHESIZED_WIRE_22),
	.Address(Address),
	.Data(Data_in),
	.Ram_WE_H(SYNTHESIZED_WIRE_12),
	.data_out(SYNTHESIZED_WIRE_14),
	.ocrx(SYNTHESIZED_WIRE_2),
	.ocry(SYNTHESIZED_WIRE_3),
	.octl(SYNTHESIZED_WIRE_4),
	.state(state));
	defparam	b2v_inst12.ADDRESS_INIT = 12'b000000000000;
	defparam	b2v_inst12.CRX_INIT = 8'b00101000;
	defparam	b2v_inst12.CRX_REG_UPDATE = 3'b011;
	defparam	b2v_inst12.CRY_INIT = 8'b00010100;
	defparam	b2v_inst12.CRY_REG_UPDATE = 3'b100;
	defparam	b2v_inst12.CTL_INIT = 8'b11110101;
	defparam	b2v_inst12.CTL_REG_UPDATE = 3'b010;
	defparam	b2v_inst12.DATA_INIT = 1'b0;
	defparam	b2v_inst12.IDLE = 3'b001;
	defparam	b2v_inst12.INIT = 3'b000;
	defparam	b2v_inst12.Ram_WE_H_INIT = 1'b0;


initial_font	b2v_inst2(
	.clock(Clk),
	.address(SYNTHESIZED_WIRE_7),
	.q(SYNTHESIZED_WIRE_1));

assign	SYNTHESIZED_WIRE_22 = SYNTHESIZED_WIRE_23 & SYNTHESIZED_WIRE_9 & SYNTHESIZED_WIRE_24;


text_buffer	b2v_inst3(
	.wren_a(SYNTHESIZED_WIRE_22),
	.wren_b(SYNTHESIZED_WIRE_12),
	.clock(Clk),
	.address_a(Address),
	.address_b(SYNTHESIZED_WIRE_13),
	.data_a(Data_in),
	.data_b(SYNTHESIZED_WIRE_14),
	.q_a(SYNTHESIZED_WIRE_16),
	.q_b(SYNTHESIZED_WIRE_5));


lpm_bustri2	b2v_inst34(
	.enabledt(SYNTHESIZED_WIRE_15),
	.data(SYNTHESIZED_WIRE_16),
	.tridata(DataOut)
	);

assign	SYNTHESIZED_WIRE_23 =  ~GraphicsCS_L;

assign	SYNTHESIZED_WIRE_9 =  ~WE_L;

assign	SYNTHESIZED_WIRE_24 =  ~AS_L;

assign	SYNTHESIZED_WIRE_15 = SYNTHESIZED_WIRE_24 & SYNTHESIZED_WIRE_23 & WE_L;


extend_bits	b2v_inst8(
	.R(SYNTHESIZED_WIRE_19),
	.G(SYNTHESIZED_WIRE_20),
	.B(SYNTHESIZED_WIRE_21),
	.B_byte(B),
	.G_byte(G),
	.R_byte(R));


endmodule
