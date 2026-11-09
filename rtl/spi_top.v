module spi_top #(
    parameter CLK_DIV = 4
)(

    input wire clk,
    input wire rst,
    input wire start,

    input wire [7:0] master_tx_data,
    input wire [7:0] slave_tx_data,

    output wire [7:0] master_rx_data,
    output wire [7:0] slave_rx_data,

    output wire busy,
    output wire done,
    output wire slave_rx_valid,

    output wire sclk,
    output wire mosi,
    output wire miso,
    output wire cs_n

);


    spi_master #(
        .CLK_DIV(CLK_DIV)
    ) MASTER (

        .clk(clk),
        .rst(rst),
        .start(start),

        .tx_data(master_tx_data),
        .miso(miso),

        .mosi(mosi),
        .sclk(sclk),
        .cs_n(cs_n),

        .rx_data(master_rx_data),
        .busy(busy),
        .done(done)

    );


    
    spi_slave SLAVE (

        .clk(clk),
        .rst(rst),

        .sclk(sclk),
        .cs_n(cs_n),
        .mosi(mosi),

        .tx_data(slave_tx_data),

        .miso(miso),

        .rx_data(slave_rx_data),
        .rx_valid(slave_rx_valid)

    );


endmodule
