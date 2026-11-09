
module spi_master #(
    parameter CLK_DIV = 4
)(
    input wire clk,
    input wire rst,
    input wire start,

    input wire [7:0] tx_data,
    input wire miso,

    output reg mosi,
    output reg sclk,
    output reg cs_n,

    output reg [7:0] rx_data,
    output reg busy,
    output reg done
);


    localparam IDLE     = 1'b0;
    localparam TRANSFER = 1'b1;

    reg state;

    reg [7:0] tx_shift;
    reg [7:0] rx_shift;

    reg [3:0] bit_count;
    reg [31:0] clk_count;

    always @(posedge clk or posedge rst) begin

        if (rst) begin

            state     <= IDLE;
            tx_shift  <= 8'b0;
            rx_shift  <= 8'b0;

            bit_count <= 0;
            clk_count <= 0;

            mosi      <= 0;
            sclk      <= 0;
            cs_n      <= 1;

            rx_data   <= 0;
            busy      <= 0;
            done      <= 0;

        end

        else begin

            done <= 0;

            case(state)

                IDLE: begin

                    sclk <= 0;
                    cs_n <= 1;
                    busy <= 0;

                    if(start) begin

                        state     <= TRANSFER;

                        tx_shift  <= tx_data;
                        rx_shift  <= 0;

                        bit_count <= 0;
                        clk_count <= 0;

                        mosi      <= tx_data[7];
                        cs_n      <= 0;
                        busy      <= 1;

                    end

                end

                TRANSFER: begin

                    if(clk_count == CLK_DIV - 1) begin

                        clk_count <= 0;

                        
                        if(sclk == 0) begin

                            sclk <= 1;

                            rx_shift <= {
                                rx_shift[6:0], miso
                            };

                        end

                        
                        else begin

                            sclk <= 0;

                            if(bit_count == 7) begin

                                rx_data <= rx_shift;

                                cs_n <= 1;
                                busy <= 0;
                                done <= 1;

                                state <= IDLE;

                            end

                            else begin

                                bit_count <= bit_count + 1'b1;

                                tx_shift <= {
                                    tx_shift[6:0], 1'b0
                                };

                                mosi <= tx_shift[6];

                            end

                        end

                    end

                    else begin

                        clk_count <= clk_count + 1'b1;

                    end

                end

            endcase

        end

    end

endmodule