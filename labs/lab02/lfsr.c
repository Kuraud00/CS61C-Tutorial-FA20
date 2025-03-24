#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

uint16_t get_bit(uint16_t reg,uint16_t n){
    return (reg>>n) & 1;
}

void lfsr_calculate(uint16_t *reg) {
    /* YOUR CODE HERE */
    uint16_t i = (get_bit(*reg,0)^get_bit(*reg,2)^get_bit(*reg,3)^get_bit(*reg,5))<<15;
    *reg = (*reg>>1);
    *reg |= i;
}

