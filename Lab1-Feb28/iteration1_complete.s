.global _start
_start:
	ldr r0 , ssd
	mov r2, #0 
	@ldr r3, =0x61a80
	ldr r3, =0x124f80
_loop:	
	mov r1, #0b0111111
	bl _write
	bl _pause
	mov r1, #0b0000110
	bl _write
	bl _pause
	mov r1, #0b0000110
	bl _write
	bl _pause
	mov r1, #0b1011011
	bl _write
	bl _pause
	mov r1, #0b1001111
	bl _write
	bl _pause
	mov r1, #0b1101101
	bl _write
	bl _pause
	mov r1, #0b1111111
	bl _write
	bl _pause
	ldr r1, =0b000011001001111
	bl _write
	bl _pause
	ldr r1, =0b101101100000110
	bl _write
	bl _pause
	ldr r1, =0b100111101100110
	bl _write
	bl _pause
	b _loop
_pause:
	add r2, #1 
	cmp r2, r3
	ble _pause 
	mov r2, #0 
	bx lr	
_write:
	str r1 , [r0]
	bx lr		
ssd: .word 0xff200020

