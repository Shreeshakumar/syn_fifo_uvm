class fifo_test extends uvm_test;
	`uvm_component_utils(fifo_test)

 	fifo_env env_h;
 	fifo_cfg m_cfg;

 	function new(string name="fifo_test",uvm_component parent);
		super.new(name,parent);
 	endfunction

 	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		env_h=fifo_env::type_id::create("env_h",this);
		m_cfg=fifo_cfg::type_id::create("m_cfg");
 	
 		if(!uvm_config_db#(virtual fifo_if)::get(this,"","fifo_if",m_cfg.vif))
			`uvm_fatal(get_type_name,"Can't get the fifo_interface")
  
  		m_cfg.input_agent_is_active=UVM_ACTIVE;
  		m_cfg.output_agent_is_active=UVM_PASSIVE;

  		uvm_config_db#(fifo_cfg)::set(this,"*","fifo_cfg",m_cfg);
	endfunction

 	function void end_of_elaboration_phase(uvm_phase phase);
  		super.end_of_elaboration_phase(phase);
   		uvm_top.print_topology();
	endfunction
	
	virtual task reset_duv();
	begin
		rst_seq ss;
		ss=rst_seq::type_id::create("ss");
		ss.start(env_h.inp_agt_h.seqr_h);
	end
	endtask
endclass 

class test0 extends fifo_test;
	`uvm_component_utils(test0)
	rst_seq s1;
 	function new(string name="test0",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); reset_duv(); s1=rst_seq::type_id::create("s1"); repeat(4) s1.start(env_h.inp_agt_h.seqr_h); #10; phase.drop_objection(this);
	endtask
endclass

class test1 extends fifo_test;
	`uvm_component_utils(test1)
	seq_only_wr s1;
 	function new(string name="test1",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); reset_duv(); s1=seq_only_wr::type_id::create("s1"); repeat(4) s1.start(env_h.inp_agt_h.seqr_h); #10; phase.drop_objection(this);
	endtask
endclass

class test2 extends fifo_test;
	`uvm_component_utils(test2)
	seq_only_rd s1;
 	function new(string name="test2",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); reset_duv(); s1=seq_only_rd::type_id::create("s1"); repeat(4) s1.start(env_h.inp_agt_h.seqr_h); #10; phase.drop_objection(this);
	endtask
endclass

class test3 extends fifo_test;
	`uvm_component_utils(test3) 
	seq_wr_rd s1;
 	function new(string name="test3",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); reset_duv(); s1=seq_wr_rd::type_id::create("s1"); repeat(4) s1.start(env_h.inp_agt_h.seqr_h); #10; phase.drop_objection(this);
	endtask
endclass
