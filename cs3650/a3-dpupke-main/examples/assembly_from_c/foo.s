
.global foo  # the function needs to be global for foo_main to be able to use it

# long foo(long a, long b)
foo:
  enter $0, $0
  
  movq $1, %rax

loop:
  cmpq $0, %rsi
  jle loop_done

  imulq %rdi, %rax
  decq %rsi
  jmp loop

loop_done:
  leave
  ret
  
