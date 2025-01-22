CC=gcc
CFLAGS=-g -std=gnu11 -Werror

msort_OBJS=$(patsubst %.c,%.o,$(filter-out tmsort.c,$(wildcard *.c)))
tmsort_OBJS=$(patsubst %.c,%.o,$(filter-out msort.c,$(wildcard *.c)))

COUNT=1000

ifeq ($(shell uname), Darwin)
	LEAKTEST ?= leaks --atExit --
else
	LEAKTEST ?= valgrind --leak-check=full
endif

.PHONY: all valgrind clean test

all: msort tmsort

valgrind: valgrind-msort valgrind-tmsort

valgrind-%: %
	$(eval TMP := $(shell mktemp -d))
	./numbers 1 $(COUNT) > $(TMP)/input.txt
	cd $(TMP) && $(LEAKTEST) $(CURDIR)/$* $(COUNT) < input.txt > sorted.txt || (ret=$$?; rm -f input.txt sorted.txt && exit $$ret)

clean: 
	rm -rf *.o
	rm -f msort tmsort

diff-%: msort tmsort
	$(eval TMP := $(shell mktemp -d))
	$(info == Running diff test in $(TMP) ==)
	./numbers 1 $* > $(TMP)/input.txt
	@cd $(TMP) && $(CURDIR)/msort $* < input.txt > msort.txt || (ret=$$?; rm -f input.txt msort.txt tmsort.txt && exit $$ret)
	@cd $(TMP) && $(CURDIR)/tmsort $* < input.txt > tmsort.txt || (ret=$$?; rm -f input.txt msort.txt tmsort.txt && exit $$ret)

	@echo
	@echo "== Files msort.txt and tmsort.txt should be the same. =="

	@cd $(TMP) && diff -sq msort.txt tmsort.txt
	@rm -rf $(TMP)

msort: $(msort_OBJS)
	$(CC) $(CFLAGS) -o $@ $^

tmsort: $(tmsort_OBJS)
	$(CC) -pthread $(CFLAGS) -o $@ $^ -lm

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $^

