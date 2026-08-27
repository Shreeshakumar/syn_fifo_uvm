`include "fifo_pkg.sv"
`include "fifo_if.sv"
`include "../design/fifo_design.sv"
`include "../design/ram_dp_ar_aw.sv"

module fifo_top();       
	import uvm_pkg::*;
	import fifo_pkg::*;
	
	bit clk;

	fifo_if INF(clk);
   
   	fifo_design DUV(.clk(clk),.rst(INF.rst),.wr_cs(INF.wr_cs),.rd_cs(INF.rd_cs),.wr_en(INF.wr_en),.rd_en(INF.rd_en),
		.data_in(INF.data_in),.data_out(INF.data_out),.full(INF.full),.empty(INF.empty));

	initial forever #5 clk=~clk;
	
 	initial
	begin
		uvm_config_db#(virtual fifo_if)::set(null,"*","fifo_if",INF);

	   	run_test();
	end
endmodule
