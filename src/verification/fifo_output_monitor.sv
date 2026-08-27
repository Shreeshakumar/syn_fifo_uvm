class fifo_output_monitor extends uvm_monitor;
	`uvm_component_utils(fifo_output_monitor)
	uvm_analysis_port#(trans) out_monitor_port;

	virtual fifo_if.OUT_MON vif;
	fifo_cfg m_cfg;
	trans rd_data;

 	function new(string name="fifo_output_monitor",uvm_component parent);
		super.new(name,parent);
 	endfunction

 	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
   		if(!uvm_config_db#(fifo_cfg)::get(this,"","fifo_cfg",m_cfg))
			`uvm_fatal(get_type_name(),"Output_Monitor Getting Failed")
		out_monitor_port=new("out_monitor_port",this);
 	endfunction

 	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
 		vif=m_cfg.vif;
 	endfunction

 	task run_phase(uvm_phase phase);
	forever 
	begin	 
		rd_data=trans::type_id::create("rd_data");
	    collect_data();
	   	`uvm_info("OUTPUT_MONITOR","OUTPUT MONITOR\n",UVM_LOW)
	   	`uvm_info("OUTPUT_MONITOR",$sformatf("OUTPUT MONITOR\n%s",rd_data.sprint()),UVM_MEDIUM)
	end
 	endtask

	  
	virtual task collect_data();
     begin
		@(vif.out_mon_cb);
	 		rd_data.rst			= vif.out_mon_cb.rst;
	 		rd_data.wr_cs		= vif.out_mon_cb.wr_cs;
	 		rd_data.rd_cs		= vif.out_mon_cb.rd_cs;
	  		rd_data.rd_en		= vif.out_mon_cb.rd_en;
	  		rd_data.wr_en 		= vif.out_mon_cb.wr_en;
	  		rd_data.rd_en 		= vif.out_mon_cb.rd_en;
	  		rd_data.data_in 	= vif.out_mon_cb.data_in;

	  		rd_data.data_out	= vif.out_mon_cb.data_out; 
  			rd_data.full 		= vif.out_mon_cb.full;
  			rd_data.empty       = vif.out_mon_cb.empty;
	  	out_monitor_port.write(rd_data);
	end
 	endtask
endclass
