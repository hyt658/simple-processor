# Arithmetic Logic Unit

## Summation / Subtraction

1. The design is implemented with a 32-bit CLA (carry-lookahead adder)

2. How CLA works:

    - Speeds up addition by avoiding ripple-carry delay

    - Compute per-bit `generate` $G_i = A_i \land B_i$ and `propagate` $P_i = A_i \oplus B_i$ in parallel

    - Carry: $C_{i+1} = G_i \lor (P_i \land C_i)$

    - Sum: $S_i = P_i \oplus C_i$

    - Carry is recursive, so $C_{i+1}$ can be expanded directly to depend on $C_0$ (the input $C_{in}$), enabling parallel computation of all carries before computing sums

    - Possible to group bits into blocks; for a block of 4 bits:
        $$
        P_{group} = P_3 P_2 P_1 P_0
        $$

        $$
        G_{group} = G_3 \lor (P_3 G_2) \lor (P_3 P_2 G_1) \lor (P_3 P_2 P_1 G_0)
        $$

    - A 4-bit CLA block works like a “super-bit”. Multiple blocks can be combined hierarchically and they are operated as same as 1-bit.

    - In this case, we built the 4-bit CLA block first. Then two of them are combined to create an 8-bit CLA, and finally four 8-bit CLAs are used to construct the complete 32-bit CLA.

3. For subtraction, the subtrahend is bitwise flipped and incremented by one to obtain its negation. The negated value is then added to the minuend to achieve subtraction.

4. Overflow detection is handled as follows:
    - For addition: $\text{overflow} = \lnot (A_{31} \oplus B_{31}) \land ( \text{Sum}_{31} \oplus A_{31} )$
    - For subtraction: $\text{overflow} = (A_{31} \oplus B_{31}) \land ( \text{Sum}_{31} \oplus A_{31} )$
    - The key idea is that overflow occurs only when the two operands have the same sign during addition, or different signs during subtraction. This is captured by the term $$A_{31} \oplus B_{31}$$. The second term, $$\text{Sum}_{31} \oplus A_{31}$$, then checks for overflow by comparing the sign of the result with the sign of the operands.