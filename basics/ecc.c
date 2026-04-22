// https://github.com/torvalds/linux/blob/master/lib/reed_solomon/reed_solomon.c


/**
    8,      // symsize: 8 bits per symbol
    0x11d,  // gfpoly: x^8 + x^4 + x^3 + x^2 + 1
    0,      // fcr: first consecutive root
    1,      // prim: primitive element
    32,     // nroots: 32 parity symbols
  */

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#define PRINT_BITS (7)

void print_binary(unsigned int n) {
    for (int i = PRINT_BITS; i >= 0; i--) {
        int bit = (n >> i) & 1;
        printf("%d", bit);
        if (i % 8 == 0 && i != 0) printf(" ");
    }
    printf("\n");
}

struct simple_rs_codec {
	int		mm;
	int		nn;
	uint16_t	*alpha_to;
	uint16_t	*index_of;
	uint16_t	*genpoly;
	int		nroots;
	int		fcr;
	int		prim;
	int		iprim;
	int		gfpoly;
};

// https://github.com/torvalds/linux/blob/master/include/linux/rslib.h
int my_rs_modnn(struct simple_rs_codec rs, int x)
{
    while ( (x >= rs.nn)) {
        x -= rs.nn;
        x = (x >> rs.mm) + (x & rs.nn);
    }

    return x;
}


int main()
{
    // Configuration
    int gfpoly = 0x11d; // example poly
    int symsize = 8;    // symsize = 8, means GF(2^8)
    int prim = 2;       // primitive element
    int fcr = 0;        // first root of RS code generator
    int nroots = 32;    // Consider error correction capability and overhead

    struct simple_rs_codec my_rs = {0};
    my_rs.mm = symsize;
    my_rs.nn = (1 << symsize) - 1;  // symbols per block
    my_rs.prim = prim;
    my_rs.gfpoly = gfpoly;


    int sr, iprim, root;
    
    my_rs.index_of = malloc(sizeof(int) * (my_rs.nn + 1));
    my_rs.alpha_to = malloc(sizeof(int) * (my_rs.nn + 1));
    my_rs.genpoly = malloc(sizeof(int) * (my_rs.nroots + 1));

    my_rs.index_of[0] = my_rs.nn;     /* log (0) = -inf */
    my_rs.alpha_to[my_rs.nn] = 0;     /* alpha**(-inf) = 0 */

    // Create log lookup table and antilog lookup table
    sr = 1;
    for (int i = 0; i < my_rs.nn; i++) {
        my_rs.index_of[sr] = i;
        my_rs.alpha_to[i] = sr;
        sr <<= 1;
        if (sr & (1 << symsize))
            sr ^= gfpoly;
        sr &= my_rs.nn;
    }

    if (sr != my_rs.alpha_to[0]) {
        free(my_rs.index_of);
        free(my_rs.alpha_to);
        return -1;
    }

    // Find the multiplicative inverse
    for (iprim = 1; (iprim % prim) != 0; iprim += my_rs.nn);
    my_rs.iprim = iprim / prim;

    my_rs.genpoly[0] = 1;
    for (int i = 0, root = fcr * prim; i < nroots; i++, root += prim) {
        my_rs.genpoly[i + 1] = 1;
        for (int j = 1; j > 0; j--) {
            if (my_rs.genpoly[j] != 0) {
                my_rs.genpoly[j] = my_rs.genpoly[j - 1] ^ my_rs.alpha_to[my_rs_modnn(my_rs, my_rs.index_of[my_rs.genpoly[j]] + root)];
            } else {
                my_rs.genpoly[j] = my_rs.genpoly[j - 1];
            }
        }
        my_rs.genpoly[0] = my_rs.alpha_to[my_rs_modnn(my_rs, my_rs.index_of[my_rs.genpoly[0]] + root)];
    }
    // Convert rs->genpoly[] to index form for quicker encoding
    for (int i = 0; i < nroots; i++) {
        my_rs.genpoly[i] = my_rs.index_of[my_rs.genpoly[i]];
    }
    
    printf("index_of =\n");
    for (int j = 0; j < (my_rs.nn + 1); j++) {
        printf("[%d] =\t", j);
        print_binary(my_rs.index_of[j]);
    }
    printf("\n");

    printf("alpha_to =\n");
    for (int j = 0; j < (my_rs.nn + 1); j++) {
        printf("[%d] =\t", j);
        print_binary(my_rs.alpha_to[j]);
    }
    printf("\n");


}
