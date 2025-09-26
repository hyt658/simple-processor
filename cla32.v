module cla32(num1, num2, cin, sum, cout);
	input  [31:0] num1, num2;
	input         cin;
	output [31:0] sum;
	output        cout;

	wire pgroup0, ggroup0;
	wire pgroup1, ggroup1;
	wire pgroup2, ggroup2;
	wire pgroup3, ggroup3;

	wire carry8, carry16, carry24;
    wire t10, t20, t21;
    wire t30, t31, t32;
    wire t40, t41, t42, t43;

	cla8 cla0 (
		.num1(num1[7:0]), .num2(num2[7:0]), .cin(cin),
		.sum(sum[7:0]), .pgroup(pgroup0), .ggroup(ggroup0), .cout()
	);

    and (t10,  pgroup0, cin);
	or  (carry8, ggroup0, t10);

	cla8 cla1 (
		.num1(num1[15:8]), .num2(num2[15:8]), .cin(carry8),
		.sum(sum[15:8]), .pgroup(pgroup1), .ggroup(ggroup1), .cout()
	);

    and (t20, pgroup1, pgroup0, cin);
    and (t21, pgroup1, ggroup0);
	or  (carry16, ggroup1, t20, t21);

	cla8 cla2 (
		.num1(num1[23:16]), .num2(num2[23:16]), .cin(carry16),
		.sum(sum[23:16]), .pgroup(pgroup2), .ggroup(ggroup2), .cout()
	);

    and (t30, pgroup2, pgroup1, pgroup0, cin);
	and (t31, pgroup2, pgroup1, ggroup0);
    and (t32, pgroup2, ggroup1);
	or  (carry24, ggroup2, t30, t31, t32);

	cla8 cla3 (
		.num1(num1[31:24]), .num2(num2[31:24]), .cin(carry24),
		.sum(sum[31:24]), .pgroup(pgroup3), .ggroup(ggroup3), .cout()
	);

	and (t40, pgroup3, pgroup2, pgroup1, pgroup0, cin);
    and (t41, pgroup3, pgroup2, pgroup1, ggroup0);
    and (t42, pgroup3, pgroup2, ggroup1);
    and (t43, pgroup3, ggroup2);
	or  (cout, ggroup3, t40, t41, t42, t43);
endmodule
