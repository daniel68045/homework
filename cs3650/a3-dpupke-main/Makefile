all: compare array-max

compare: compare.c compare-main.s
	gcc -g -fPIE compare.c compare-main.s -o compare -pie

array-max: array-max.s array-max-main.c
	gcc -g -fPIE array-max.s array-max-main.c -o array-max -pie

clean:
	rm -f compare array-max
	rm -f *.o

a3.zip: compare.s compare-main.s array-max.s array-max-main.c compare-main.c 
	zip $@ $?
