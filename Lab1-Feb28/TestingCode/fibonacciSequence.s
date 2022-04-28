.global _start
_start:
	mov r0, #0 
	mov r1, #1 
	@display r0 --> 0 
	@pause 1s 
	@display r1 --> 1 
	@pause 1s
_sequence: 
	add r0,r1
	@display r0 --> 1 3 8 21
	@pause 1s
	add r1,r0 
	@display r1 --> 2 5 13 34
	@pause 1s
 	cmp r1, #34
	bge _start
	b _sequence 

	