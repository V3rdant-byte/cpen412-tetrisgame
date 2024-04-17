module extend_bits(
	input R,
	input G,
	input B,
	output [7:0] R_byte,
	output [7:0] G_byte,
	output [7:0] B_byte);
	
	assign R_byte = R ? 8'hFF : 8'h00;
	assign G_byte = G ? 8'hFF : 8'h00;
	assign B_byte = B ? 8'hFF : 8'h00;
endmodule
	