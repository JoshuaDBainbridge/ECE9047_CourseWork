.global _start
.data
timer_T: .word 500000000
timer_sT: .word 100000000

.text
_start:
	and r0, #0
	and r1, #0
	and r2, #0
	and r3, #0
	and r4, #0
	and r5, #0
	and r6, #0
	and r7, #0
	and r8, #0
	and r9, #0
	and r10, #0
	and r11, #0
	and r12, #0
      // get the addresses
    ldr r4 , =0xff202000
    ldr r5 , =0xff200000
    ldr r6 , adr_T
    ldr r7 , adr_sT
	ldr r0 , [r6]
    //initialize the 5 s count
    ldr r8, =0x00006500
	ldr r9,=0x00001dcd
    str r8 , [r4 , #8]
    str r9 , [r4 , #12 ]
    // start the timer for continuous
    // counting ( 0b0110 )
    mov r1 , #6
    str r1 , [r4 , #4]
    // get the 1 s interval
    ldr r1 , [r7]
    // initialize LED pattern
    mov r8 , #0
    str r8 , [r5]
// main loop
main_loop:
    // get the current count
    // first write junk to counter
    str r1 , [r4 , #16 ]
    // now get the low count
    ldr r2 , [r4 , #16 ]
    // get the high count
    ldr r3 , [r4 , #20 ]
    // combine them
    add r2 , r3 , lsl #16
    // check if current count has
    // passed 1 s
    cmp r2 , r0
    bhi main_loop
    // increment LED pattern
    lsl r8 , #1
    add r8 , #1
    str r8 , [r5]
    // check if we have passed 5 s
    // #63 is bit pattern 111111
    cmp r8 , #63
    // if not , subtract 1 s from interval
    // and loop back
    sublo r0 , r1
    blo main_loop
    // if we passed 5 s, reset interval
    ldr r0 , [r6]
    // blank LEDs
    mov r8 , #0
    str r8 , [r5]
    b main_loop
    adr_T: .word timer_T
    adr_sT: .word timer_sT