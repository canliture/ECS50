#include <stdlib.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
  char *garbage;
  unsigned int  quotient = 0,remainder=0,dividend = 43,divisor = 6;

  for (int i = 0; i < 32; i++)
  {
    if (divisor <= remainder)
    {
      quotient |= (1 << (31 - i));
      remainder = remainder - divisor;
    }
    remainder <<= 1;
    if ((i < 31)&&(dividend & 1<<(30-i)))
    {
        remainder |= 1;
    }
  }
  remainder >>= 1;

  printf("%u / %u = %u R %u\n", dividend, divisor, quotient, remainder);

  return 0;
}
