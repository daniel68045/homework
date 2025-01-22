CC=gcc
MUNIT_DIR=../munit
CFLAGS=-g -std=c11 -I$(MUNIT_DIR)

ifeq ($(shell uname), Darwin)
	LEAKTEST ?= leaks --atExit --
else
	LEAKTEST ?= valgrind --leak-check=full
endif

.PHONY: all valgrind clean test

all: queue_test

test: queue_test
	./queue_test

valgrind: queue_test
	$(LEAKTEST) ./queue_test --no-fork

clean: 
	rm -rf *.o
	rm queue_test

queue_test: queue.o queue_test.o $(MUNIT_DIR)/munit.o
	$(CC) $(CFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $^

