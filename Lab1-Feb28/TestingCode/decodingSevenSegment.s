.global _start
_start:
	ldr r0 , ssd
	mov r1, #0
	mov r2, #0
	mov r3, #0
	mov r4, #0
	mov r5, #0
	mov r6, #0
	mov r7, #0
	mov r8, #111
_hundreds:
	cmp r8, #100
	blt _decodeHundred
	sub r8,#100
	add r6, #1
	b _hundreds
_decodeHundred: 
	bl _decode
	blt _tens
_tens: 
	cmp r8, #10
	blt _decodeTen
	sub r8,#10
	add r6, #1
	b _tens
_decodeTen:
	bl _decode
	blt _ones
_ones: 
	cmp r8, #1
	blt _decodeOne
	sub r8,#1
	add r6, #1
	b _ones
_decodeOne:
	bl _decode
	blt _write
_decode:
	lsl r1, #8
	cmp r6, #0 
	orreq r1, #0b0111111
	cmp r6, #1
	orreq r1, #0b0000110
	cmp r6, #2 
	orreq r1, #0b1011011
	cmp r6, #3 
	orreq r1, #0b1001111
	cmp r6, #4 
	orreq r1, #0b1100110
	cmp r6, #5 
	orreq r1, #0b1101101
	cmp r6, #6 
	orreq r1, #0b1111101
	cmp r6, #7 
	orreq r1, #0b0000111
	cmp r6, #8 
	orreq r1, #0b11111111
	cmp r6, #9 
	orreq r1, #0b1100111
	movls r6, #0
	bx lr
_write:
	str r1 , [r0]
	@bx lr

ssd: .word 0xff200020