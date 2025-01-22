#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <unistd.h>
#include <assert.h>
#include <pthread.h>

// Custom printf for tty (terminal) output
#define tty_printf(...) (isatty(1) && isatty(0) ? printf(__VA_ARGS__) : 0)

// Logging macros for debugging and error reporting
#ifndef SHUSH
#define log(...) (fprintf(stderr, __VA_ARGS__))
#else 
#define log(...)
#endif

// Function prototype for the auxiliary merge sort function
void merge_sort_aux(long nums[], int from, int to, long target[]);

// Global variable for the number of threads to be used in sorting
int thread_count = 1;

// Function to compute time difference in seconds
double time_in_secs(const struct timeval *begin, const struct timeval *end) {
    long s = end->tv_sec - begin->tv_sec;
    long ms = end->tv_usec - begin->tv_usec;
    return s + ms * 1e-6;
}

// Function to print an array of long integers
void print_long_array(const long *array, int count) {
    for (int i = 0; i < count; ++i) {
        printf("%ld\n", array[i]);
    }
}

// Function to merge two sorted halves of an array
void merge(long nums[], int from, int mid, int to, long target[]) {
    int left = from, right = mid;
    int i = from;
    // Merge two sorted subarrays in a sorted manner
    for (; i < to && left < mid && right < to; i++) {
        if (nums[left] <= nums[right]) {
            target[i] = nums[left++];
        } else {
            target[i] = nums[right++];
        }
    }
    // Copy remaining elements
    if (left < mid) {
        memmove(&target[i], &nums[left], (mid - left) * sizeof(long));
    } else if (right < to) {
        memmove(&target[i], &nums[right], (to - right) * sizeof(long));
    }
}

// Structure to pass multiple arguments to the pthread function
typedef struct {
    long *nums;
    long *target;
    int from;
    int to;
} ThreadArgs;

// Pthread function to perform merge sort in a separate thread
void *thread_merge_sort(void *arg) {
    ThreadArgs *args = (ThreadArgs *)arg;
    merge_sort_aux(args->target, args->from, args->to, args->nums);
    return NULL;
}

// Recursive auxiliary function for merge sort
void merge_sort_aux(long nums[], int from, int to, long target[]) {
    if (to - from <= 1) {
        return; // Base case: single element is always sorted
    }

    int mid = (from + to) / 2;

    // Create threads if the segment size is big enough
    if (to - from > 2 && thread_count > 1) {
        pthread_t threads[thread_count];
        ThreadArgs args[thread_count];

        // Divide the array into parts and sort each part in a separate thread
        for (int i = 0; i < thread_count; ++i) {
            args[i].nums = nums;
            args[i].target = target;
            args[i].from = from + i * (to - from) / thread_count;
            args[i].to = from + (i + 1) * (to - from) / thread_count;
            pthread_create(&threads[i], NULL, thread_merge_sort, &args[i]);
        }

        // Wait for all threads to complete
        for (int i = 0; i < thread_count; ++i) {
            pthread_join(threads[i], NULL);
        }
    } else {
        // Sort the left and right halves recursively
        merge_sort_aux(target, from, mid, nums);
        merge_sort_aux(target, mid, to, nums);
    }

    // Merge the sorted halves
    merge(nums, from, mid, to, target);
}

// Main function to sort an array using merge sort
long *merge_sort(long nums[], int count) {
    long *result = calloc(count, sizeof(long));
    assert(result != NULL);

    memmove(result, nums, count * sizeof(long));
    merge_sort_aux(nums, 0, count, result);

    return result;
}

// Function to allocate and load the array from input
int allocate_load_array(int argc, char **argv, long **array) {
    assert(argc > 1);
    int count = atoi(argv[1]);

    *array = calloc(count, sizeof(long));
    assert(*array != NULL);

    long element;
    tty_printf("Enter %d elements, separated by whitespace\n", count);
    for (int i = 0; i < count && scanf("%ld", &element) != EOF; i++) {
        (*array)[i] = element;
    }

    return count;
}

// Main function to execute the merge sort algorithm
int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <n>\n", argv[0]);
        return 1;
    }

    struct timeval begin, end;

    // Read the number of threads from environment variable
    if (getenv("MSORT_THREADS") != NULL)
        thread_count = atoi(getenv("MSORT_THREADS"));

    log("Running with %d thread(s). Reading input.\n", thread_count);

    // Load the array
    gettimeofday(&begin, 0);
    long *array = NULL;
    int count = allocate_load_array(argc, argv, &array);
    gettimeofday(&end, 0);
    log("Array read in %f seconds, beginning sort.\n", time_in_secs(&begin, &end));

    // Perform merge sort
    gettimeofday(&begin, 0);
    long *result = merge_sort(array, count);
    gettimeofday(&end, 0);
    log("Sorting completed in %f seconds.\n", time_in_secs(&begin, &end));

    // Print the sorted array
    gettimeofday(&begin, 0);
    print_long_array(result, count);
    gettimeofday(&end, 0);
    log("Array printed in %f seconds.\n", time_in_secs(&begin, &end));

    free(array);
    free(result);

    return 0;
}
