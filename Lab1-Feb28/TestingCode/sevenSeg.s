.global _start
_start:
	ldr r0 , ssd
_display:
	mov r1, #0b0111111 @display 0
@	mov r1, #0b0000110 @display 1
@	mov r1, #0b1011011 @display 2
@	mov r1, #0b1001111 @display 3
@	mov r1, #0b1100110 @display 4
@	mov r1, #0b1101101 @display 5
@	mov r1, #0b1111101 @display 6
@	mov r1, #0b0000111 @display 7
@	mov r1, #0b11111111 @display 8
@	mov r1, #0b1100111 @display 9

_write:
	str r1 , [r0]

ssd: .word 0xff200020D