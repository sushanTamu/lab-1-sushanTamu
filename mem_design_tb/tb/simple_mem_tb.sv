///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// File name   : simple_mem_tb.sv
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////

module mem_test;
    //parameters
    parameter ADDR_WID   = 5 ;
    parameter DATA_WIDTH  = 8 ;

    // signal definition
    reg                              clk;
    reg                              rst_n;
    reg                              rd_en;
    reg                              wr_en;
    reg  [ADDR_WID - 1 : 0]          addr;
    reg  [DATA_WIDTH - 1 : 0]        data_in;
    wire [DATA_WIDTH - 1 : 0]        data_out;
	

  //simple mem instantiation
  simple_mem mem_inst (
                      .clk           (clk),
                      .rst_n         (rst_n),
                      .wr_en         (wr_en),
                      .rd_en         (rd_en),
                      .addr          (addr),
                      .data_in       (data_in),
                      .data_out      (data_out)
	            );

  always #10 clk = ~clk;

  initial
  begin : mem_t

    clk <= 0 ; // Initialising the clock to have the value 0 at 0ns timestamp
    rst_n <= 1;
    #1 rst_n <= 0;
    #1 rst_n <= 1;
    $display ("Asynch Memory Reset");

    #8;  //Adding this delay to make sure that the clock, addr and data_in toggles at the same timestamp everytime so that the data is being fetched at every pos-edge of clk

    begin 
           // Running a for loop for reading the values from address 0-31 and making sure all of them having data_out
	   // as 0 because it is in reset state
	   for(addr='b0; addr<'b11111; addr=addr+1)
           	mem_read(addr);  // Executes Read Operation
    end

           	mem_read('b11111);  // Executes Read Operation


//TO DO : Run a loop to write iter value on the address -- write 5 on memory[5] 
    begin 
           // Running a for loop for writing the values to all the address 0-31 
	   // Writing 0 on memory[0]
	   // Writing 1 on memory[1]
	   // Writing 2 on memory[2] and so on
	   // Writing 31 on memory[31]
           for(data_in='b0; data_in<='b11111; data_in=data_in+1)
           	mem_write(data_in,data_in);  // Executes Write operation
    end



//TO DO : Add your own stimulus to catch the bug in the design. Also display the current vs expected value

// The bug in the design is whenever we write multiple write operations because the write function in the design is not 
// aligned with the specifications given and behaving wrongly.
// Due to which whenever we fetch the value after multiple write operations with the help of read the data_out
// is giving the false data_out value.
           	
		mem_write(5'b0,8'b01110010); // First write operation
           	mem_write(5'b0,8'b01110111); // Second write operation
           	mem_read(5'b0);              // Reading the final value in the memory after 2 write operations

    		$display ("Expected Value after reading the data_out is 77 ");
    		$display ("Current Value after reading the data_out is %h", data_out);

  #1400$finish; 
  end

  task mem_write (input logic [4:0] addr_in, input logic [7:0] data_wr);
// TO DO : complete the task <insert display statement for debug>
    begin 
	   wr_en    = 1'b1;
	   rd_en    = 1'b0;
           addr     = addr_in;
           data_in  = data_wr;
    end
    #5$display ("Current address = %h, Value of data_in in case of write operation is = %h",addr,data_in);
    #15;
	endtask


  task mem_read (input logic [4:0] addr_in, output logic [7:0] data_rd);
// TO DO : complete the task <insert display statement for debug>
    begin 
	   wr_en    = 1'b0;
	   rd_en    = 1'b1;
           addr     = addr_in;
	   data_rd  = data_out;
    end
    #5$display ("Current Address = %h, Value of data_out in case of read operation is = %h",addr, data_out);
    #15;
	endtask
		
endmodule
