[bits 32]
[extern main]

  call main                        ; Calls main() in kernel.c independently of the functions above it

jmp $
