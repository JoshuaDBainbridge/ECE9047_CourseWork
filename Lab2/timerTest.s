.global _start

.data
timer_T: .word 500000000
timer_sT: .word 100000000

.text
_start:
@ get the addresses
ldr r4 , =0xff202000
ldr r5 , =0xff200000
ldr r6 , adr_T
ldr r7 , adr_sT
@ initialize the 5 s count
ldr r0 , [r6]
str r0 , [r4 , #8]
mov r1 , r0 , lsr #16
str r1 , [r6 , #12 ]
@ start the timer for continuous
@ counting ( 0b0110 )
mov r1 , #6
str r1 , [r4 , #4]
@ get the 1 s interval
ldr r1 , [r7]
@ initialize LED pattern
mov r8 , #0
str r8 , [r5]
@ main loop
main_loop:
@ get the current count
@ first write junk to counter
str r1 , [r4 , #16 ]
@ now get the low count
ldr r2 , [r4 , #16 ]
@ get the high count
ldr r3 , [r4 , #20 ]
@ combine them