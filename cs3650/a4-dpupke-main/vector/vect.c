/**
 * Vector implementation.
 *
 * - Implement each of the functions to create a working growable array (vector).
 * - Do not change any of the structs
 * - When submitting, You should not have any 'printf' statements in your vector 
 *   functions.
 *
 * IMPORTANT: The initial capacity and the vector's growth factor should be 
 * expressed in terms of the configuration constants in vect.h
 */
#define _POSIX_C_SOURCE 200809L

#include <assert.h>
#include <stdlib.h>
#include <string.h>
#include "vect.h"

/** Main data structure for the vector. */
struct vect {
  char **data;             /* Array containing the actual data. */
  unsigned int size;      /* Number of items currently in the vector. */
  unsigned int capacity;  /* Maximum number of items the vector can hold before growing. */
};

/** Construct a new empty vector. */
vect_t *vect_new() {
  vect_t *v = malloc(sizeof(vect_t));
  if (!v) return NULL;

  v->size = 0;
  v->capacity = VECT_INITIAL_CAPACITY;
  v->data = malloc(v->capacity * sizeof(char *));
  if (!v->data) {
    free(v);
    return NULL;
  }
  return v;
}

/** Delete the vector, freeing all memory it occupies. */
void vect_delete(vect_t *v) {
  for (unsigned int i = 0; i < v->size; i++) {
    free(v->data[i]);
  }
  free(v->data);
  free(v);
}

/** Get the element at the given index. */
const char *vect_get(vect_t *v, unsigned int idx) {
  return v->data[idx];
}

/** Get a copy of the element at the given index. The caller is responsible
 *  for freeing the memory occupied by the copy. */
char *vect_get_copy(vect_t *v, unsigned int idx) {
  return strdup(v->data[idx]);
}

/** Set the element at the given index. */
void vect_set(vect_t *v, unsigned int idx, const char *elt) {
  free(v->data[idx]);  // Free existing string
  v->data[idx] = strdup(elt);  // Copy new string
}

/** Resize the vector if needed. */
static int vect_resize(vect_t *v, unsigned int new_capacity) {
  char **new_data = realloc(v->data, new_capacity * sizeof(char *));
  if (!new_data) return -1;
  v->data = new_data;
  v->capacity = new_capacity;
  return 0;
}

/** Add an element to the back of the vector. */
void vect_add(vect_t *v, const char *elt) {
  if (v->size == v->capacity) {
    unsigned int new_capacity = v->capacity * VECT_GROWTH_FACTOR;
    if (vect_resize(v, new_capacity) != 0) return;  // Return on failure to resize
  }
  v->data[v->size++] = strdup(elt);
}

/** Remove the last element from the vector. */
void vect_remove_last(vect_t *v) {
  if (v->size == 0) return;
  free(v->data[--v->size]);
}

/** The number of items currently in the vector. */
unsigned int vect_size(vect_t *v) {
  return v->size;
}

/** The maximum number of items the vector can hold before it has to grow. */
unsigned int vect_current_capacity(vect_t *v) {
  return v->capacity;
}
