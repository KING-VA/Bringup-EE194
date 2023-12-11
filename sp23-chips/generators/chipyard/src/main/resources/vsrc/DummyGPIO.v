
module DummyInIOCell (
	input   pad,
	output  i,
	input   ie,
	inout  	pad_cell,
	input   i_cell,
	output 	ie_cell);

	assign i = i_cell;
	assign pad_cell = pad;
	assign ie_cell = ie;

endmodule

module DummyOutIOCell (
	output  pad,
	input   o,
	input   oe,
	inout   pad_cell,
	output  o_cell,
	output  oe_cell);

	assign o_cell = o;
//	assign pad_cell = pad;
	assign pad = pad_cell;
	assign oe_cell = oe;

endmodule



module DummyGPIOCell (
	inout   pad,
	input   o,
	output  i,
	input   oe,
	input   ie,
	inout   pad_cell,
	input   i_cell,
	output  o_cell,
	output  oe_cell,
	output  ie_cell);

	assign i = i_cell;
	assign o_cell = o;
	assign pad_cell = pad;
	assign oe_cell = oe;
	assign ie_cell = ie;

endmodule
