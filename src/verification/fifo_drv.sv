class fifo_driver extends uvm_driver#(trans);
	`uvm_component_utils(fifo_driver)

	virtual fifo_if.INP_DRV vif;
	fifo_cfg m_cfg;
	
 	function new(string name="fifo_driver",uvm_component parent);
		super.new(name,parent);
 	endfunction

 	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
   		
   		if(!uvm_config_db#(fifo_cfg)::get(this,"","fifo_cfg",m_cfg))
			`uvm_fatal(get_type_name(),"Input_Driver Getting Failed")
 	endfunction

 	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
 		vif=m_cfg.vif;
 	endfunction

 	task run_phase(uvm_phase phase);
		forever
		begin
		   	seq_item_port.get_next_item(req);
		   	drive(req);
		   	seq_item_port.item_done();
		end
 	endtask

 	task drive(trans data2duv);
		begin
        	@(vif.inp_drv_cb);
        	`uvm_info("INPUT_DRIVER","Input Driver\n",UVM_LOW)
			`uvm_info("INPUT_DRIVER",$sformatf("Input Driver\n%s",data2duv.sprint()),UVM_MEDIUM)
	    	vif.inp_drv_cb.rst  	<= data2duv.rst;
	    	vif.inp_drv_cb.wr_cs	<= data2duv.wr_cs;
	    	vif.inp_drv_cb.rd_cs  	<= data2duv.rd_cs;
	    	vif.inp_drv_cb.wr_en  	<= data2duv.wr_en;
            vif.inp_drv_cb.rd_en   	<= data2duv.rd_en;
	    	vif.inp_drv_cb.data_in	<= data2duv.data_in;
	    end
 	endtask
endclass
