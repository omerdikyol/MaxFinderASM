`timescale 1ns / 1ns

module tb;
parameter SIZE = 14, DEPTH = 1024;

reg clk;
initial begin
  clk = 1;
  forever
	  #5 clk = ~clk;
end

reg rst;
initial begin
  rst = 1;
  repeat (10) @(posedge clk);
  rst <= #1 0;
  repeat (600) @(posedge clk);
  // uncomment the following line to display the content at address 50 in console
  // $display("Content of address 50 is %d.", inst_blram.memory[50]);
  $finish;
end

wire wrEn;
wire [SIZE-1:0] addr_toRAM;
wire [31:0] data_toRAM, data_fromRAM;

VerySimpleCPU inst_VerySimpleCPU(
  .clk(clk),
  .rst(rst),
  .wrEn(wrEn),
  .data_fromRAM(data_fromRAM),
  .addr_toRAM(addr_toRAM),
  .data_toRAM(data_toRAM)
);

blram #(SIZE, DEPTH) inst_blram(
  .clk(clk),
  .rst(rst),
  .i_we(wrEn),
  .i_addr(addr_toRAM),
  .i_ram_data_in(data_toRAM),
  .o_ram_data_out(data_fromRAM)
);

endmodule

module blram(clk, rst, i_we, i_addr, i_ram_data_in, o_ram_data_out);

parameter SIZE = 10, DEPTH = 1024;

input clk;
input rst;
input i_we;
input [SIZE-1:0] i_addr;
input [31:0] i_ram_data_in;
output reg [31:0] o_ram_data_out;

reg [31:0] memory[0:DEPTH-1];

always @(posedge clk) begin
  o_ram_data_out <= #1 memory[i_addr[SIZE-1:0]];
  if (i_we)
		memory[i_addr[SIZE-1:0]] <= #1 i_ram_data_in;
end 

initial begin
//////////////////////////
// write BRAM content here
		inst_blram.memory[0] = 32'h901901f5;
		inst_blram.memory[1] = 32'h809601f4;
		inst_blram.memory[2] = 32'h80194064;
		inst_blram.memory[3] = 32'ha0198065;
		inst_blram.memory[4] = 32'h10194001;
		inst_blram.memory[5] = 32'h701941fe;
		inst_blram.memory[6] = 32'hc0188065;
		inst_blram.memory[7] = 32'h10190001;
		inst_blram.memory[8] = 32'h8019c066;
		inst_blram.memory[9] = 32'h60198258;
		inst_blram.memory[10] = 32'hc0184066;
		inst_blram.memory[11] = 32'hd018c002;
		inst_blram.memory[12] = 32'h80960067;
		inst_blram.memory[13] = 32'hd018c002;
		inst_blram.memory[97] = 32'hc;
		inst_blram.memory[98] = 32'he;
		inst_blram.memory[99] = 32'h0;
		inst_blram.memory[100] = 32'h0;
		inst_blram.memory[101] = 32'h0;
		inst_blram.memory[102] = 32'h0;
		inst_blram.memory[103] = 32'h0;
		inst_blram.memory[500] = 32'h7;
		inst_blram.memory[501] = 32'h2;
		inst_blram.memory[502] = 32'h4;
		inst_blram.memory[503] = 32'h8;
		inst_blram.memory[504] = 32'h6;
		inst_blram.memory[505] = 32'h5;
		inst_blram.memory[506] = 32'hb;
		inst_blram.memory[507] = 32'h4;
		inst_blram.memory[508] = 32'h5;
		inst_blram.memory[509] = 32'h6;
		inst_blram.memory[510] = 32'h2;
		inst_blram.memory[511] = 32'h10;
		inst_blram.memory[600] = 32'h0;
//////////////////////////
end

endmodule
