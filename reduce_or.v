module reduce_or32(
    input  [31:0] in,
    output        out
);
    wire [15:0] s1;
    wire [7:0]  s2;
    wire [3:0]  s3;
    wire [1:0]  s4;
    genvar i;

    generate
        for (i=0;i<16;i=i+1) begin: L1
            or (s1[i], in[i], in[i+16]);
        end
        for (i=0;i<8;i=i+1) begin: L2
            or (s2[i], s1[i], s1[i+8]);
        end
        for (i=0;i<4;i=i+1) begin: L3
            or (s3[i], s2[i], s2[i+4]);
        end
    endgenerate

    or (s4[0], s3[0], s3[1]);
    or (s4[1], s3[2], s3[3]);
    or (out,   s4[0], s4[1]);

endmodule
