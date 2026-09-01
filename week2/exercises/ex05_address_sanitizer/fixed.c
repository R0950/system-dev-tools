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

    /*
     * Read the value while the allocated memory is still valid.
     */
    int value = numbers[2];

    free(numbers);

    /*
     * Avoid keeping a dangling pointer.
     */
    numbers = NULL;

    printf("Saved value = %d\n", value);

    return 0;
}
