/**
 * Unit tests for your queue.
 *
 * This is a set of unit tests for testing our queue implementation. 
 * Feel free to add your own unit tests following the examples below.
 *
 * The testing framework is called munit: https://nemequ.github.io/munit/
 *
 * Our autograder will use a superset of the tests below. If your implementation
 * passes these, you have a good indication that the code works and will make
 * the autograder happy.
 */

#include <stdio.h>
#include <string.h>
#include <munit.h>

#include "queue.h"

/* Each munit test should have the prototype:
 * 
 * MunitResult test(const MunitParameter params[], void* data)
 */

// Create and destroy a queue
MunitResult test0(const MunitParameter params[], void* data) {
  queue_t *test0 = queue_new(30);

  munit_assert_uint(queue_size(test0), ==, 0);

  queue_delete(test0);

  return MUNIT_OK;
}

// Single item: empty, full
MunitResult test1(const MunitParameter params[], void *data) {

  queue_t* test1 = queue_new(1);
  munit_assert_true(queue_empty(test1));
  munit_assert_false(queue_full(test1));

  queue_enqueue(test1, 42);
  munit_assert_false(queue_empty(test1));
  munit_assert_true(queue_full(test1));

  munit_assert_long(queue_dequeue(test1), ==, 42);
  munit_assert_true(queue_empty(test1));
  munit_assert_false(queue_full(test1));

  queue_delete(test1);

  return MUNIT_OK;
}

// Single item: size
MunitResult test2(const MunitParameter params[], void *data) {
  queue_t* test2 = queue_new(1);

  munit_assert_uint(queue_size(test2), ==, 0);

  queue_enqueue(test2, 42);
  munit_assert_uint(queue_size(test2), ==, 1);

  munit_assert_long(queue_dequeue(test2), ==, 42);
  munit_assert_uint(queue_size(test2), ==, 0);

  queue_delete(test2);

  return MUNIT_OK;
}

// 10-element queue
MunitResult test3(const MunitParameter params[], void *data) {
  queue_t *test3 = queue_new(10);

  munit_assert_true(queue_empty(test3));

  queue_enqueue(test3, 1);
  queue_enqueue(test3, 2);
  queue_enqueue(test3, 3);
  queue_enqueue(test3, 4);
  queue_enqueue(test3, 5);

  munit_assert_uint(queue_size(test3), ==, 5);
  munit_assert_false(queue_empty(test3));
  munit_assert_false(queue_full(test3));

  queue_enqueue(test3, 6);
  queue_enqueue(test3, 7);
  queue_enqueue(test3, 8);
  queue_enqueue(test3, 9);
  queue_enqueue(test3, 10);

  munit_assert_uint(queue_size(test3), ==, 10);
  munit_assert_false(queue_empty(test3));
  munit_assert_true(queue_full(test3));

  munit_assert_long(queue_dequeue(test3), ==, 1);
  munit_assert_long(queue_dequeue(test3), ==, 2);
  munit_assert_long(queue_dequeue(test3), ==, 3);
  munit_assert_long(queue_dequeue(test3), ==, 4);
  munit_assert_long(queue_dequeue(test3), ==, 5);

  munit_assert_uint(queue_size(test3), ==, 5);
  munit_assert_false(queue_empty(test3));
  munit_assert_false(queue_full(test3));

  munit_assert_long(queue_dequeue(test3), ==, 6);
  munit_assert_long(queue_dequeue(test3), ==, 7);
  munit_assert_long(queue_dequeue(test3), ==, 8);
  munit_assert_long(queue_dequeue(test3), ==, 9);
  munit_assert_long(queue_dequeue(test3), ==, 10);

  munit_assert_true(queue_empty(test3));
  munit_assert_false(queue_full(test3));

  queue_delete(test3);

  return MUNIT_OK;
}

// 32-element queue
MunitResult test4(const MunitParameter params[], void *data) {
  queue_t *test4 = queue_new(32);

  for (int i = 0; i < 32; i++) {
    queue_enqueue(test4, 1);
    munit_assert_uint(queue_size(test4), ==, i + 1);
  }

  for (int i = 0; i < 32; i++) {
    munit_assert_long(queue_dequeue(test4), ==, 1);
    munit_assert_uint(queue_size(test4), ==, 31 - i);
  }

  queue_delete(test4);

  return MUNIT_OK;
}

// Multiple enqueues and dequeues, testing wraparound
MunitResult test5(const MunitParameter params[], void *data) {
  queue_t *test5 = queue_new(12);

  for (int i = 0; i < 8; i++) {
    queue_enqueue(test5, 1);
  }

  munit_assert_uint(queue_size(test5), ==, 8);

  for (int i = 0; i < 4; i++) {
    munit_assert_long(queue_dequeue(test5), ==, 1);
  }

  for (int i = 0; i < 8; i++) {
    queue_enqueue(test5, 2);
  }

  munit_assert_uint(queue_size(test5), ==, 12);

  for (int i = 0; i < 4; i++) {
    munit_assert_long(queue_dequeue(test5), ==, 1);
  }

  munit_assert_uint(queue_size(test5), ==, 8);

  for (int i = 0; i < 4; i++) {
    munit_assert_long(queue_dequeue(test5), ==, 2);
  }

  munit_assert_uint(queue_size(test5), ==, 4);

  for (int i = 0; i < 4; i++) {
    queue_enqueue(test5, 3);
  }

  munit_assert_uint(queue_size(test5), ==, 8);

  for (int i = 0; i < 4; i++) {
    munit_assert_long(queue_dequeue(test5), ==, 2);
  }

  munit_assert_uint(queue_size(test5), ==, 4);

  for (int i = 0; i < 4; i++) {
    munit_assert_long(queue_dequeue(test5), ==, 3);
  }

  munit_assert_uint(queue_size(test5), ==, 0);

  queue_delete(test5);

  return MUNIT_OK;
}


#define MUNIT_SIMPLE(name, test_func, params) \
  { \
    name, /* name */ \
    test_func, /* test */ \
    NULL, /* setup */ \
    NULL, /* tear_down */ \
    MUNIT_TEST_OPTION_NONE, /* options */ \
    params /* parameters */ \
  }

#define MUNIT_TESTS_END MUNIT_SIMPLE(NULL, NULL, NULL) 

MunitTest tests[] = {
  MUNIT_SIMPLE("/Create and destroy a queue", test0, NULL),
  MUNIT_SIMPLE("/Single item: empty, full", test1, NULL),
  MUNIT_SIMPLE("/Single item: size", test2, NULL), 
  MUNIT_SIMPLE("/10-element queue", test3, NULL),
  MUNIT_SIMPLE("/32-element queue", test4, NULL),
  MUNIT_SIMPLE("/Multiple en- and dequeues, wraparound", test5, NULL),
  MUNIT_TESTS_END
};

static const MunitSuite suite = {
  "/queue", /* name */
  tests, /* tests */
  NULL, /* suites */
  1, /* iterations */
  MUNIT_SUITE_OPTION_NONE /* options */
};


int main(int argc, char **argv) {
  return munit_suite_main(&suite, NULL, argc, argv);
}
