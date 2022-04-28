.global _start
_start:
    mov r0, #0
    mov r1, #1
    mov r2, #0
_fib:
    cmp r0, r1
    blt _lessThan
_greaterThan:
    add r1, r0
    mov r2, r1
    b _fib
_lessThan:
    add r0, r1
     mov r2, r0
    b _fib