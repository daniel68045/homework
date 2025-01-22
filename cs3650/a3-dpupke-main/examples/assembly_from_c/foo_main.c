#include <stdio.h>
#include <stdlib.h>

long foo(long a, long b); /* We need to tell the C compiler the signature of our function */

int main(int argc, char **argv) {
  if (argc < 3) {
    printf("I need 2 numeric arguments\n");
    return 1;
  }

  long n = atol(argv[1]);
  long x = atol(argv[2]);

  printf("Result: %ld\n", foo(n, x));
  return 0;
}
