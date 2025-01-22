
#include <string.h>

/**
 * Silly function. 
 *
 * Performs: (a + strlen(str)) * b.
 */
long foo(long a, long b, char *str) {
  return (a + strlen(str)) * b;
}

