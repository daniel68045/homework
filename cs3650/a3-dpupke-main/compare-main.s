.section .text
.global main

str2long:
    push %rbp
    mov %rsp, %rbp

      xor %rax, %rax                  
    xor %rcx, %rcx                  
    movb $10, %cl                   

    movq $1, %rdx                    
    cmpb $'-', (%rdi)
    jne .not_negative
    neg %rdx                       
    inc %rdi                       
.not_negative:

.loop_character:
    movzbq (%rdi), %r8
    testb %r8b, %r8b
    je .done

    subb $'0', %r8b
    imulq %rcx, %rax
    addq %r8, %rax
    inc %rdi
    jmp .loop_character
.done:
    imulq %rdx, %rax

    leave
    ret

main:
    push %rbp
    mov %rsp, %rbp

    cmpq $3, %rdi
    jne .error

    movq 8(%rsi), %rdi   
    call str2long
    movq %rax, %r12      

    movq 16(%rsi), %rdi  
    call str2long
    movq %rax, %r13      

    movq %r12, %rdi
    movq %r13, %rsi
    call compare
    cmpq $-1, %rax
    je .less

    cmpq $0, %rax
    je .equal

    leaq msg_greater(%rip), %rdi
    call printf
    xor %rax, %rax
    jmp .exit

.less:
    leaq msg_less(%rip), %rdi
    call printf
    xor %rax, %rax
    jmp .exit

.equal:
    leaq msg_equal(%rip), %rdi
    call printf
    xor %rax, %rax
    jmp .exit

.error:
    leaq msg_error(%rip), %rdi
    call printf
    movq $1, %rax

.exit:
    leave
    ret

.section .data
msg_less:
    .asciz "less\n"
msg_equal:
    .asciz "equal\n"
msg_greater:
    .asciz "greater\n"
msg_error:
    .asciz "Two arguments required.\n"
