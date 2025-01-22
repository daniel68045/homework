.global main

.text

main:
  enter $0, $0

  cmpl $2, %edi
  jl else
  movq 8(%rsi), %rdx
  jmp continue

else:
  movq $default_str, %rdx

continue:
  movq a, %rdi
  movq b, %rsi
  call foo

  movq $format, %rdi
  movq %rax, %rsi
  movb $0, %al
  call printf

  movq $0, %rax
  leave
  ret

.data

format: 
  .asciz "Result: %ld\n"

default_str:
  .asciz "13 characters"

a:
  .quad 10

b: 
  .quad 20
