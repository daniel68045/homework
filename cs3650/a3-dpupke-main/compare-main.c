#include <stdio.h>
#include <stdlib.h>  // For the function atol()

extern long compare(long, long);

int main(int argc, char *argv[]) {
    // Check if the number of arguments is not 3 (program name + 2 numbers)
    if(argc != 3) {
        printf("Two arguments required.\n");
        return 1;
    }

    long num1 = atol(argv[1]);
    long num2 = atol(argv[2]);

    long result = compare(num1, num2);

    if(result == -1)
        printf("less\n");
    else if(result == 0)
        printf("equal\n");
    else if(result == 1)
        printf("greater\n");

    return 0;
}
