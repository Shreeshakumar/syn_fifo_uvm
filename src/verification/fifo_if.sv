interface fifo_if(input bit clk);

logic rst;
logic wr_cs;
logic rd_cs;
logic wr_en;
logic rd_en;
logic [`DATA_WIDTH-1 :0]data_in;
logic [`DATA_WIDTH-1 :0]data_out;
logic full;
logic empty;

clocking inp_drv_cb @(negedge clk);
	default input #1 output #1;
	output rst;
	output wr_cs, rd_cs, wr_en, rd_en;
	output data_in;
endclocking

clocking inp_mon_cb @(posedge clk);
	default input #0 output #0;
	input rst;
	input wr_cs, rd_cs, wr_en, rd_en;
	input data_in;
endclocking

clocking out_mon_cb @(posedge clk);
	default input #0 output #0;
	input rst;
	input wr_cs, rd_cs, wr_en, rd_en;
	input data_in, data_out;
	input full, empty;
endclocking 

modport INP_DRV(clocking inp_drv_cb);
modport INP_MON(clocking inp_mon_cb);
modport OUT_MON(clocking out_mon_cb);

endinterface
