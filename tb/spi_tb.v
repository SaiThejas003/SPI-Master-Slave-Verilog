`timescale 1ns/1ps

module spi_tb;

    

    reg clk;
    reg rst;
    reg start;

    reg [7:0] master_tx_data;
    reg [7:0] slave_tx_data;


    

    wire [7:0] master_rx_data;
    wire [7:0] slave_rx_data;

    wire busy;
    wire done;
    wire slave_rx_valid;

    wire sclk;
    wire mosi;
    wire miso;
    wire cs_n;


    

    reg slave_valid_seen;


    

    spi_top #(
        .CLK_DIV(4)
    ) DUT (

        .clk(clk),
        .rst(rst),
        .start(start),

        .master_tx_data(master_tx_data),
        .slave_tx_data(slave_tx_data),

        .master_rx_data(master_rx_data),
        .slave_rx_data(slave_rx_data),

        .busy(busy),
        .done(done),
        .slave_rx_valid(slave_rx_valid),

        .sclk(sclk),
        .mosi(mosi),
        .miso(miso),
        .cs_n(cs_n)

    );


    

    always #5 clk = ~clk;


    

    always @(posedge clk) begin

        if (rst)
            slave_valid_seen <= 0;

        else if (slave_rx_valid)
            slave_valid_seen <= 1;

    end


    

    initial begin

        

        clk = 0;
        rst = 1;
        start = 0;

        master_tx_data = 8'hA5;
        slave_tx_data  = 8'h3C;

        slave_valid_seen = 0;


        

        $dumpfile("simulation/spi.vcd");
        $dumpvars(0, spi_tb);


        

        #20;
        rst = 0;

        $display("--------------------------------");
        $display("SPI MASTER-SLAVE TEST STARTED");
        $display("--------------------------------");

        $display("Master TX = %h", master_tx_data);
        $display("Slave TX  = %h", slave_tx_data);


        
        @(negedge clk);
        start = 1;

        @(negedge clk);
        start = 0;


        

        wait(done == 1);

        #1;


        

        $display("--------------------------------");
        $display("SPI COMMUNICATION RESULTS");
        $display("--------------------------------");

        $display("Master RX = %h", master_rx_data);
        $display("Slave RX  = %h", slave_rx_data);


        

        if (master_rx_data === 8'h3C)
            $display("MASTER RX: PASS");
        else
            $display("MASTER RX: FAIL");


        

        if (slave_rx_data === 8'hA5)
            $display("SLAVE RX: PASS");
        else
            $display("SLAVE RX: FAIL");


        

        if (slave_valid_seen)
            $display("SLAVE VALID: PASS");
        else
            $display("SLAVE VALID: FAIL");


        

        if ((master_rx_data === 8'h3C) &&
            (slave_rx_data === 8'hA5) &&
            (slave_valid_seen == 1'b1))

            $display("OVERALL RESULT: PASS");

        else

            $display("OVERALL RESULT: FAIL");


        $display("--------------------------------");

        #20;
        $finish;

    end


    

    initial begin

        #10000;

        $display("ERROR: TESTBENCH TIMEOUT");
        $finish;

    end

endmodule
