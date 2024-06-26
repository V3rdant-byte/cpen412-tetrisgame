`default_nettype none
module MC68K(
input wire	RS232_RxData,
input wire	CLOCK_50,
input wire	Reset_L,
input wire	TraceRequest_L,
input wire	IRQ2_L,
input wire	IRQ4_L,
input wire	[9:0] SW,
output wire	RS232_TxData,
output wire	DRAM_CLK,
output wire	DRAM_CKE,
output wire	DRAM_CS_N,
output wire	DRAM_CAS_N,
output wire	DRAM_RAS_N,
output wire	DRAM_WE_N,
output wire	DRAM_UDQM,
output wire	DRAM_LDQM,
output wire	CPUClock,
output wire	Dtack_L,
output wire	RomSelect_H,
output wire	RamSelect_H,
output wire	DramRamSelect_H,
output wire	IOSelect_H,
output wire	ResetOut,
output wire	DramDtack_L,
output wire	AS_L,
output wire	UDS_L,
output wire	RW,
output wire	[31:0] AddressBus,
output wire	[15:0] DataBusIn,
output wire	[15:0] DataBusOut,
output wire	[12:0] DRAM_ADDR,
output wire	[1:0] DRAM_BA,
inout wire	[15:0] DRAM_DQ,
output wire	[6:0] HEX0,
output wire	[6:0] HEX1,
output wire	[6:0] HEX2,
output wire	[6:0] HEX3,
output wire	[6:0] HEX4,
output wire	[6:0] HEX5,
output wire	[9:0] LEDR,


//////////// Audio //////////
input                       AUD_ADCDAT,
inout                       AUD_ADCLRCK,
inout                       AUD_BCLK,
output                      AUD_DACDAT,
inout                       AUD_DACLRCK,
output                      AUD_XCK,

//////////// I2C for Audio  //////////
output                      FPGA_I2C_SCLK,
inout                       FPGA_I2C_SDAT,

///////// ADC /////////
output              ADC_CONVST,
output             ADC_DIN,
input              ADC_DOUT,
output             ADC_SCLK,

///////// VGA /////////
output      [7:0]  VGA_B,
output             VGA_BLANK_N,
output             VGA_CLK,
output      [7:0]  VGA_G,
output             VGA_HS,
output      [7:0]  VGA_R,
output             VGA_SYNC_N,
output             VGA_VS


);


wire	[31:0] Address;
wire	Clock25Mhz;
wire	Clock30Mhz;
wire	Clock50Mhz;
wire	Clock50Mhz_Inverted;
wire	[15:0] DataBusIn_Composite;
wire	[15:0] DataBusOut_Composite;
wire	[31:0] DMA_Address;
wire	DMA_AS_L;
wire	[15:0] DMA_DataOut;
wire	DMA_LDS_L;
wire	DMA_RW;
wire	DMA_UDS_L;
wire	[7:0] InPortA;
wire	[7:0] InPortB;
wire	[7:0] OutPortB;
wire	TraceException_H;
wire	Timer1_IRQ;
wire	Timer3_IRQ;
wire	Timer2_IRQ;
wire	Timer4_IRQ;
wire	Timer7_IRQ;
wire	Timer6_IRQ;
wire	Timer8_IRQ;
wire	Timer5_IRQ;
wire	CPU_AS_L;
wire	CPU_UDS_L;
wire	CPU_LDS_L;
wire	CPU_RW;
wire	[31:0] CPU_Address;
wire	[15:0] CPU_DataBusOut;
wire	BR_L;
wire	[2:0] IPL;
wire	CanBusSelect_H;
wire	CanBusDtack_L;
wire	DataBusIn_OE;
wire	Trdata_OE;
wire	TraceIRQ_L;
wire	ACIA_IRQ;
wire	OffBoardMemory_H;
wire	RESET_H;
wire	BG_L;
wire	LDS_L;

logic  ltc2308_start;
logic  ltc2308_start_raw;
logic  ltc2308_finish;
logic  [5:0] ltc2308_word_to_write_raw;
logic  [5:0] ltc2308_word_to_write;
logic  [11:0] ltc2308_parallel_data_read_by_spi_master;
logic  [1:0]dummy;
	
wire GraphicsCS_L;
wire [4:0] state;
vga_interface vi(
	.Clk(Clock25Mhz),
	.Reset_L(Reset_L),
	.GraphicsCS_L(GraphicsCS_L),
	.WE_L(RW),
	.AS_L(AS_L),
	.Address(Address[11:0]),
	.Data_in(DataBusOut_Composite[15:8]),
	.VGA_BLANK_N(VGA_BLANK_N),
	.VGA_CLK(VGA_CLK),
	.VGA_HS(VGA_HS),
	.VGA_SYNC_N(VGA_SYNC_N),
	.VGA_VS(VGA_VS),
	.B(VGA_B),
	.DataOut(DataBusIn_Composite[15:8]),
	.G(VGA_G),
	.R(VGA_R),
	.state(state)
);

OnChipM68xxIO	b2v_inst11(
	.Clock_50Mhz(Clock50Mhz),
	.IOSelect(IOSelect_H),
	.UDS_L(UDS_L),
	.AS_L(AS_L),
	.WE_L(RW),
	.Clk(Clock25Mhz),
	.Reset_L(Reset_L),
	.RS232_RxData(RS232_RxData),
	.Address(Address),
	.DataIn(DataBusOut_Composite[15:8]),
	.ACIA_IRQ(ACIA_IRQ),
	.RS232_TxData(RS232_TxData),
	.DataOut(DataBusIn_Composite[15:8]));


assign	RESET_H =  ~Reset_L;


CPU_DMA_Mux	b2v_inst14(
	.CPU_DMA_Select(1'b1),
	.DMA_AS_L(DMA_AS_L),
	.DMA_RW(DMA_RW),
	.DMA_UDS_L(DMA_UDS_L),
	.DMA_LDS_L(DMA_LDS_L),
	.CPU_AS_L(CPU_AS_L),
	.CPU_UDS_L(CPU_UDS_L),
	.CPU_LDS_L(CPU_LDS_L),
	.CPU_RW(CPU_RW),
	.CPU_Address(CPU_Address),
	.CPU_DataBusOut(CPU_DataBusOut),
	.DMA_Address(DMA_Address),
	.DMA_DataBusOut(DMA_DataOut),
	.AS_L(AS_L),
	.UDS_L(UDS_L),
	.LDS_L(LDS_L),
	.RW(RW),
	.AddressOut(Address),
	.DataOut(DataBusOut_Composite)
);



OnChipROM16KWords	b2v_inst16(
	.RomSelect_H(RomSelect_H),
	.Clock(Clock25Mhz),
	.Address(Address[14:1]),
	.DataOut(DataBusIn_Composite));


M68000CPU	b2v_inst17(
	.Clk(Clock25Mhz),
	.Reset_L(Reset_L),
	.Dtack_L(Dtack_L),
	.BR_L(1'b1),
	.BGACK_L(1'b1),
	.DataBusIn(DataBusIn_Composite),
	.IPL(IPL),
	.AS_L(CPU_AS_L),
	.UDS_L(CPU_UDS_L),
	.LDS_L(CPU_LDS_L),
	.RW(CPU_RW),
	.BG_L(BG_L),
	.Address(CPU_Address),
	.DataBusOut(CPU_DataBusOut));

Dram	b2v_inst2(
	.WE_L(RW),
	.Clock50Mhz_Inverted(Clock50Mhz_Inverted),
	.Reset_L(Reset_L),
	.DramSelect_H(DramRamSelect_H),
	.LDS_L(LDS_L),
	.UDS_L(UDS_L),
	.AS_L(AS_L),
	.Address(Address),
	.DataIn(DataBusOut_Composite),
	.sdram_dq(DRAM_DQ),
	.sdram_cke(DRAM_CKE),
	.sdram_cs_n(DRAM_CS_N),
	.sdram_ras_n(DRAM_RAS_N),
	.sdram_cas_n(DRAM_CAS_N),
	.sdram_we_n(DRAM_WE_N),
	.DramDtack_L(DramDtack_L),
	.ResetOut_L(ResetOut),
	.DataOut(DataBusIn_Composite),
	
	.sdram_a(DRAM_ADDR),
	.sdram_ba(DRAM_BA),
	
	.sdram_dqm({DRAM_UDQM,DRAM_LDQM})
	);
               
wire speech_synthesize_write_H;
wire speech_synthesize_read_H;
AddressDecoder_Verilog	b2v_inst20(
	.Address(Address),
	.OnChipRomSelect_H(RomSelect_H),
	.OnChipRamSelect_H(RamSelect_H),
	.DramSelect_H(DramRamSelect_H),
	.IOSelect_H(IOSelect_H),
	.DMASelect_L(),
	.GraphicsCS_L(GraphicsCS_L),
	.OffBoardMemory_H(OffBoardMemory_H),
	.CanBusSelect_H(CanBusSelect_H),
	.speech_synthesize_write_H(speech_synthesize_write_H),
	.speech_synthesize_read_H(speech_synthesize_read_H));


Dtack_Generator_Verilog	b2v_inst21(
	.AS_L(AS_L),
	.DramSelect_H(DramRamSelect_H),
	.DramDtack_L(DramDtack_L),
	.CanBusSelect_H(CanBusSelect_H),
	.CanBusDtack_L(CanBusDtack_L),
	.DtackOut_L(Dtack_L));


	wire [15:0] tr_data;
	assign tr_data = Trdata_OE ? DataBusOut_Composite : 16'bzzzz_zzzz_zzzz_zzzz;	
   assign DataBusIn_Composite = DataBusIn_OE ? tr_data : 16'bzzzz_zzzz_zzzz_zzzz;
	

InterruptPriorityEncoder	b2v_inst28(
	.IRQ7_L(1),
	.IRQ6_L(1),
	.IRQ5_L(TraceIRQ_L),
	.IRQ4_L(IRQ2_L),
	.IRQ3_L(Timer1_IRQ),
	.IRQ2_L(IRQ4_L),
	.IRQ1_L(ACIA_IRQ),
	.IPL(IPL));


TraceExceptionGenerator	b2v_inst30(
	.Clock(Clock25Mhz),
	.Reset(Reset_L),
	.AS_L(AS_L),
	.RW_L(RW),
	.SingleStep_H(TraceException_H),
	.TraceRequest_L(TraceRequest_L),
	.Address(Address),
	.TraceIRQ_L(TraceIRQ_L));

assign	Trdata_OE = RW & OffBoardMemory_H;

assign	DataBusIn_OE = ~(RW | AS_L);

OnChipRam256kbyte	b2v_inst6(
	.RamSelect_H(RamSelect_H),
	.UDS_L(UDS_L),
	.LDS_L(LDS_L),
	.WE_L(RW),
	.AS_L(AS_L),
	.Clock(Clock25Mhz),
	.Address(Address[17:1]),
	.DataIn(DataBusOut_Composite),
	.DataOut({DataBusIn_Composite[15:8],DataBusIn_Composite[7:0]}));


ClockGen	b2v_inst7(
	.refclk(CLOCK_50),
	.rst(RESET_H),
	.outclk_0(Clock25Mhz),
	.outclk_1(Clock30Mhz),
	.outclk_2(Clock50Mhz),
	.outclk_3(Clock50Mhz_Inverted)
	);


OnChipIO	b2v_inst8(
	.IOSelect(IOSelect_H),
	.WE_L(RW),
	.UDS_L(UDS_L),
	.AS_L(AS_L),
	.Clk(Clock25Mhz),
	.Reset_L(Reset_L),
	.Address(Address),
	.DataIn(DataBusOut_Composite[15:8]),
	.InPortA(InPortA),
	.InPortB(InPortB),
	.InPortC(),
	.InPortD(),
	.TraceExceptionBit_H(TraceException_H),
	.LCD_RS(),
	.LCD_E(),
	.LCD_RW(),
	.Timer1_IRQ(Timer1_IRQ),
	.Timer2_IRQ(Timer2_IRQ),
	.Timer3_IRQ(Timer3_IRQ),
	.Timer4_IRQ(Timer4_IRQ),
	.Timer5_IRQ(Timer5_IRQ),
	.Timer6_IRQ(Timer6_IRQ),
	.Timer7_IRQ(Timer7_IRQ),
	.Timer8_IRQ(Timer8_IRQ),
	.DataOut(DataBusIn_Composite[15:8]),
	.HexDisplay0(HEX0),
	.HexDisplay1(HEX1),
	.HexDisplay2(HEX2),
	.HexDisplay3(HEX3),
	.HexDisplay4(HEX4),
	.HexDisplay5(HEX5),	
	.LCD_DataOut(/*LCD_Data*/),
	.OutPortA(),
	.OutPortB(OutPortB),
	.OutPortC()	
	);

logic [7:0] datainport;
logic dataoutport;

assign	DRAM_CLK = Clock50Mhz;
assign	CPUClock = Clock25Mhz;
assign	AddressBus = Address;
assign	DataBusIn = DataBusIn_Composite;
assign	DataBusOut = DataBusOut_Composite;



logic [7:0] phoneme_sel;
logic phoneme_speech_busy  ;
logic phoneme_speech_finish;
logic start_phoneme_output;

speech_wrapper
sw
(
.clk(Clock50Mhz),
.rst(1'b0), //active high
.phoneme_speech_busy  (phoneme_speech_busy                 ),
.phoneme_speech_finish(phoneme_speech_finish               ),
.speech_synthesize_write_H  (speech_synthesize_write_H	),
.speech_synthesize_read_H	(speech_synthesize_read_H),
.datain				  (DataBusOut_Composite),
.phoneme_sel          (phoneme_sel          ),
.start_phoneme_output (start_phoneme_output ),
.dataout			  (DataBusIn_Composite),
.state               (LEDR[1:0])
);
assign LEDR[2] = phoneme_speech_busy;
assign LEDR[3] = start_phoneme_output;
assign LEDR[4] = speech_synthesize_read_H;
assign LEDR[5] = speech_synthesize_write_H;
// assign InPortA[7:0] = phoneme_sel;
// assign InPortB[0] = phoneme_speech_busy;
// speech_synthesizer_wrapper 
// speech_synthesizer_inst
// (
// .clk(Clock50Mhz),
// .rst(1'b0), //active high
// .phoneme_speech_busy  (phoneme_speech_busy                 ),
// .phoneme_speech_finish(phoneme_speech_finish               ),
// .phoneme_sel         (),
// .start_phoneme_output (start_phoneme_output )
// );

speech_subsystem
speech_subsystem_inst(

    //////////// CLOCK //////////
    .CLOCK_50(Clock50Mhz),

    //////////// LED //////////
    .LEDR(),

    //////////// Audio //////////
    .AUD_ADCDAT(AUD_ADCDAT),
    .AUD_ADCLRCK(AUD_ADCLRCK),
    .AUD_BCLK(AUD_BCLK),
    .AUD_DACDAT(AUD_DACDAT),
    .AUD_DACLRCK(AUD_DACLRCK),
    .AUD_XCK(AUD_XCK),

    //////// PS2 //////////
    .phoneme_speech_busy(phoneme_speech_busy),  
	.phoneme_speech_finish(phoneme_speech_finish),
	.phoneme_sel(phoneme_sel),          
	.start_phoneme_output(start_phoneme_output)	
);

I2C_AV_Config 
I2C_Configure_Audio_Chip(	
//	Host Side
  .iCLK(Clock50Mhz),
  .iRST_N(1'b1),
//	I2C Side
  .I2C_SDAT(FPGA_I2C_SDAT), // I2C Data
  .I2C_SCLK(FPGA_I2C_SCLK) // I2C Clock
);


endmodule
`default_nettype wire