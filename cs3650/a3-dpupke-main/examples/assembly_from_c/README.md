# Calling Functions Implemented in Assembly from C

This example shows how to call a function implemented in assembly from a C
program. In the file [`foo.s`](foo.s) you can find an implementation of a
function that takes arguments and performs some computation on them (can you
guess what it is?). The file [`foo_main.c`](foo_main.c) implements a `main`
function which processes the command line arguments (or complains if there are
none) and calls the function `foo` implemented in [`foo.s`](foo.s).

To compile this program, use `gcc foo_main.c foo.s -o foo` (you might need to
pass the `--no-pie` option on a more recent Linux). This tells `gcc` to compile
both files separately and then combines them into a single executable so that
the correct implementation of `foo` in [`foo.s`](foo.s) is called

