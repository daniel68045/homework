.globl array_max

array_max:
    # Prologue
    push %rbp
    mov %rsp, %rbp
    push %rbx
    push %r12
    push %r13

    # Initialize n and array address
    mov %rdi, %r13       # move n to r13
    mov %rsi, %r12       # move items to r12

    # If n = 0, return 0
    test %r13, %r13
    jz .exit_zero        

    # Initialize max with the first element
    movq (%r12), %rbx    

    # Loop over all elements
.loop:
    cmpq (%r12), %rbx    # compare current element with max
    jge .no_update       # if current element <= max, skip the update
    movq (%r12), %rbx    # else, update max with the current element
.no_update:
    addq $8, %r12        # move to the next element
    dec %r13             # decrement n
    test %r13, %r13      # check if n is zero
    jnz .loop            # if not, continue the loop

.exit:
    mov %rbx, %rax       # return the max value
    pop %r13
    pop %r12
    pop %rbx
    leave
    ret

.exit_zero:
    xor %rax, %rax       # clear rax to 0
    jmp .exit            # jump to the exit code
