module alu(
	data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt,
	data_result, isNotEqual, isLessThan, overflow
);
    input  [31:0] data_operandA, data_operandB;
    input  [4:0]  ctrl_ALUopcode, ctrl_shiftamt;
    output [31:0] data_result;
    output        isNotEqual, isLessThan, overflow;

    // 1. Identify the operation
    wire op_n0, op_n1, op_n2, op_n3, op_n4;

    not (op_n0, ctrl_ALUopcode[0]);
    not (op_n1, ctrl_ALUopcode[1]);
    not (op_n2, ctrl_ALUopcode[2]);
    not (op_n3, ctrl_ALUopcode[3]);
    not (op_n4, ctrl_ALUopcode[4]);

    wire op_add, op_sub;
    and (op_add, op_n4, op_n3, op_n2, op_n1, op_n0);
    and (op_sub, op_n4, op_n3, op_n2, op_n1, ctrl_ALUopcode[0]);

    // 2. Negate B if performing subtraction
    wire [31:0] not_B;
    genvar i;

    generate
        for (i=0; i<32; i=i+1) begin: gen_not_B
            not (not_B[i], data_operandB[i]);
        end
    endgenerate

    wire [31:0] sel_B;
    generate
        for (i=0; i<32; i=i+1) begin: gen_bsel
            assign sel_B[i] = op_sub ? not_B[i] : data_operandB[i];
        end
    endgenerate

    // 3. Use CLA to perform sumation/subtraction
    // If subtraction, we need to add 1 to the negated B (using op_sub as cin)
    cla32 u_addsub (
        .num1(data_operandA), .num2(sel_B), .cin(op_sub),
        .sum(data_result), .cout()
    );

    // 4. Check if we have overflow
    // overflow_add = ~(A31^B31) & (Sum31^A31)
    // overflow_sub = (A31^B31) & (Sum31^A31)
    wire tadd0, not_tadd0, tadd1, tsub0, tsub1;
    wire overflow_add, overflow_sub;

    xor (tadd0, data_operandA[31], data_operandB[31]);
    xor (tadd1, data_result[31], data_operandA[31]);
    not (not_tadd0, tadd0);

    and (overflow_add, not_tadd0, tadd1);
    and (overflow_sub, tadd0, tadd1);
    assign overflow = op_add ? overflow_add : overflow_sub;

    // Avoiding Z/X for non-implemented operations
    assign isNotEqual = 1'b0;
    assign isLessThan = 1'b0;
endmodule
