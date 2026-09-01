#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    int *numbers = malloc(4 * sizeof(int));

    if (numbers == NULL) {
        fprintf(stderr, "malloc failed\n");
        return 1;
    }

    numbers[0] = 10;
    numbers[1] = 20;
    numbers[2] = 30;
    numbers[3] = 40;

    printf("Before free: numbers[2] = %d\n", numbers[2]);

    free(numbers);

    /*
     * BUG:
     * numbers points to memory that has already been freed.
     */
    printf("After free: numbers[2] = %d\n", numbers[2]);

    return 0;
}
