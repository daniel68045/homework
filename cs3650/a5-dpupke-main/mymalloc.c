#define _DEFAULT_SOURCE
#define _BSD_SOURCE 
#include <assert.h>
#include <unistd.h>
#include <stddef.h>
#include <string.h>
#include <stdio.h>
#include "debug.h" // Provides debug_printf for debugging outputs

// Structure representing a memory block managed by the allocator
typedef struct block {
  size_t size;        // The size of the allocated memory block
  struct block *next; // Pointer to the next memory block in the list
  int free;           // Indicator if the block is free (1) or not (0)
} block_t;

#define BLOCK_SIZE sizeof(block_t) // Size of the block structure

// Head of the linked list to track memory blocks
static block_t *global_base = NULL;

/**
 * Searches for a free block of memory that fits the requested size.
 *
 * @param last A pointer to the last visited block
 * @param size The size of memory block to find
 * @return A pointer to a suitable free block or NULL if none are found
 */
static block_t *find_free_block(block_t **last, size_t size) {
  block_t *current = global_base;
  while (current && !(current->free && current->size >= size)) {
    *last = current;
    current = current->next;
  }
  return current;
}

/**
 * Extends the heap with a new block of requested size.
 *
 * @param last A pointer to the last block in the list
 * @param size The size of new memory block to extend
 * @return A pointer to the new block or NULL if the system call fails
 */
static block_t *extend_heap(block_t *last, size_t size) {
  block_t *block = sbrk(0);
  if (sbrk(BLOCK_SIZE + size) == (void *) -1) {
    return NULL; // sbrk failed to allocate space
  }
  if (last) {
    last->next = block;
  }
  
  block->size = size;
  block->next = NULL;
  block->free = 0;
  return block;
}

/**
 * Gets the block structure pointer from a given memory pointer.
 *
 * @param ptr The pointer to the memory block returned by malloc
 * @return A pointer to the beginning of the block structure
 */
static block_t *get_block_ptr(void *ptr) {
  return (block_t*)ptr - 1;
}

/**
 * Allocates a block of memory of the specified size.
 *
 * @param size The size of memory to allocate
 * @return A pointer to the allocated memory or NULL if no block can be allocated
 */
void *mymalloc(size_t size) {
  if (size == 0) {
    return NULL;
  }

  block_t *block;
  if (!global_base) {
    block = extend_heap(NULL, size);
    if (!block) {
      return NULL;
    }
    global_base = block;
  } else {
    block_t *last = global_base;
    block = find_free_block(&last, size);
    if (!block) {
      block = extend_heap(last, size);
      if (!block) {
        return NULL;
      }
    } else {
      block->free = 0;
    }
  }
  
  debug_printf("Malloc %zu bytes\n", size);
  return (block + 1);
}

/**
 * Allocates a zero-initialized block of memory for an array of elements.
 *
 * @param nmemb Number of elements to allocate
 * @param size Size of each element
 * @return A pointer to the allocated and zero-initialized memory or NULL if allocation fails
 */
void *mycalloc(size_t nmemb, size_t size) {
  size_t total_size = nmemb * size;
  void *ptr = mymalloc(total_size);
  if (!ptr) {
    return NULL;
  }
  memset(ptr, 0, total_size);
  debug_printf("Calloc %zu bytes\n", total_size);
  return ptr;
}

/**
 * Frees a block of memory previously allocated by mymalloc or mycalloc.
 *
 * @param ptr The pointer to the memory block to free
 */
void myfree(void *ptr) {
  if (!ptr) {
    return; // Do nothing if a NULL pointer is passed
  }
  
  block_t *block_ptr = get_block_ptr(ptr);
  assert(block_ptr->free == 0); // Ensure the block was not already freed
  block_ptr->free = 1;
  debug_printf("Freed %zu bytes\n", block_ptr->size);  
}
