module simple_dual_one_clock_neg #(
    parameter ADDRL = 14
) (clk,ena,enb,wea,addra,addrb,dia,dob);

    input clk,ena,enb,wea;
    input [ADDRL - 1:0] addra,addrb;
    input [7:0] dia;
    output [7:0] dob;

    reg [7:0] ram [(1 << ADDRL) - 1:0];
    // Default the ram to all be 1
    initial begin
        for (int i = 0; i < (1 << ADDRL); i = i + 1)
            ram[i] = 1;
    end
    reg [7:0] doa, dob;
    
    always @(negedge clk) begin
        if (ena) begin
            if (wea)
                ram[addra] <= dia;
        end
    end

    always @(negedge clk) begin
        if (enb)
            dob <= ram[addrb];
    end

endmodule