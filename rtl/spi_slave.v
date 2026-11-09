module spi_slave(

    input wire clk,
    input wire rst,

    input wire sclk,
    input wire cs_n,
    input wire mosi,

    input wire [7:0] tx_data,

    output reg miso,

    output reg [7:0] rx_data,
    output reg rx_valid

);



    reg [7:0] tx_shift;
    reg [7:0] rx_shift;

    reg [3:0] bit_count;

    reg sclk_d;
    reg cs_n_d;



    always @(posedge clk or posedge rst) begin

        if (rst) begin

            tx_shift <= 8'b0;
            rx_shift <= 8'b0;

            bit_count <= 0;

            sclk_d <= 0;
            cs_n_d <= 1;

            miso <= 1;

            rx_data <= 0;
            rx_valid <= 0;

        end

        else begin

            

            sclk_d <= sclk;
            cs_n_d <= cs_n;

            

            rx_valid <= 0;


            

            if (cs_n) begin

                miso <= 1;

            end


            

            else if (cs_n_d && !cs_n) begin

                tx_shift <= tx_data;
                rx_shift <= 0;

                bit_count <= 0;

                miso <= tx_data[7];

            end



            else if (!sclk_d && sclk) begin

                rx_shift <= {
                    rx_shift[6:0], mosi
                };

                if (bit_count == 7) begin

                    rx_data <= {
                        rx_shift[6:0], mosi
                    };

                    rx_valid <= 1;

                end

                else begin

                    bit_count <= bit_count + 1'b1;

                end

            end


            

            else if (sclk_d && !sclk) begin

                if (bit_count < 7) begin

                    tx_shift <= {
                        tx_shift[6:0], 1'b0
                    };

                    miso <= tx_shift[6];

                end

            end

        end

    end
endmodule
