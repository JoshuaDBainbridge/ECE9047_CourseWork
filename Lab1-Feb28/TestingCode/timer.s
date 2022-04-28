.global _start
_start:
	mov r0, #0 
	mov r1, #0 
	mov r2, #0 
	ldr r3, =0x61a80
_count: 
	add r0, #5 
	bl _pause
	b _count
_pause:
	add r2, #1 
	cmp r2, r3
	ble _pause 
	mov r2, #0 
	bx lr