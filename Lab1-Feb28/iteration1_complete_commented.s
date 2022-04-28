.global _start
_start:
	ldr r0 , ssd		@SEVEN SEGMENT DISPLAY
	mov r2, #0 			@TIMER COMPARE
	ldr r3, =0x124f80	@TIMER VALUE 
_loop:	
	mov r1, #0b0111111	@SEVEN SEGMENT --> 0 
	bl _write
	bl _pause
	mov r1, #0b0000110 @SEVEN SEGMENT --> 0 
	bl _write
	bl _pause
	mov r1, #0b0000110	@SEVEN SEGMENT --> 0 
	bl _write
	bl _pause
	mov r1, #0b1011011	@SEVEN SEGMENT --> 0 
	bl _write
	bl _pause
	mov r1, #0b1001111	@SEVEN SEGMENT --> 0 
	bl _write
	bl _pause
	mov r1, #0b1101101	@SEVEN SEGMENT --> 0 
	bl _write
	bl _pause
	mov r1, #0b1111111	@SEVEN SEGMENT --> 0 
	bl _write
	bl _pause
	ldr r1, =0b000011001001111	@SEVEN SEGMENT --> 0 
	bl _write
	bl _pause
	ldr r1, =0b101101100000110	@SEVEN SEGMENT --> 0 
	bl _write
	bl _pause
	ldr r1, =0b100111101100110	@SEVEN SEGMENT --> 0 
	bl _write
	bl _pause
	b _loop
_pause:
	add r2, #1  @Increment clock counter 
	cmp r2, r3  @Compare to clock limit 
	ble _pause 
	mov r2, #0 @reset clock counter 
	bx lr	
_write:
	str r1 , [r0]   @Display values
	bx lr		
ssd: .word 0xff200020

