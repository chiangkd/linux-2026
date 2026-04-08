#include <stdint.h>
#include <stdio.h>

// Ref: https://github.com/torvalds/linux/blob/master/Documentation/staging/crc32.rst

/**
 *      for (i = 0; i < input_bits; i++) {
 *              remainder ^= next_input_bit() << 31;
 *              multiple = (remainder & 0x80000000) ? CRCPOLY : 0;
 *              remainder = (remainder << 1) ^ multiple;
 *      }
 */

// 4-bit implementation
int main()
{
    // fake input
    int input[] = {1, 1, 0, 1};
    uint8_t remainder = 0; // 4-bit register
    uint8_t CRCPOLY = 0x3; // 0011  (x^4+x+1, ignore the MSB)

    for (int i = 0; i < 4; i++) {
        // 1. directly move the input to the "decision bit" (Bit 3)
        remainder ^= (input[i] << 3); 

        // 2. check msb is 1 (Bit 3)
        if (remainder & 0x8) {
            // 3. shift and do XOR
            remainder = (remainder << 1) ^ CRCPOLY;
        } else {
            // 3. shift
            remainder = (remainder << 1);
        }
        // keep 4-bit (mask it)
        remainder &= 0xF; 
    }

    printf("crc = 0x%x\n", remainder);

    return 0;
}