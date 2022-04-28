.global _start
_start:
	ldr r0 , ssd			@seven segment display address
	mov r1, #0				@display value 
	mov r2, #0				@fibonacci number 1 
	mov r3, #1				@fibonacci number 2
	mov r4, #10				@number of sequences 
	mov r5, #0				@timer count up value 
	ldr r6, =0x124f80		@timer value
	mov r7, #0				@save pc address
	mov r8, #0				@to be decoded value
	mov r9, #0				@decode value 100s 
	mov r10, #0				@decode value 10s
	mov r11, #0				@decode value 1s
	mov r12, #0				@DECODE VALUE
_opening: 
	sub r4, #2				@reduce number of sequence by 2 for display 0, 1
	orr r8, r2				@store Fibonacci numbe to be decoded 
	mov r7, pc				@save PC pointing to orr r8, r3
	add r7, #4
	b _hundreds				@begin to deocde Fibonacci numbers for display
	orr r8, r3
	mov r7, pc
	add r7, #4				@save PC pointing to _sequence	
	b _hundreds				@begin to deocde Fibonacci numbers for display
	b _sequence				@subroutine that completes remaining sequence 
_sequence:
	cmp r4, #0
	beq _start				@restart loop from 0 
	add r2,r3				@ Num1 = Num1 + Num2 
	@display r0 --> 1 2 5 13 34 	
	orr r8, r2				@store Fibonacci numbe to be decoded 
	add r4, #-1
	mov r7, pc
	add r7, #4
	b _hundreds
	add r3,r2 				@ Num2 = Num1 + Num2 
	@display r1 --> 1 3 8 21
	orr r8, r3				@store Fibonacci numbe to be decoded 
	add r4, #-1
	mov r7, pc
	add r7, #4
	b _hundreds
	@pause 1s
 	cmp r4, #0
	beq _start				@restart loop from 0 
	b _sequence 
_hundreds:
	mov r12,r9				@store 100s digit 
	cmp r8, #100
	blt _decodeHundred
	sub r8,#100				@subtract 100 from Fibonacci number
	add r9, #1				@increase 100s digit by 1 
	b _hundreds
_decodeHundred: 
	bl _decode				
	b _tens
_tens: 
	mov r12,r10				@store 10s digit
	cmp r8, #10
	blt _decodeTen
	sub r8,#10				@subtract 10 from Fibonacci number
	add r10, #1				@increase 10s digit by 1 
	b _tens
_decodeTen:
	bl _decode
	blt _ones
_ones: 
	mov r12,r11				@store 1s digit
	cmp r8, #1
	blt _decodeOne
	sub r8,#1				@subtract 1 from Fibonacci number
	add r11, #1				@increase 1s digit by 1
	b _ones
_decodeOne:
	bl _decode
	b _write
_decode:
	lsl r1, #8				@logical shift left by 8 digits 			
	cmp r12, #0 			@decoder compares digit to 0 to 9
	orreq r1, #0b0111111	@OR seven-seg value with 00000000	
	cmp r12, #1
	orreq r1, #0b0000110
	cmp r12, #2 
	orreq r1, #0b1011011
	cmp r12, #3 
	orreq r1, #0b1001111
	cmp r12, #4 
	orreq r1, #0b1100110
	cmp r12, #5 
	orreq r1, #0b1101101
	cmp r12, #6 
	orreq r1, #0b1111101
	cmp r12, #7 
	orreq r1, #0b0000111
	cmp r12, #8 
	orreq r1, #0b11111111
	cmp r12, #9 
	orreq r1, #0b1100111
	movls r12, #0
	bx lr					@return to spot 
_write:
	str r1 , [r0]
	b _pause
_pause:
	add r5, #1 			@counting to vaue to pause program
	cmp r5, r6
	ble _pause
	mov r1, #0			@rest digit holding values 
	mov r5, #0 
	mov r9, #0
	mov r10, #0
	mov r11, #0
	bx r7
ssd: .word 0xff200020