class trans extends uvm_sequence_item;
	`uvm_object_utils(trans)

	rand bit rst;
	rand bit wr_cs;
	rand bit rd_cs;
	rand bit wr_en;
	rand bit rd_en;
	rand bit [`DATA_WIDTH-1 :0]data_in;
		 bit [`DATA_WIDTH-1 :0]data_out;
		 bit full;
		 bit empty;
		 
	constraint reset { soft rst=='d0;}
 
 	function new(string name="seq_item");
		super.new(name);
 	endfunction

 	virtual function void do_copy(uvm_object rhs);
		trans rhs_;
		if(!$cast(rhs_,rhs))
			`uvm_fatal("do_copy","cast of the rhs object failed");
		super.do_copy(rhs);
	
		this.rst=rhs_.rst;
		this.wr_cs=rhs_.wr_cs;
		this.rd_cs=rhs_.rd_cs;
		this.wr_en=rhs_.wr_en;
		this.rd_en=rhs_.rd_en;
		this.data_in=rhs_.data_in;
	endfunction

 	virtual function bit do_compare(uvm_object rhs,uvm_comparer comparer);
		trans rhs_;
		if(!$cast(rhs_,rhs))
		begin
		  	`uvm_fatal("do_compare","cast of the rhs object failed")
		   	return 0;
		end 
		return	super.do_compare(rhs,comparer)&& data_out==rhs_.data_out&& full==rhs_.full&& empty==rhs_.empty;	
	endfunction

	virtual function void do_print(uvm_printer printer);
		super.do_print(printer);
		printer.print_field("rst",this.rst,1,UVM_DEC);
		printer.print_field("wr_cs",this.wr_cs,1,UVM_DEC);
		printer.print_field("rd_cs",this.rd_cs,1,UVM_DEC);
		printer.print_field("wr_en",this.wr_en,1,UVM_DEC);
		printer.print_field("rd_en",this.rd_en,1,UVM_DEC);
		printer.print_field("data_in",this.data_in,`DATA_WIDTH,UVM_DEC);
		printer.print_field("data_out",this.data_out,`DATA_WIDTH,UVM_DEC);
		printer.print_field("full",this.full,1,UVM_DEC);
		printer.print_field("empty",this.empty,1,UVM_DEC);
	endfunction
	
	virtual function void inn_print(trans t);
		$write("    rst=%0b  wr_cs=%0b  rd_cs=%0b  wr_en=%0b  rd_en=%0b  data_in=%02h(%03d)  ",
         			t.rst,   t.wr_cs, 	 t.rd_cs,   t.wr_en,   t.rd_en,   t.data_in,t.data_in);
	endfunction
	
	virtual function void out_print(trans t);
		$display("  data_out=%0h(%0d)  full=%0b  empty=%0b  ",
         			t.data_out,t.data_out,  t.full,   t.empty);
	endfunction
	
	virtual function void print_both(trans r, trans o);
		$write("||  data_out=%02h/%02h(%03d/%03d)  full=%0b/%0b  empty=%0b/%0b  ",
         			r.data_out,o.data_out,r.data_out,o.data_out,  r.full,o.full,   r.empty,o.empty);
	endfunction
endclass 

