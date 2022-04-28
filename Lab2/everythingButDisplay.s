.section .vectors, "ax"
	B     _start             // reset vector
	B     SERVICE_UND        // undefined instruction vector
	B     SERVICE_SVC        // software interrrupt vector
	B     SERVICE_ABT_INST   // aborted prefetch vector
	B     SERVICE_ABT_DATA   // aborted data vector
	.word 0                  // unused vector
	B     SERVICE_IRQ        // IRQ interrupt vector
	B     SERVICE_FIQ        // FIQ interrupt vector

.global _start
.data
timer_T: .word 500000000
timer_sT: .word 100000000
countMax: .word 15
currentCount: .word 0 
directon: .word 0 
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
	
	/*Set up stack pointers for IRQ and SVC processor modes*/
	MOV    R1, #0b11010010         // interrupts masked, MODE = IRQ
	MSR    CPSR_c, R1              // change to IRQ mode
	LDR    SP, =0xFFFFFFFF - 3     // set IRQ stack to A9 onchip memory
	/*Change to SVC (supervisor) mode with interrupts disabled*/
	MOV    R1, #0b11010011         // interrupts masked, MODE = SVC
	MSR    CPSR, R1                // change to supervisor mode
	LDR    SP, =0x3FFFFFFF - 3     // set SVC stack to top of DDR3 memory

	BL     CONFIG_GIC              // configure the ARM GIC

	// write to the pushbutton KEY interrupt mask register
	LDR    R0, =0xFF200050         // pushbutton KEY base address
	MOV    R1, #0xF                // set interrupt mask bits
	STR    R1, [R0, #0x8]          // interrupt mask register (base + 8)

	// enable IRQ interrupts in the processor
	MOV    R0, #0b01010011         // IRQ unmasked, MODE = SVC
	MSR    CPSR_c, R0
		
      // get the addresses
    ldr r4 , =0xff202000
    ldr r6 , adr_T
    ldr r7 , adr_sT
	ldr r12, adr_max
	ldr r10, [r12]
	ldr r0 , [r6]
	ldr r12, adr_dir
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
	mov r8, #0
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
	b counterDir
    // increment LED pattern
counterDir: 
	ldr r11, [r12]
	cmp r11, #1 
	beq forward
	b backward
forward:
	cmp r5, r10 
	beq resetToZ
	add r5, #1 
	b led
resetToZ:
	sub r5, r5
	b led
backward: 
	cmp r5, #0 
	beq resetToM
	sub r5, #1 
	b led
resetToM:
	add r5, r10
	b led	
	
led:
    lsl r8 , #1
    add r8 , #1
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
    b main_loop
    adr_T: .word timer_T
    adr_sT: .word timer_sT
	adr_max: .word countMax
	adr_count: .word currentCount
	adr_dir: .word directon 
	
/*Define the exception service routines*/
/*--- Undefined instructions --------------------------------------------------*/
SERVICE_UND:
	B SERVICE_UND
/*--- Software interrupts -----------------------------------------------------*/
SERVICE_SVC:
	B SERVICE_SVC
/*--- Aborted data reads ------------------------------------------------------*/
SERVICE_ABT_DATA:
	B SERVICE_ABT_DATA
/*--- Aborted instruction fetch -----------------------------------------------*/
SERVICE_ABT_INST:
	B SERVICE_ABT_INST
/*--- IRQ ---------------------------------------------------------------------*/
SERVICE_IRQ:
	PUSH    {R0-R7, LR}

	/*Read the ICCIAR from the CPU Interface*/
	LDR    R4, =0xFFFEC100
	LDR    R5, [R4, #0x0C]        // read from ICCIAR

FPGA_IRQ1_HANDLER:
	CMP    R5, #73
UNEXPECTED:
	BNE    UNEXPECTED             // if not recognized, stop here

	BL      KEY_ISR
EXIT_IRQ:
	/*Write to the End of Interrupt Register (ICCEOIR)*/
	STR    R5, [R4, #0x10]        // write to ICCEOIR

	POP    {R0-R7, LR}
	SUBS    PC, LR, #4

/*--- FIQ ---------------------------------------------------------------------*/
SERVICE_FIQ:
	B	SERVICE_FIQ


/**Configure the Generic Interrupt Controller (GIC)*/
.global CONFIG_GIC
CONFIG_GIC:
	PUSH   {LR}
	/*To configure the FPGA KEYS interrupt (ID 73):
	 *1. set the target to cpu0 in the ICDIPTRn register
	 *2. enable the interrupt in the ICDISERn register*/
	/*CONFIG_INTERRUPT (int_ID (R0), CPU_target (R1));*/
	MOV    R0, #73         // KEY port (Interrupt ID = 73)
	MOV    R1, #1          // this field is a bit-mask; bit 0 targets cpu0
	BL     CONFIG_INTERRUPT

	/*configure the GIC CPU Interface*/
	LDR    R0, =0xFFFEC100  // base address of CPU Interface
	/*Set Interrupt Priority Mask Register (ICCPMR)*/
	LDR    R1, =0xFFFF      // enable interrupts of all priorities levels
	STR    R1, [R0, #0x04]
	/*Set the enable bit in the CPU Interface Control Register (ICCICR).
	 *This allows interrupts to be forwarded to the CPU(s)*/
	MOV    R1, #1
	STR    R1, [R0]

	/*Set the enable bit in the Distributor Control Register (ICDDCR).
	 *This enables forwarding of interrupts to the CPU Interface(s)*/
	LDR    R0, =0xFFFED000
	STR    R1, [R0]
	POP    {PC}

/*
 *Configure registers in the GIC for an individual Interrupt ID
 *We configure only the Interrupt Set Enable Registers (ICDISERn) and
 *Interrupt Processor Target Registers (ICDIPTRn). The default (reset)
 *values are used for other registers in the GIC
 *Arguments: R0 = Interrupt ID, N
 *	     R1 = CPU target
*/
CONFIG_INTERRUPT:
	PUSH   {R4-R5, LR}

	/*Configure Interrupt Set-Enable Registers (ICDISERn).
	 *reg_offset = (integer_div(N / 32)*4
	 *value = 1 << (N mod 32)*/
	LSR    R4, R0, #3         // calculate reg_offset
	BIC    R4, R4, #3         // R4 = reg_offset
	LDR    R2, =0xFFFED100
	ADD    R4, R2, R4         // R4 = address of ICDISER

	AND    R2, R0, #0x1F      // N mod 32
	MOV    R5, #1             // enable
	LSL    R2, R5, R2         // R2 = value

	/*Using the register address in R4 and the value in R2 set the
	 *correct bit in the GIC register*/
	LDR    R3, [R4]           // read current register value
	ORR    R3, R3, R2         // set the enable bit
	STR    R3, [R4]           // store the new register value

	/*Configure Interrupt Processor Targets Register (ICDIPTRn)
	 *reg_offset = integer_div(N / 4)*4
	 *index = N mod 4*/
	BIC    R4, R0, #3         // R4 = reg_offset
	LDR    R2, =0xFFFED800
	ADD    R4, R2, R4         // R4 = word address of ICDIPTR
	AND    R2, R0, #0x3       // N mod 4
	ADD    R4, R2, R4         // R4 = byte address in ICDIPTR

	/*Using register address in R4 and the value in R2 write to
	 *(only) the appropriate byte*/
	STRB   R1, [R4]

	POP {R4-R5, PC}

/*************************************************************************
 *Pushbutton - Interrupt Service Routine
 *
 *This routine checks which KEY has been pressed. It writes to HEX0
 ************************************************************************/
.global KEY_ISR
KEY_ISR:
	LDR     R0, =0xFF200050  // base address of pushbutton KEY port
	LDR     R1, [R0, #0xC]   // read edge capture register
	MOV     R2, #0xF
	STR     R2, [R0, #0xC]   // clear the interrupt

	LDR     R0, =0xFF200020  // based address of HEX display

CHECK_KEY0:
	MOV     R3, #0x1
	ANDS    R3, R3, R1      // check for KEY0
	BEQ     CHECK_KEY1
	ldr r12, adr_dir 
	ldr r3, [r12]
	eor r3, #1 
	str r3, [r12]
	B       END_KEY_ISR

CHECK_KEY1:
	MOV     R3, #0x2
	ANDS    R3, R3, R1      // check for KEY1
	BEQ     CHECK_KEY2
	ldr r12, adr_dir 
	ldr r3, [r12]
	eor r3, #1 
	str r3, [r12]
	B       END_KEY_ISR

CHECK_KEY2:
	MOV     R3, #0x4
	ANDS    R3, R3, R1      // check for KEY2
	BEQ     IS_KEY3
	ldr r12, adr_dir 
	ldr r3, [r12]
	eor r3, #1 
	str r3, [r12]
	B       END_KEY_ISR

IS_KEY3:
	MOV     R2, #0b01001111
	ldr r12, adr_dir 
	ldr r3, [r12]
	eor r3, #1 
	str r3, [r12]

END_KEY_ISR:
	BX LR

	.end