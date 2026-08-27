class fifo_scrbd extends uvm_scoreboard;
    `uvm_component_utils(fifo_scrbd)

    uvm_tlm_analysis_fifo #(trans) inp_fifo;
    uvm_tlm_analysis_fifo #(trans) out_fifo;

    trans inp_packet;
    trans out_packet;
    trans ref_packet;

    function new(string name = "fifo_scrbd", uvm_component parent);
        super.new(name, parent);

        inp_fifo   = new("inp_fifo", this);
        out_fifo   = new("out_fifo", this);
        ref_packet = new("ref_packet");
        inp_packet = new("input_packet");
        out_packet = new("output_packet");
    endfunction

    task run_phase(uvm_phase phase);
        reg [`DATA_WIDTH-1:0] MEM [0:`RAM_DEPTH-1];
        reg [`ADDR_WIDTH-1:0] rd_p;
        reg [`ADDR_WIDTH-1:0] wr_p;
        reg [`ADDR_WIDTH:0] status_cnt; //this needs one extra bit to hold

        logic [`DATA_WIDTH-1:0] q[$]; // queue is used to handle the delay of data out
SSS
        super.run_phase(phase);

        forever begin
            inp_fifo.get(inp_packet);  
            out_fifo.get(out_packet);  

            ref_packet.copy(inp_packet);  
           
            if(inp_packet.reset) begin rd_p = 0;   wr_p = 0;  status_cnt = 0;   q.delete();  ref_packet.data_out = 0;  ref_packet.empty = 1;  ref_packet.full = 0;  end 
            else begin
                if (q.size() > 0) begin ref_packet.data_out = q.pop_front(); /* if no read data out hold its previous value */end
                ref_packet.empty = (status_cnt == 0);
                ref_packet.full  = (status_cnt == `RAM_DEPTH);
            end

            `uvm_info("SCOREBOARD REF", $sformatf("SCOREBOARD \n %s", ref_packet.sprint()), UVM_LOW)
            `uvm_info("SCOREBOARD DUT", $sformatf("SCOREBOARD \n %s", out_packet.sprint()), UVM_LOW)

            if (ref_packet.data_out === out_packet.data_out && ref_packet.empty === out_packet.empty && ref_packet.full === out_packet.full) 
                `uvm_info(get_type_name(), "\nnPASS\nn", UVM_LOW)
            else  `uvm_error(get_type_name(), "\nnFAIL\nn")

            if (!inp_packet.reset) 
            begin
                logic write = (inp_packet.wr_en && inp_packet.wr_cs && (status_cnt < `RAM_DEPTH));
                logic read  = (inp_packet.rd_en && inp_packet.rd_cs && (status_cnt > 0));

                if (write && read) begin MEM[wr_p] = inp_packet.data_in;  q.push_back(MEM[rd_p]);   wr_p++;  rd_p++; end
                else if (write) begin  MEM[wr_p] = inp_packet.data_in;  wr_p++;  status_cnt++;end
                else if (read) begin   q.push_back(MEM[rd_p]);   rd_p++;  status_cnt--; end
            end
        end
    endtask

endclass
