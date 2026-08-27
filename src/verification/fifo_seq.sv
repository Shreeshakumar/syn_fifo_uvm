class seq extends uvm_sequence #(trans);
	`uvm_object_utils(seq) 

 	function new(string name="seq");
		super.new(name);
 	endfunction

	task body();
   		req=trans::type_id::create("req");
		begin
		 	start_item(req);
		   	assert(req.randomize() with {rst==1'd0; });
		   	finish_item(req);
		end
 	endtask
endclass

class rst_seq extends uvm_sequence #(trans);
	`uvm_object_utils(rst_seq) 
 	function new(string name="rst_seq"); super.new(name); endfunction
 	task body();
     	begin req=trans::type_id::create("req");	start_item(req);	assert(req.randomize() with {rst==1'd1;												});	finish_item(req);	end	
	endtask
endclass

class seq_only_wr extends uvm_sequence #(trans);
	`uvm_object_utils(seq_only_wr) 
 	function new(string name="seq_only_wr"); super.new(name); endfunction
 	task body();
		begin req=trans::type_id::create("req"); start_item(req); assert(req.randomize() with {rst==1'd0;wr_cs==1'd1;wr_en==1'd1;rd_cs==1'd0;rd_en==1'd0;}); finish_item(req); end
 	endtask
endclass

class seq_only_rd extends uvm_sequence #(trans);
	`uvm_object_utils(seq_only_rd) 
 	function new(string name="seq_only_rd"); super.new(name); endfunction
 	task body();
		begin req=trans::type_id::create("req"); start_item(req); assert(req.randomize() with {rst==1'd0;wr_cs==1'd0;wr_en==1'd0;rd_cs==1'd1;rd_en==1'd1;}); finish_item(req); end
 	endtask
endclass

class seq_wr_rd extends uvm_sequence #(trans);
	`uvm_object_utils(seq_wr_rd) 
 	function new(string name="seq_wr_rd"); super.new(name); endfunction
 	task body();
		begin req=trans::type_id::create("req"); start_item(req); assert(req.randomize() with {rst==1'd0;wr_cs==1'd1;wr_en==1'd1;rd_cs==1'd1;rd_en==1'd1;}); finish_item(req); end
 	endtask
endclass
