//
// module data_array #(
//     parameter s_index = 3,
//     parameter s_offset = 5
// )
// (
//     clk,
//     read,
//     write_en,
//     rindex,
//     windex,
//     datain,
//     dataout
// );
//
// localparam s_mask   = 2**s_offset;
// localparam s_line   = 8*s_mask;
// localparam num_sets = 2**s_index;
//
// input clk;
// input read;
// input [s_mask-1:0] write_en;
// input [s_index-1:0] rindex;
// input [s_index-1:0] windex;
// input [s_line-1:0] datain;
// output logic [s_line-1:0] dataout;
//
// logic [s_line-1:0] data [num_sets-1:0] /* synthesis ramstyle = "logic" */;
// logic [s_line-1:0] _dataout;
// assign dataout = _dataout;
//
// /* Initialize array */
// initial
// begin
//     for (int i = 0; i < num_sets; i++)
//     begin
//         data[i] = 1'b0;
//     end
// end
//
// always_ff @(posedge clk)
// begin
//     if (read)
//         for (int i = 0; i < s_mask; i++)
//             _dataout[8*i +: 8] <= (write_en[i] & (rindex == windex)) ? datain[8*i +: 8] : data[rindex][8*i +: 8];
//
//     for (int i = 0; i < s_mask; i++)
//     begin
// 		data[windex][8*i +: 8] <= write_en[i] ? datain[8*i +: 8] : data[windex][8*i +: 8];
//     end
// end
//
// endmodule : data_array

module data_array #(
    parameter s_index = 3,
    parameter s_offset = 5,
    parameter s_mask   = 2**s_offset, // Keep default
    parameter s_line   = 8*s_mask     // Keep default
)
(
    input clk,
	input read,
    input [s_mask-1:0] write_en,
    input [s_index-1:0] index,
    input [s_line-1:0] datain,
    output logic [s_line-1:0] dataout
);

localparam num_sets = 2**s_index;

logic [s_line-1:0] data [num_sets-1:0] /* synthesis ramstyle = "logic" */ = '{default: '0};
logic [s_line-1:0] _dataout;
assign dataout = data[index];

always_ff @(posedge clk)
begin
	 if (read)
		  _dataout <= data[index];

    for (int i = 0; i < s_mask; i++)
    begin
		data[index][8*i +: 8] <= write_en[i] ? datain[8*i +: 8] : data[index][8*i +: 8];
    end
end

endmodule : data_array
