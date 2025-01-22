# Calling Functions Implemented in C

This example shows how to call a function implemented in a C file from
assembly. In the file [`foo.c`](foo.c) you can find an implementation of a
function that takes 3 arguments and performs some computation on them. The file
[`foo_main.s`](foo_main.s) implements a `main` function which calls function
`foo` implemented in `foo.c`.

To compile this program, use `gcc foo_main.s foo.c -o foo` (you might need to
pass the `--no-pie` option on a more recent Linux). This tells `gcc` to compile
both files separately and then combines them into a single executable so that
the correct implementation of `foo` in [`foo.c`](foo.c) is called

