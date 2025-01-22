CC=gcc
MUNIT_DIR=../munit
CFLAGS=-g -std=c11 -I$(MUNIT_DIR)

ifeq ($(shell uname), Darwin)
	LEAKTEST ?= leaks --atExit --
else
	LEAKTEST ?= valgrind --leak-check=full
endif

.PHONY: all valgrind clean test

all: vect_test

test: vect_test
	./vect_test

valgrind: vect_test
	$(LEAKTEST) ./vect_test --no-fork

clean: 
	rm -rf *.o
	rm vect_test

vect_test: vect.o vect_test.o $(MUNIT_DIR)/munit.o
	$(CC) $(CFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $^

