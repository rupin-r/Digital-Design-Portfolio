;***************************************
;
; Team Member 1 Name: Rupin Pradeep
; Team Member 1 Email: rupinraj@buffalo.edu
; Team Member 2 Name: Scilla Benussi
; Team Member 2 Email: scillabe@buffalo.edu
; Course: CSE 379 Microprocessors
; Assignment: Lab 7
; Date: 4/28/23
;
; Description of Program Purpose: 		Create a library to store essential input and output operations for the game breakout
;
; Functions and Modules in this file:	uart_init, gpio_btn_and_LED_init, keypad_init, output_character
;										read_character, read_string, output_string, read_from_push_btns
;										illuminate_LEDs, illuminate_RGB_LED, read_tiva_push_button
;										read_keypad, uart_interrupt_init, gpio_interrupt_init, UART0_Handler
;										Switch_Handler, Timer_Handler, simple_read_character, int2string
;
;***************************************

	.data

	.global prompt
	.global mydata

	.text

	.global uart_interrupt_init
	.global gpio_interrupt_init
	.global timer_init
	.global UART0_Handler
	.global Switch_Handler
	.global Timer_Handler			; This is needed for Lab #6
	.global push_btn_handler
	.global simple_read_character
	.global output_character		; This is from your Lab #4 Library
	.global read_character			; This is from your Lab #4 Library
	.global output_string			; This is from your Lab #4 Library
	.global uart_init				; This is from your Lab #4 Library
	.global gpio_btn_and_LED_init	; This is from your Lab #4 Library
	.global int2string				; This is from your Lab #4 Library
	.global push_btn_interrupt_init
	.global read_from_push_btns
	.global read_alice_btns
	.global illuminate_LEDs
	.global illuminate_RGB_LED
	.global read_tiva_push_button
	.global simple_int_to_string
	.global character_to_value
	.global print_and_move_character

**************************************************************************************************
SYSCTL:			.word	0x400FE000	; Base address for System Control
GPIO_PORT_A:	.word	0x40004000	; Base address for GPIO Port A
GPIO_PORT_D:	.word	0x40007000	; Base address for GPIO Port D
U0FR: 			.equ 	0x18		; UART0 Flag Register
RCGCGPIO:		.equ	0x608		; Offset for GPIO Run Mode Clock Gating Control Register
GPIODIR:		.equ	0x400		; Offset for GPIO Direction Register
GPIODEN:		.equ	0x51C		; Offset for GPIO Digital Enable Register
GPIODATA:		.equ	0x3FC		; Offset for GPIO Data Register
GPIOPULLUP:		.equ 	0x510		; Offset for GPIO Pull-Up Resistor
**************************************************************************************************

; Joseph
push_btn_interrupt_init:
	PUSH {r4-r12, lr}
	MOV r0, #0x7000 ; 40007000
	MOVT r0, #0x4000
	; Set edge level
	LDRB r1, [r0, #0x404]
	AND r1, r1, #0xF0
	STRB r1, [r0, #0x404]

	; Set both edge trigger
	LDRB r1, [r0, #0x408]
	ORR r1, r1, #0xF
	STRB r1, [r0, #0x408]

	; Enable
	; Set both edge trigger
	LDRB r1, [r0, #0x410]
	ORR r1, r1, #0xF
	STRB r1, [r0, #0x410]

	MOV r0, #0xE000
	MOVT r0, #0xE000
	LDRB r1, [r0, #0x100]
	ORR r1, #0x8
	STRB r1, [r0, #0x100]
	POP {r4-r12, lr}
	MOV pc, lr

; Function/Module Name: uart_interrupt_init
; Summary of Purpose: This subroutine is the assembly initialization of the UART interrupt
;
; Inputs: none
; Outputs: none

uart_interrupt_init:
	PUSH {lr, r4}					; store lr on the stack

	; Configure Processor to Allow UART0 to Interrupt Processor
	mov r2, #0xE000
	movt r2, #0xE000
	mov r3, #0x1
	ldrb r4, [r2, #0x100]
	bfi r4, r3, #5, #1
	strb r4, [r2, #0x100]

	; Configuring the UART for Interrupts
	mov r1, #0xC000
	movt r1, #0x4000
	mov r3, #1
	ldrb r4, [r1, #0x38]
	bfi r4, r3, #4, #1
	strb r4, [r1, #0x38]


	POP {lr,r4}					; restore lr from the stack
	MOV pc, lr					; return to caller


; Function/Module Name: gpio_interrupt_init
; Summary of Purpose: This subroutine is the assembly initialization of the GPIO interrupt for SW1
;
; Inputs: none
; Outputs: none

gpio_interrupt_init:
	PUSH {lr, r4}					; store lr on the stack

	; Configure Processor to Allow GPIO Port F to Interrupt Processor
	mov r2, #0xE000
	movt r2, #0xE000
	mov r1, #0x5000
	movt r1, #0x4002

	mov r3, #0x1
	ldrb r4, [r2, #0x103]
	bfi r4, r3, #6, #1
	strb r4, [r2, #0x103]

	; Configuring the GPIO for Interrupt – Enabling the Interrupt
	ldrb r4, [r1, #0x410]
	mov r3, #1
	bfi r4, r3, #4, #1
	strb r4, [r1, #0x410]

	; Configuring the GPIO for Interrupts – Determining Edge/Level Sensitivity
	ldrb r4, [r1, #0x404]
	mov r3, #0
	bfi r4, r3, #4, #1
	strb r4, [r1, #0x404]

	; Configuring the GPIO for Interrupts – Selecting Both or Single Edge Triggering
	ldrb r4, [r1, #0x408]
	mov r3, #0
	bfi r4, r3, #4, #1
	strb r4, [r1, #0x408]

	; Configuring the GPIO for Interrupts – Selecting Edge for Interrupt Triggering
	ldrb r4, [r1, #0x40C]
	mov r3, #0
	bfi r4, r3, #4, #1
	strb r4, [r1, #0x40C]

	POP {lr, r4}					; restore lr from the stack
	MOV pc, lr					; return to caller

timer_init:
	PUSH{lr,r4,r10}				; store lr to stack
	; Connect Clock to Timer @ 0x400FE604
	mov r2, #0xE000
	movt r2, #0x400F
	mov r3, #0x1
	ldrb r4, [r2, #0x604]
	bfi r4, r3, #0, #1
	strb r4, [r2, #0x604]

	; Disable Timer @ 0x4003000C
	mov r2, #0x0000
	movt r2, #0x4003
	mov r3, #0x0
	ldrb r4, [r2, #0xC]
	bfi r4, r3, #0, #1
	strb r4, [r2, #0xC]

	; Put Timer in 32-Bit Mode @ 0x40030000
	mov r3, #0x0
	ldrb r4, [r2, #0]
	bfi r4, r3, #0, #3
	strb r4, [r2, #0]

	; Put Timer in Periodic Mode @0x40030004
	mov r3, #2
	ldrb r4, [r2, #0x4]
	bfi r4, r3, #0, #2
	strb r4, [r2, #0x4]

	; Setup Interval Period @ 0x40030028
	; Starting period is 0.2 per second
	; With a 16MHz clock, that means that we need to set the interval period to 320k
	; r3 = 0000 0000 0000 0100 1110 0010 0000 0000 = 0x4E200
	mov r3, #0xE200
	movt r3, #0x001F
	str r3, [r2, #0x28]

	; Enable Timer to Interrupt Processor @ 0x40030018
	mov r3, #0x1
	ldrb r4, [r2, #0x18]
	bfi r4, r3, #0, #1
	strb r4, [r2, #0x18]

	; Configure Processor to Allow Timer to Interrupt Processor @0x0xE000E102
	mov r2, #0xE000
	movt r2, #0xE000
	mov r3, #1
	ldrb r4, [r2, #0x102]
	bfi r4, r3, #3, #1
	strb r4, [r2, #0x102]

	; Enable Timer @ 0x4003000C
	mov r2, #0x0000
	movt r2, #0x4003
	mov r3, #1
	ldrb r4, [r2, #0xC]
	bfi r4, r3, #0, #1
	strb r4, [r2, #0xC]

	POP {lr,r4,r10}				; restore lr from the stack
	MOV pc, lr					; return to caller

; Function/Module Name: UART0_Handler
; Summary of Purpose: This subroutine is ran whenever the interrupt is triggered for a key press event. It first resets the interrupt and then increments a flag.
;
; Inputs: none
; Outputs: none

UART0_Handler:
	PUSH{lr}					; store lr to stack to call simple_read_character

	mov r0, #0xC000				; store the location of UART0 into r0
	movt r0, #0x4000
	mov r1, #0x10
	str r1, [r0, #0x44]			; set the GPIO ICR bit to 1 so the interrupt clears
	bl simple_read_character	; read the inputted character
	mov r9, #0
	cmp r0, #97
	bne check_d
	orr r9, r9, #1
	b checked
check_d:
	cmp r0, #100
	bne check_s
	orr r9, r9, #2
	b checked
check_s:
	cmp r0, #115
	bne check_w
	orr r9, r9, #4
	b checked
check_w:
	cmp r0, #119
	bne checked
	orr r9, r9, #8
	b checked

checked:

	POP{lr}						; restore lr from stack
	BX lr			 			; return to main program


; Function/Module Name: Switch_Handler
; Summary of Purpose: This subroutine is ran whenever the interrupt is triggered for a key press event. It first resets the interrupt and then increments a flag.
;
; Inputs: none
; Outputs: none

Switch_Handler:
	PUSH{lr}

	mov r0, #0x5000				; store the location of GPIOF into r0
	movt r0, #0x4002
	mov r1, #0x10
	strb r1, [r0, #0x41C]		; set the GPIO ICR bit to 1 so the interrupt clears
	mov r7, #1

Exit_switch:
	POP{lr}
	BX lr 				      	; return to main program


Timer_Handler:

	; Timer Clear Interrupt @ 0x40030024
	mov r0, #0x0000
	movt r0, #0x4003
	mov r1, #1
	strb r1, [r0, #0x24]	; clear the interrupt in the Timer 0 ICR by setting it to 1
	mov r8, #1

Exit_timer:
	BX lr       	; Return


; Joseph
push_btn_handler:
	PUSH{lr}

	mov r0, #0x7000				; store the location of GPIOF into r0
	movt r0, #0x4000
	ldrb r4, [r0]
	mov r1, #0x0F
	strb r1, [r0, #0x41C]		; set the GPIO ICR bit to 1 so the interrupt clears
	ldrb r11, [r0]

Exit_push_btn:
	POP{lr}
	BX lr 				      	; return to main program


; Function/Module Name:gpio_init
; Summary of Purpose: This subroutine is the assembly initialization of the GPIO necessary to control SW1
;
; Inputs: none
; Outputs: none

gpio_btn_and_LED_init:
	PUSH {lr, r4, r5, r6}
	; Enabling GPIO Port B, D, and F
	mov r2, #0xE608				; Enabling Clock 0x400FE608
	movt r2, #0x400F
	mov r4, #0x1
	ldrb r5, [r2, #0x0] 		; load clock data to write into
	bfi r5, r4, #5, #1			; enable clock for port F
	bfi r5, r4, #3, #1			; enable clock for port D
	bfi r5, r4, #1, #1			; enable clock for port B
	strb r5, [r2, #0x0]			; store new clock data back into
	NOP							; AFTER 5 HOURS OF DEBUG... THIS WAS NEEDED
	NOP 						; ...AND THIS. ESPECIALLY THIS

	; PORT F
	mov r1, #0x5000
	movt r1, #0x4002
	; Setting GPIO Pin Direction
	ldrb r6, [r1, #GPIODIR]		; load port F direction data
	mov r4, #0x7
	bfi r6, r4, #1, #4			; overwrite data at position port 4 to be an input and ports 1 - 3 to be outputs
	strb r6, [r1, #GPIODIR]		; store back into direction

	; GPIO Digital Enable
	mov r4, #0x1E
	strb r4, [r1, #GPIODEN] 	; store port F digital enable and overwrite existing data to make ports 0 - 4 enabled

	; GPIO Pullup Resistor
	ldrb r2, [r1, #GPIOPULLUP]	; load port F pullup resistor data
	mov r3, #0x1
	bfi r2, r3, #4 ,#1			; overwrite data at position port 4
	strb r2, [r1, #GPIOPULLUP]	; store back into pullup


	; PORT B
	mov r1, #0x5000
	movt r1, #0x4000
	; Setting GPIO Pin Direction for port B
	ldrb r6, [r1, #GPIODIR]		; load port B direction data
	mov r4, #0xF
	bfi r6, r4, #0, #4			; overwrite data at position 0 - 3 to be outputs
	strb r6, [r1, #GPIODIR]		; store back into direction

	; GPIO Digital Enable
	mov r4, #0xF
	strb r4, [r1, #GPIODEN]		; store port B digital enable and overwrite existing data to make ports 0 - 3 enabled

	POP {lr, r4, r5, r6}
	MOV pc, lr					; return to caller


; Function/Module Name: uart_init
; Summary of Purpose: This subroutine is the assembly initialization of the UART that controls the terminal
;
; Inputs: none
; Outputs: none

uart_init:
	PUSH {lr}  ; Store register lr on stack

	; Provide clock to UART0
    ;(*((volatile uint32_t *)(0x400FE618))) = 1;
    mov r1, #0xE618
    movt r1, #0x400F
    mov r2, #0x1
    ldr r3, [r1, #0x0]
    orr r3, r3, r2
    str r3, [r1, #0x0]

    ; Enable clock to PortA
    ;(*((volatile uint32_t *)(0x400FE608))) = 1;
    mov r1, #0xE608
    movt r1, #0x400F
    mov r2, #0x1
    ldr r3, [r1, #0x0]
    orr r3, r3, r2
    str r3, [r1, #0x0]

    ; Disable UART0 Control
    ;(*((volatile uint32_t *)(0x4000C030))) = 0;
    mov r1, #0xC030
    movt r1, #0x4000
    mov r2, #0xFFFE
    movt r2, #0xFFFF
    ldr r3, [r1, #0x0]
    and r3, r3, r2
    str r3, [r1, #0x0]

    ; Set UART0_IBRD_R for 115,207 baud
    ;(*((volatile uint32_t *)(0x4000C024))) = 8;
    ; Set UART0_IBRD_R for 230,414 baud
    ;(*((volatile uint32_t *)(0x4000C024))) = 4;
    ; Set UART0_IBRD_R for 460,828 baud
    ;(*((volatile uint32_t *)(0x4000C024))) = 2;
    mov r1, #0xC024
    movt r1, #0x4000
    mov r2, #0x2
    str r2, [r1, #0x0]

    ; Set UART0_FBRD_R for 115,207 baud
    ;(*((volatile uint32_t *)(0x4000C028))) = 44;
    ; Set UART0_FBRD_R for 230,414 baud
    ;(*((volatile uint32_t *)(0x4000C028))) = 22;
    ; Set UART0_FBRD_R for 460,828 baud
    ;(*((volatile uint32_t *)(0x4000C028))) = 11;
    mov r1, #0xC028
    movt r1, #0x4000
    mov r2, #11
    ldr r3, [r1, #0x0]
    bfi r3, r2, #0, #6
    str r3, [r1, #0x0]

    ; Use System Clock
    ;(*((volatile uint32_t *)(0x4000CFC8))) = 0;
    mov r1, #0xCFC8
    movt r1, #0x4000
    mov r2, #0xFFF0
    movt r2, #0xFFFF
    ldr r3, [r1, #0x0]
    and r3, r3, r2
    str r3, [r1, #0x0]

    ; Use 8-bit word length, 1 stop bit, no parity
    ;(*((volatile uint32_t *)(0x4000C02C))) = 0x60;
    mov r1, #0xC02C
    movt r1, #0x4000
    mov r2, #0x60
    ldr r3, [r1, #0x0]
    orr r3, r3, r2
    str r3, [r1, #0x0]

    ; Enable UART0 Control
    ;(*((volatile uint32_t *)(0x4000C030))) = 0x301;
    mov r1, #0xC030
    movt r1, #0x4000
    mov r2, #0x301
    str r2, [r1, #0x0]

    ; Make PA0 and PA1 as Digital Ports
    ;(*((volatile uint32_t *)(0x4000451C))) |= 0x03;
    mov r1, #0x451C
    movt r1, #0x4000
    ldr r2, [r1, #0x0]
    orr r2, r2, #0x03
    str r2, [r1, #0x0]

    ; Change PA0,PA1 to Use an Alternate Function
    ;(*((volatile uint32_t *)(0x40004420))) |= 0x03;
    mov r1, #0x4420
    movt r1, #0x4000
    ldr r2, [r1, #0x0]
    orr r2, r2, #0x03
    str r2, [r1, #0x0]

    ; Configure PA0 and PA1 for UART
    ;(*((volatile uint32_t *)(0x4000452C))) |= 0x11;
    mov r1, #0x452C
    movt r1, #0x4000
    ldr r2, [r1, #0x0]
    orr r2, r2, #0x11
    str r2, [r1, #0x0]
	POP {lr}
	mov pc, lr

; Function/Module Name: simple_read_character
; Summary of Purpose: reads a character from memory and then returns it from r0 with no waiting/polling time
;
; Inputs: a key board press
; Outputs: the typed in character in r0

simple_read_character:
	PUSH {lr}   				; Store register lr on stack

	mov r1, #0xC000  			; r1 = 0x0000C000
	movt r1, #0x4000			; r1 = 0x4000C000
	ldrb r0, [r1, #0]			; load the data section of the value at memory address 0X4000C000 in r0

	POP {lr}					; restore lr from the stack
	MOV PC,LR      				; return to caller


; Function/Module Name: int2string
; Summary of Purpose: Subroutine that stores an integer as a NULL terminated ASCII string in memory
;
; Inputs: r0 holding the integer to be stored in memory
;		  r1 holding the address in memory to store the integer
; Outputs: r0 holding the memory address of the integer stored in memory

int2string:
	PUSH {lr,r8,r9}   ; Store register lr on stack
	mov r9, r1	; r9 <- address where the string is getting saved
	mov r8, r1
	mov r1, #0	; r1 = 0
	add r8, r8, #6	; r8 points to the end of the string
	strb r1, [r8, #0]	; store null byte at the end
	sub r8, r8, #1		; move r8 left 1 byte in memory
	mov r3, r8			; store temporary initial location of actual integer (no leading 0s)
change_place:
	mov r1, #0			; reinitialize any edited registers
	mov r2, #10			; r2 = 10
	; Find the modulus 10 of r0 and store into r1
	udiv r1, r0, r2
	mul r1, r1, r2
	sub r1, r0, r1
	cmp r1, #0x0		; If the module is equal to 0, then it's not the beginning of the actual integer in memory
	beq skip
	mov r3, r8			; Otherwise, update the location of the first integer in the string (non zero)
skip:
	add r1, r1, #0x30	; add 48 (0x30) to change the integer to an ASCII character
	strb r1, [r8, #0]	; Store the character into memory at r8
	udiv r0, r0, r2		; divide r0 by 10
	cmp r8, r9			; Check if we are at the maximum number of digits allowed (6)
	sub r8, r8, #1		; move r8 left 1 byte in memory
	bne change_place	; If r8 is less than the beginning address now, exit loop
	mov r0, r3			; store the address of the first valid integer (non zero) into r0
	POP {lr,r8,r9}		; return from method call
	mov pc, lr


; Function/Module Name: output_string
; Summary of Purpose: Subroutine that transmits NULL-terminated strings for display in PuTTy
;
; Inputs: r0 holding the address in memory that stores the string to be printed
; Outputs: outputs a string to the console

output_string:
	PUSH {lr, r8}   			; Store register lr on stack
	mov r8, r0					; Save base address of the string into r1 from r0

continue_printing:				; loop to print individual characters of the string
	mov r2, #0x0				; r2 = 0
	ldrb r0, [r8, #0x0]			; load the character (one byte) of the string
	cmp r0, r2					; is the character the NULL value (ascii char 0x0)?
	beq done_printing			; If it is, then we are done printing the string
	bl output_character			; If it's not, then we output the character
	cmp r0, #0xB2
	beq print_extra
	cmp r0, #0x20
	beq print_extra
	cmp r0, #0x8
	beq print_extra
esc:
	add r8, r8, #1				; Otherwise we update the memory address to the next byte to print the next character...
	b continue_printing			; ... and we loop again
done_printing:					; exit subroutine when done printing the string
	POP {lr, r8}
	mov pc, lr					; return to caller
print_extra:
	bl output_character
	bl output_character
	b esc


; Function/Module Name: output_character
; Summary of Purpose: Subroutine that prints a character to the display.
;
; Inputs: r0 holding a character to output
; Outputs: outputs a single character to the console

output_character:
	PUSH {lr}   				; Store register lr on stack

	mov r1, #0xC000				; r1 = 0x0000C000
	movt r1, #0x4000			; r1 = 0x4000C000
	mov r2, #0x20				; r2 = 0x20
	mov r3, #0x0				; r3 = 0

wait_out:
	ldrb r3, [r1, #U0FR]		; Load the value at memory address 0X4000C018 in r3
	and r3, r3, r2				; Mask r3 with 0x20 to get the value of the register TxFF (5th bit)
	cmp r3, r2					; exit if the flag TxFF is 0, otherwise loop again
	beq wait_out
	strb r0, [r1, #0]			; store r0 (with the character) at memory address 0x4000C000 to be displayed in PuTTy
	POP {lr}
	mov pc, lr					; return to caller


; Function/Module Name: read_from_push_btns
; Summary of Purpose: Reads the value of the four push buttons on the ALICE board
;					  Reads either 0 for not pressed or 1 for pressed for each switch
;					  and returns a 4 bit value indicating the state of all four switches
;
; Inputs: The user input with ALICE switches SW2, SW3, SW4, and SW5
; Outputs: A four bit value with each bit indicating whether a switch is on or off
;		   A 0 shows not pressed and 1 is pressed with SW2 in the MSB and SW5 in the LSB

read_from_push_btns:
	PUSH {lr}
	mov r0, #0x7000				; access port D
	movt r0, #0x4000
	ldrb r1, [r0, #GPIODATA]	; load port D data section
	eor r0, r1, #0XF			; flip the bits because the input is currently pull-up
	POP {lr}
	MOV pc, lr					; return to caller


; Function/Module Name: read_alice_btns
; Summary of Purpose: Reads which of the 4 switches on the ALICE board is pressed (SW2, SW3, SW4 or SW5)
;
; Inputs: The user input with ALICE switches SW2, SW3, SW4, or SW5
; Outputs: r0 will hold: 0 if no switches are pressed, 1 if SW2 is pressed, 2 if SW3 is pressed, 3 if SW4 is pressed, 4 if SW5 is pressed

read_alice_btns:
	PUSH {lr}
	mov r2, #0x7000				; access port D
	movt r2, #0x4000
	mov r0, #0
	ldrb r3, [r2, #GPIODATA]	; load port D data section
	and r1, r3, #0x1			; check if SW2 holds a value
	cmp r1, #0x1
	mov r0, #4					; return 1 if SW2 is pressed
	beq got_numb
	and r1, r3, #0x2			; check if SW3 is pressed
	cmp r1, #0x2
	mov r0, #3					; return 2 if SW3 is pressed
	beq got_numb
	and r1, r3, #0x4			; check if SW4 is pressed
	cmp r1, #0x4
	mov r0, #2					; return 3 if SW4 is pressed
	beq got_numb
	and r1, r3, #0x8			; check if SW5 is pressed
	cmp r1, #0x8
	mov r0, #1					; return 4 if SW5 is pressed
	beq got_numb				; return 0 otherwise
	mov r0, #0
got_numb:
	POP {lr}
	MOV pc, lr					; return to caller


; Function/Module Name: illuminate_RGB_LED
; Summary of Purpose: Takes in 3 bits as input to turn on an RGB LED to a certain color
;
; Inputs: r0 holds integers from 0 to 5 included
; Outputs: 000 = turn off LED, 001 = red, 101 = yellow, 100 = green,
;		   110 = cyan, 010 = blue, 011 = magenta, 111 = white

illuminate_RGB_LED:
	PUSH {lr}
	mov r1, #0x5000				; access port F
	movt r1, #0x4002
	ldrb r2, [r1, #GPIODATA]	; load port F data section
	cmp r0, #0
	bne red_RGB
	mov r3, #0
	bfi r2, r3, #1, #3			; insert 000 to the RBG LED data section
	b end_RGB
red_RGB:
	cmp r0, #1
	bne green_RGB
	mov r3, #1
	bfi r2, r3, #1, #3			; insert 001 to the RBG LED data section
	b end_RGB
green_RGB:
	cmp r0, #2
	bne yellow_RGB
	mov r3, #4
	bfi r2, r3, #1, #3			; insert 100 to the RBG LED data section
	b end_RGB
yellow_RGB:
	cmp r0, #3
	bne blue_RGB
	mov r3, #5
	bfi r2, r3, #1, #3			; insert 101 to the RBG LED data section
	b end_RGB
blue_RGB:
	cmp r0, #4
	bne purple_RGB
	mov r3, #2
	bfi r2, r3, #1, #3			; insert 010 to the RBG LED data section
	b end_RGB
purple_RGB:
	cmp r0, #5
	bne white_RGB
	mov r3, #3
	bfi r2, r3, #1, #3			; insert 011 to the RBG LED data section
white_RGB:
	cmp r0, #7
	bne end_RGB
	mov r3, #0
	bfi r2, r3, #1, #3			; insert 111 to the RBG LED data section
end_RGB:
	strb r2, [r1, #GPIODATA]	; store back into memory to write to LED
	POP {lr}
	MOV pc, lr					; return to caller


; Function/Module Name: illuminate_LEDs
; Summary of Purpose: Takes in 4 bits as input to turn on specific onboard LEDS based on the value of the input
;
; Inputs: Four bits passed in r0 with LED3 as the MSB and LED0 as the LSB
;		  0 means turn off the LED and 1 means to turn on the LED
; Outputs: Turn on specific LEDs on the ALICE board

illuminate_LEDs:
	PUSH {lr}
	; r0 contains the bit pattern to illuminate the LEDs
	; LED on the daughter board are at port B (0x40005000), offset 0x3FC
	mov r1, #0x5000				; access port B
    movt r1, #0x4000
	ldrb r2, [r1, #GPIODATA]	; load port B data section
	bfi r2, r0, #0, #4			; insert input bits from r0 into 4 LED output locations
	strb r2, [r1, #GPIODATA]	; store back into memory to write to LEDs
	POP {lr}
	MOV pc,lr					; return to caller


; Function/Module Name: read_character
; Summary of Purpose: Subroutine that allows the user to enter a character
;
; Inputs: user input of a character
; Outputs: r0 holding the inputted character value

read_character:
	PUSH {lr}   				; Store register lr on stack

	mov r1, #0xC000  			; r1 = 0x0000C000
	movt r1, #0x4000			; r1 = 0x4000C000
	mov r2, #0x10				; r2 = 10
	mov r3, #0x0				; r3 = 0

wait_in:
	ldrb r3, [r1, #U0FR]		; Load the value at memory address 0X4000C018 in r3
	and r3, r3, r2				; Mask r3 with 0x10 to get the value of the register RxFE (4th bit)
	cmp r3, r2
	beq wait_in					; exit if the flag RxFE is 0, otherwise loop again
	ldrb r0, [r1, #0]			; load the data section of the value at memory address 0X4000C000 in r0
	POP {lr}
	mov pc, lr					; return to caller


simple_int_to_string:
	PUSH{lr,r4-r5}

	mov r2, #10
	mul r0, r0, r2
	add r0, r0, #11
	udiv r1, r0, r2
	mul r3, r1, r2
	sub r4, r0, r3
	udiv r0, r1, r2
	mul r3, r0, r2
	sub r5, r1, r3
	add r0, r0, #0x30
	lsl r0, r0, #8
	add r0, r0, #0x30
	add r0, r0, r5
	lsl r0, r0, #8
	add r0, r0, #0x30
	add r0, r0, r4

return_string:
	POP{lr,r4-r5}
	mov pc, lr


character_to_value:
	PUSH{lr}

	cmp r4, #0x39
	bgt ascii_char
	sub r4, r4, #0x30
	b return_char

ascii_char:
	sub r4, r4, #0x41
	add r4, r4, #0xA

return_char:
	POP{lr}
	mov pc, lr


print_and_move_character:
	PUSH{lr, r4, r5, r6}

	mov r5, r0
	mov r6, r1

	mov r0, r6
	bl output_string
	mov r0, r5
	bl output_string

	ldrb r2, [r6, #9]
	ldrb r3, [r6, #8]
	ldrb r4, [r6, #7]
	add r2, r2, #3
	cmp r2, #0x3A
	blt finished_addition
	sub r2, r2, #0xA
	add r3, r3, #1
	cmp r3, #0x3A
	blt finished_addition
	sub r3, r3, #0xA
	add r4, r4, #1

finished_addition:
	strb r2, [r6, #9]
	strb r3, [r6, #8]
	strb r4, [r6, #7]
	mov r1, r6

	POP{lr, r4, r5, r6}
	mov pc, lr



	.end
