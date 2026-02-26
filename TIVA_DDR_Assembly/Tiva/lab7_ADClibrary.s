	.data
	.global adc0_init
	.global adc1_init
	.global small_adc0_init
	.global small_adc1_init
	.global PotHandler
	.global TopHandler
	.global poll

	.text

PotHandler:
	PUSH{lr, r4-r6}
	mov r4, #0x8000
	movt r4, #0x4003
	ldr r5, [r4, #0x034]
	str r5, [r4, #0x034]
	and r5, r5, #0xF
	orr r9, r9, r5
	ldr r5, [r4, #0x00C]
	str r5, [r4, #0x00C]

	POP{lr, r4-r6}
	BX lr

TopHandler:
	PUSH{lr, r4-r6}
	mov r4, #0x9000
	movt r4, #0x4003
	ldr r5, [r4, #0x034]
	str r5, [r4, #0x034]
	ldr r5, [r4, #0x00C]
	str r5, [r4, #0x00C]

	POP{lr, r4-r6}
	BX lr

poll:
	PUSH{lr}
check_again:
	; Set up default sample triggering time @ 0x40038028
	; base 0x4003.8000 (ADC control) offset 0x028
	mov r2, #0x8000
	movt r2, #0x4003
	mov r3, #0x1
	;ldrb r0, [r2, #0x008]
	;bfi r0, r3, #1, #1
	;strb r0, [r2, #0x008]
	b check_again

	POP{lr}
	mov pc, lr


adc0_init:
	PUSH{lr, r4-r10}

	; Connect clock to ADC module @ 0x400FE638
	; base 0x400F.E000 (clock gating control) offset 0x638
	mov r2, #0xE000
	movt r2, #0x400F
	mov r3, #1
	ldrb r4, [r2, #0x638]
	bfi r4, r3, #0, #1
	strb r4, [r2, #0x638]

	; Connect clock to Port D for inputs @ 0x400FE608
	; base 0x400F.E000 (clock gating control) offset 0x608
	mov r2, #0xE000
	movt r2, #0x400F
	mov r3, #0x1
	ldrb r4, [r2, #0x608]
	bfi r4, r3, #3, #1
	strb r4, [r2, #0x608]

	; Set port D pin direction as inputs @ 40007400
	mov r2, #0x7000
	movt r2, #0x4000
	mov r3, #0x0
	ldrb r4, [r2, #0x400]
	bfi r4, r3, #0, #4
	strb r4, [r2, #0x400]

	; Turn on Alternate Function Select for port D @ 0x40007420
	; base 0x4000.7000 (port D) offset 0x420
	mov r2, #0x7000
	movt r2, #0x4000
	mov r3, #0xF
	ldrb r4, [r2, #0x420]
	bfi r4, r3, #0, #4
	strb r4, [r2, #0x420]

	; Set Alternate Function for port D to analog input @ 0x4000752C
	; base 0x4000.7000 (port D) offset 0x52C
	mov r2, #0x7000
	movt r2, #0x4000
	mov r3, #0x0
	strb r3, [r2, #0x52C]
	strb r3, [r2, #0x52D]

	; Enable analog inputs by blocking digital input @ 0x4000751C
	; base 0x4000.7000 (port D) offset 0x51C
	mov r2, #0x7000
	movt r2, #0x4000
	mov r3, #0x0
	ldrb r4, [r2, #0x51C]
	bfi r4, r3, #0, #4
	strb r4, [r2, #0x51C]

	; Enable analog mode @ 0x40007528
	; base 0x4000.7000 (port D) offset 0x528
	mov r2, #0x7000
	movt r2, #0x4000
	mov r3, #0xF
	ldrb r4, [r2, #0x528]
	bfi r4, r3, #0, #4
	strb r4, [r2, #0x528]

	; Disable sample sequencer 1 @ 0x40038000
	; base 0x4003.8000 (ADC control) offset 0x0
	mov r2, #0x8000
	movt r2, #0x4003
	mov r3, #0x0
	ldrb r4, [r2, #0x0]
	bfi r4, r3, #1, #1
	strb r4, [r2, #0x0]

	; Use always sample for sample triggering @ 0x40038014
	; base 0x4003.8000 (ADC control) offset 0x014
	mov r2, #0x8000
	movt r2, #0x4003
	mov r3, #0xF
	ldr r4, [r2, #0x014]
	bfi r4, r3, #4, #4
	mov r3, #0x0
	bfi r4, r3, #0, #4
	bfi r4, r3, #8, #4
	bfi r4, r3, #12, #4
	str r4, [r2, #0x014]

	; Configure GPIO pins to sample sequencer inputs @ 0x40038060
	; base 0x4003.8000 (ADC control) offset 0x060
	; pin D0 = 61, pin D1 = 62, pin D2 = 63, pin D3 = 64
	mov r2, #0x8000
	movt r2, #0x4003
	mov r3, #4
	ldr r4, [r2, #0x060]
	bfi r4, r3, #0, #4
	mov r3, #5
	bfi r4, r3, #4, #4
	mov r3, #6
	bfi r4, r3, #8, #4
	mov r3, #7
	bfi r4, r3, #12, #4
	str r4, [r2, #0x060]

	; Configure all pins to be read from without interrupt and without differential control @ 0x40038064
	; Also set sample 4 as the last sample
	; base 0x4003.8000 (ADC control) offset 0x064
	mov r2, #0x8000
	movt r2, #0x4003
	mov r3, #0x2000
	ldr r4, [r2, #0x64]
	bfi r4, r3, #0, #16
	str r4, [r2, #0x64]

	; Send results of sequences to digital comparator @ 0x40038074
	; base 0x4003.8000 (ADC control) offset 0x074
	; Send result 0 to comparator 0, result 1 to comparator 1 ...
	mov r2, #0x8000
	movt r2, #0x4003
	mov r3, #0x10
	ldr r4, [r2, #0x074]
	mov r3, #0x32
	bfi r4, r3, #8, #8
	mov r3, #0x10
	bfi r4, r3, #0, #8
	str r4, [r2, #0x074]

	; Set up comparator 0 @ 40038E00
	; base 0x4003.8000 (ADC control) offset 0xE00
	; Disable trigger function, enable interrupt, and configure hysteresis once middle trigger
	mov r2, #0x8000
	movt r2, #0x4003
	mov r3, #0x1F
	ldr r4, [r2, #0xE00]
	bfi r4, r3, #0, #5
	mov r3, #0x00
	bfi r4, r3, #8, #5
	str r4, [r2, #0xE00]

	; Set up comparator 1 @ 40038E04
	; base 0x4003.8000 (ADC control) offset 0xE04
	; Disable trigger function, enable interrupt, and configure hysteresis once middle trigger
	mov r2, #0x8000
	movt r2, #0x4003
	mov r3, #0x1F
	ldr r4, [r2, #0xE04]
	bfi r4, r3, #0, #5
	mov r3, #0x00
	bfi r4, r3, #8, #5
	str r4, [r2, #0xE04]

	; Set up comparator 2 @ 40038E08
	; base 0x4003.8000 (ADC control) offset 0xE08
	; Disable trigger function, enable interrupt, and configure hysteresis once middle trigger
	mov r2, #0x8000
	movt r2, #0x4003
	mov r3, #0x1F
	ldr r4, [r2, #0xE08]
	bfi r4, r3, #0, #5
	mov r3, #0x00
	bfi r4, r3, #8, #5
	str r4, [r2, #0xE08]

	; Set up comparator 3 @ 40038E0C
	; base 0x4003.8000 (ADC control) offset 0xE0C
	; Disable trigger function, enable interrupt, and configure hysteresis once top trigger
	mov r2, #0x8000
	movt r2, #0x4003
	mov r3, #0x1F
	ldr r4, [r2, #0xE0C]
	bfi r4, r3, #0, #5
	mov r3, #0x00
	bfi r4, r3, #8, #5
	str r4, [r2, #0xE0C]

	; Set range for middle threshold of comparator 0 @ 40038E40
	; base 0x4003.8000 (ADC control) offset 0xE40
	mov r2, #0x8000
	movt r2, #0x4003
	mov r3, #0x9D0
	ldr r4, [r2, #0xE40]
	bfi r4, r3, #0, #12
	mov r3, #0x9F0
	bfi r4, r3, #16, #12
	str r4, [r2, #0xE40]

	; Set range for middle threshold of comparator 1 @ 40038E44
	; base 0x4003.8000 (ADC control) offset 0xE44
	mov r2, #0x8000
	movt r2, #0x4003
	mov r3, #0x9D0
	ldr r4, [r2, #0xE44]
	bfi r4, r3, #0, #12
	mov r3, #0x9F0
	bfi r4, r3, #16, #12
	str r4, [r2, #0xE44]

	; Set range for middle threshold of comparator 2 @ 40038E48
	; base 0x4003.8000 (ADC control) offset 0xE48
	mov r2, #0x8000
	movt r2, #0x4003
	mov r3, #0x9D0
	ldr r4, [r2, #0xE48]
	bfi r4, r3, #0, #12
	mov r3, #0x9F0
	bfi r4, r3, #16, #12
	str r4, [r2, #0xE48]

	; Set range for middle threshold of comparator 3 @ 40038E4C
	; base 0x4003.8000 (ADC control) offset 0xE4C
	mov r2, #0x8000
	movt r2, #0x4003
	mov r3, #0x9D0
	ldr r4, [r2, #0xE4C]
	bfi r4, r3, #0, #12
	mov r3, #0x9F0
	bfi r4, r3, #16, #12
	str r4, [r2, #0xE4C]

	; Move sample sequence values to digital comparator @ 40038070
	; base 0x4003.8000 (ADC control) offset 0x070
	mov r2, #0x8000
	movt r2, #0x4003
	mov r3, #0x3
	ldr r4, [r2, #0x070]
	bfi r4, r3, #0, #1
	bfi r4, r3, #4, #1
	bfi r4, r3, #8, #1
	bfi r4, r3, #12, #1
	str r4, [r2, #0x070]

	; Configure interrupts from comparator onto sequencer @ 40038008
	; base 0x4003.8000 (ADC control) offset 0x008
	mov r2, #0x8000
	movt r2, #0x4003
	mov r3, #0x0
	ldr r4, [r2, #0x008]
	bfi r4, r3, #1, #1
	mov r3, #0x1
	bfi r4, r3, #17, #1
	str r4, [r2, #0x008]

	; Reset comparator
	mov r2, #0x8000
	movt r2, #0x4003
	mov r3, #0xFF
	ldr r4, [r2, #0xD00]
	bfi r4, r3, #0, #8
	str r4, [r2, #0xD00]

	; Configure Processor to allow ADC to interrupt Processor
	mov r2, #0xE000
	movt r2, #0xE000
	mov r3, #0x1
	ldr r4, [r2, #0x100]
	bfi r4, r3, #15, #1
	str r4, [r2, #0x100]

	; Enable sample sequencer 1 @ 0x40038000
	; base 0x4003.8000 (ADC control) offset 0x0
	mov r2, #0x8000
	movt r2, #0x4003
	mov r3, #0x1
	ldrb r4, [r2, #0x0]
	bfi r4, r3, #1, #1
	strb r4, [r2, #0x0]


	POP{lr, r4-r10}
	MOV pc, lr


adc1_init:
	PUSH{lr, r4-r10}

	; Connect clock to ADC module @ 0x400FE638
	; base 0x400F.E000 (clock gating control) offset 0x638
	mov r2, #0xE000
	movt r2, #0x400F
	mov r3, #1
	ldrb r4, [r2, #0x638]
	bfi r4, r3, #1, #1
	strb r4, [r2, #0x638]

	; Connect clock to Port E for inputs @ 0x400FE608
	; base 0x400F.E000 (clock gating control) offset 0x608
	mov r2, #0xE000
	movt r2, #0x400F
	mov r3, #0x1
	ldrb r4, [r2, #0x608]
	bfi r4, r3, #4, #1
	strb r4, [r2, #0x608]

	; Set port E pin direction as inputs @ 40024400
	mov r2, #0x4000
	movt r2, #0x4002
	mov r3, #0x0
	ldrb r4, [r2, #0x400]
	bfi r4, r3, #1, #4
	strb r4, [r2, #0x400]

	; Turn on Alternate Function Select for port D @ 0x40024420
	; base 0x4002.4000 (port E) offset 0x420
	mov r2, #0x4000
	movt r2, #0x4002
	mov r3, #0xF
	ldrb r4, [r2, #0x420]
	bfi r4, r3, #1, #4
	strb r4, [r2, #0x420]

	; Set Alternate Function for port E to analog input @ 0x4002452C
	; base 0x4002.4000 (port E) offset 0x52C
	mov r2, #0x4000
	movt r2, #0x4002
	mov r3, #0x0
	ldr r4, [r2, #0x52C]
	bfi r4, r3, #4, #16
	str r4, [r2, #0x52C]

	; Enable analog inputs by blocking digital input @ 0x4002451C
	; base 0x4002.4000 (port E) offset 0x51C
	mov r2, #0x4000
	movt r2, #0x4002
	mov r3, #0x0
	ldrb r4, [r2, #0x51C]
	bfi r4, r3, #1, #4
	strb r4, [r2, #0x51C]

	; Enable analog mode @ 0x40024528
	; base 0x4002.4000 (port E) offset 0x528
	mov r2, #0x4000
	movt r2, #0x4002
	mov r3, #0xF
	ldrb r4, [r2, #0x528]
	bfi r4, r3, #1, #4
	strb r4, [r2, #0x528]

	; Disable sample sequencer 1 @ 0x40038000
	; base 0x4003.9000 (ADC control) offset 0x0
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0x0
	ldrb r4, [r2, #0x0]
	bfi r4, r3, #1, #1
	strb r4, [r2, #0x0]

	; Use always sample for sample triggering @ 0x40038014
	; base 0x4003.8000 (ADC control) offset 0x014
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0xF
	ldr r4, [r2, #0x014]
	bfi r4, r3, #4, #4
	mov r3, #0x0
	bfi r4, r3, #0, #4
	bfi r4, r3, #8, #4
	bfi r4, r3, #12, #4
	str r4, [r2, #0x014]

	; Configure GPIO pins to sample sequencer inputs @ 0x40038060
	; base 0x4003.8000 (ADC control) offset 0x060
	; pin D0 = 61, pin D1 = 62, pin D2 = 63, pin D3 = 64
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #4
	ldr r4, [r2, #0x060]
	bfi r4, r3, #0, #4
	mov r3, #5
	bfi r4, r3, #4, #4
	mov r3, #6
	bfi r4, r3, #8, #4
	mov r3, #7
	bfi r4, r3, #12, #4
	str r4, [r2, #0x060]

	; Configure all pins to be read from without interrupt and without differential control @ 0x40038064
	; Also set sample 4 as the last sample
	; base 0x4003.8000 (ADC control) offset 0x064
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0x2000
	ldr r4, [r2, #0x64]
	bfi r4, r3, #0, #16
	str r4, [r2, #0x64]

	; Send results of sequences to digital comparator @ 0x40038074
	; base 0x4003.8000 (ADC control) offset 0x074
	; Send result 0 to comparator 0, result 1 to comparator 1 ...
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0x10
	ldr r4, [r2, #0x074]
	mov r3, #0x32
	bfi r4, r3, #8, #8
	mov r3, #0x10
	bfi r4, r3, #0, #8
	str r4, [r2, #0x074]

	; Set up comparator 0 @ 40038E00
	; base 0x4003.8000 (ADC control) offset 0xE00
	; Disable trigger function, enable interrupt, and configure hysteresis once bottom trigger
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0x13
	ldr r4, [r2, #0xE00]
	bfi r4, r3, #0, #5
	mov r3, #0x00
	bfi r4, r3, #8, #5
	str r4, [r2, #0xE00]

	; Set up comparator 1 @ 40038E04
	; base 0x4003.8000 (ADC control) offset 0xE04
	; Disable trigger function, enable interrupt, and configure hysteresis once middle trigger
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0x13
	ldr r4, [r2, #0xE04]
	bfi r4, r3, #0, #5
	mov r3, #0x00
	bfi r4, r3, #8, #5
	str r4, [r2, #0xE04]

	; Set up comparator 2 @ 40038E08
	; base 0x4003.8000 (ADC control) offset 0xE08
	; Disable trigger function, enable interrupt, and configure hysteresis once middle trigger
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0x13
	ldr r4, [r2, #0xE08]
	bfi r4, r3, #0, #5
	mov r3, #0x00
	bfi r4, r3, #8, #5
	str r4, [r2, #0xE08]

	; Set up comparator 3 @ 40038E0C
	; base 0x4003.8000 (ADC control) offset 0xE0C
	; Disable trigger function, enable interrupt, and configure hysteresis once middle trigger
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0x13
	ldr r4, [r2, #0xE0C]
	bfi r4, r3, #0, #5
	mov r3, #0x00
	bfi r4, r3, #8, #5
	str r4, [r2, #0xE0C]

	; Set range for middle threshold of comparator 0 @ 40038E40
	; base 0x4003.8000 (ADC control) offset 0xE40
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0x9D0
	ldr r4, [r2, #0xE40]
	bfi r4, r3, #0, #12
	mov r3, #0x9F0
	bfi r4, r3, #16, #12
	str r4, [r2, #0xE40]

	; Set range for middle threshold of comparator 1 @ 40038E44
	; base 0x4003.8000 (ADC control) offset 0xE44
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0x9D0
	ldr r4, [r2, #0xE44]
	bfi r4, r3, #0, #12
	mov r3, #0x9F0
	bfi r4, r3, #16, #12
	str r4, [r2, #0xE44]

	; Set range for middle threshold of comparator 2 @ 40038E48
	; base 0x4003.8000 (ADC control) offset 0xE48
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0x9D0
	ldr r4, [r2, #0xE48]
	bfi r4, r3, #0, #12
	mov r3, #0x9F0
	bfi r4, r3, #16, #12
	str r4, [r2, #0xE48]

	; Set range for middle threshold of comparator 3 @ 40038E4C
	; base 0x4003.8000 (ADC control) offset 0xE4C
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0x9D0
	ldr r4, [r2, #0xE4C]
	bfi r4, r3, #0, #12
	mov r3, #0x9F0
	bfi r4, r3, #16, #12
	str r4, [r2, #0xE4C]

	; Move sample sequence values to digital comparator @ 40038070
	; base 0x4003.8000 (ADC control) offset 0x070
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0x3
	ldr r4, [r2, #0x070]
	bfi r4, r3, #0, #1
	bfi r4, r3, #4, #1
	bfi r4, r3, #8, #1
	bfi r4, r3, #12, #1
	str r4, [r2, #0x070]

	; Configure interrupts from comparator onto sequencer @ 40038008
	; base 0x4003.8000 (ADC control) offset 0x008
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0x0
	ldr r4, [r2, #0x008]
	bfi r4, r3, #1, #1
	mov r3, #0x1
	bfi r4, r3, #17, #1
	str r4, [r2, #0x008]

	; Reset comparator
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0xFF
	ldr r4, [r2, #0xD00]
	bfi r4, r3, #0, #8
	str r4, [r2, #0xD00]

	; Configure Processor to allow ADC to interrupt Processor
	mov r2, #0xE004
	movt r2, #0xE000
	mov r3, #0x1
	ldr r4, [r2, #0x100]
	bfi r4, r3, #17, #1
	str r4, [r2, #0x100]

	; Enable sample sequencer 1 @ 0x40038000
	; base 0x4003.8000 (ADC control) offset 0x0
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0x1
	ldrb r4, [r2, #0x0]
	bfi r4, r3, #1, #1
	strb r4, [r2, #0x0]


	POP{lr, r4-r10}
	MOV pc, lr


small_adc0_init:
	PUSH{lr, r4-r10}

	; Connect clock to ADC module @ 0x400FE638
	; base 0x400F.E000 (clock gating control) offset 0x638
	mov r2, #0xE000
	movt r2, #0x400F
	mov r3, #1
	ldrb r4, [r2, #0x638]
	bfi r4, r3, #0, #1
	strb r4, [r2, #0x638]

	; Connect clock to Port D for inputs @ 0x400FE608
	; base 0x400F.E000 (clock gating control) offset 0x608
	mov r2, #0xE000
	movt r2, #0x400F
	mov r3, #0x1
	ldrb r4, [r2, #0x608]
	bfi r4, r3, #3, #1
	strb r4, [r2, #0x608]

	; Set port D pin direction as inputs @ 40007400
	mov r2, #0x7000
	movt r2, #0x4000
	mov r3, #0x0
	ldrb r4, [r2, #0x400]
	bfi r4, r3, #0, #4
	strb r4, [r2, #0x400]

	; Turn on Alternate Function Select for port D @ 0x40007420
	; base 0x4000.7000 (port D) offset 0x420
	mov r2, #0x7000
	movt r2, #0x4000
	mov r3, #0xF
	ldrb r4, [r2, #0x420]
	bfi r4, r3, #0, #4
	strb r4, [r2, #0x420]

	; Set Alternate Function for port D to analog input @ 0x4000752C
	; base 0x4000.7000 (port D) offset 0x52C
	mov r2, #0x7000
	movt r2, #0x4000
	mov r3, #0x0
	strb r3, [r2, #0x52C]
	strb r3, [r2, #0x52D]

	; Enable analog inputs by blocking digital input @ 0x4000751C
	; base 0x4000.7000 (port D) offset 0x51C
	mov r2, #0x7000
	movt r2, #0x4000
	mov r3, #0x0
	ldrb r4, [r2, #0x51C]
	bfi r4, r3, #0, #4
	strb r4, [r2, #0x51C]

	; Enable analog mode @ 0x40007528
	; base 0x4000.7000 (port D) offset 0x528
	mov r2, #0x7000
	movt r2, #0x4000
	mov r3, #0xF
	ldrb r4, [r2, #0x528]
	bfi r4, r3, #0, #4
	strb r4, [r2, #0x528]

	; Disable sample sequencer 1 @ 0x40038000
	; base 0x4003.8000 (ADC control) offset 0x0
	mov r2, #0x8000
	movt r2, #0x4003
	mov r3, #0x0
	ldrb r4, [r2, #0x0]
	bfi r4, r3, #1, #1
	strb r4, [r2, #0x0]

	; Use always sample for sample triggering @ 0x40038014
	; base 0x4003.8000 (ADC control) offset 0x014
	mov r2, #0x8000
	movt r2, #0x4003
	mov r3, #0xF
	ldr r4, [r2, #0x014]
	bfi r4, r3, #4, #4
	mov r3, #0x0
	bfi r4, r3, #0, #4
	bfi r4, r3, #8, #4
	bfi r4, r3, #12, #4
	str r4, [r2, #0x014]

	; Configure GPIO pins to sample sequencer inputs @ 0x40038060
	; base 0x4003.8000 (ADC control) offset 0x060
	; pin D0 = 61, pin D1 = 62, pin D2 = 63, pin D3 = 64
	mov r2, #0x8000
	movt r2, #0x4003
	mov r3, #4
	ldr r4, [r2, #0x060]
	bfi r4, r3, #0, #4
	mov r3, #5
	bfi r4, r3, #4, #4
	mov r3, #6
	bfi r4, r3, #8, #4
	mov r3, #7
	bfi r4, r3, #12, #4
	str r4, [r2, #0x060]

	; Configure all pins to be read from without interrupt and without differential control @ 0x40038064
	; Also set sample 4 as the last sample
	; base 0x4003.8000 (ADC control) offset 0x064
	mov r2, #0x8000
	movt r2, #0x4003
	mov r3, #0x6000
	ldr r4, [r2, #0x64]
	bfi r4, r3, #0, #16
	str r4, [r2, #0x64]

	; Configure Processor to allow ADC to interrupt Processor
	mov r2, #0xE000
	movt r2, #0xE000
	mov r3, #0x1
	ldr r4, [r2, #0x100]
	bfi r4, r3, #15, #1
	str r4, [r2, #0x100]

	; Enable sample sequencer 1 @ 0x40038000
	; base 0x4003.8000 (ADC control) offset 0x0
	mov r2, #0x8000
	movt r2, #0x4003
	mov r3, #0x1
	ldrb r4, [r2, #0x0]
	bfi r4, r3, #1, #1
	strb r4, [r2, #0x0]


	POP{lr, r4-r10}
	MOV pc, lr


small_adc1_init:
	PUSH{lr, r4-r10}

	; Connect clock to ADC module @ 0x400FE638
	; base 0x400F.E000 (clock gating control) offset 0x638
	mov r2, #0xE000
	movt r2, #0x400F
	mov r3, #1
	ldrb r4, [r2, #0x638]
	bfi r4, r3, #1, #1
	strb r4, [r2, #0x638]

	; Disable sample sequencer 1 @ 0x40038000
	; base 0x4003.9000 (ADC control) offset 0x0
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0x0
	ldrb r4, [r2, #0x0]
	bfi r4, r3, #1, #1
	strb r4, [r2, #0x0]

	; Use always sample for sample triggering @ 0x40038014
	; base 0x4003.8000 (ADC control) offset 0x014
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0xF
	ldr r4, [r2, #0x014]
	bfi r4, r3, #4, #4
	mov r3, #0x0
	bfi r4, r3, #0, #4
	bfi r4, r3, #8, #4
	bfi r4, r3, #12, #4
	str r4, [r2, #0x014]

	; Configure GPIO pins to sample sequencer inputs @ 0x40038060
	; base 0x4003.8000 (ADC control) offset 0x060
	; pin D0 = 61, pin D1 = 62, pin D2 = 63, pin D3 = 64
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #4
	ldr r4, [r2, #0x060]
	bfi r4, r3, #0, #4
	mov r3, #5
	bfi r4, r3, #4, #4
	mov r3, #6
	bfi r4, r3, #8, #4
	mov r3, #7
	bfi r4, r3, #12, #4
	str r4, [r2, #0x060]

	; Configure all pins to be read from without interrupt and without differential control @ 0x40038064
	; Also set sample 4 as the last sample
	; base 0x4003.8000 (ADC control) offset 0x064
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0x2000
	ldr r4, [r2, #0x64]
	bfi r4, r3, #0, #16
	str r4, [r2, #0x64]

	; Send results of sequences to digital comparator @ 0x40038074
	; base 0x4003.8000 (ADC control) offset 0x074
	; Send result 0 to comparator 0, result 1 to comparator 1 ...
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0x10
	ldr r4, [r2, #0x074]
	mov r3, #0x32
	bfi r4, r3, #8, #8
	mov r3, #0x10
	bfi r4, r3, #0, #8
	str r4, [r2, #0x074]

	; Set up comparator 0 @ 40038E00
	; base 0x4003.8000 (ADC control) offset 0xE00
	; Disable trigger function, enable interrupt, and configure hysteresis once bottom trigger
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0x13
	ldr r4, [r2, #0xE00]
	bfi r4, r3, #0, #5
	mov r3, #0x00
	bfi r4, r3, #8, #5
	str r4, [r2, #0xE00]

	; Set up comparator 1 @ 40038E04
	; base 0x4003.8000 (ADC control) offset 0xE04
	; Disable trigger function, enable interrupt, and configure hysteresis once middle trigger
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0x13
	ldr r4, [r2, #0xE04]
	bfi r4, r3, #0, #5
	mov r3, #0x00
	bfi r4, r3, #8, #5
	str r4, [r2, #0xE04]

	; Set up comparator 2 @ 40038E08
	; base 0x4003.8000 (ADC control) offset 0xE08
	; Disable trigger function, enable interrupt, and configure hysteresis once middle trigger
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0x13
	ldr r4, [r2, #0xE08]
	bfi r4, r3, #0, #5
	mov r3, #0x00
	bfi r4, r3, #8, #5
	str r4, [r2, #0xE08]

	; Set up comparator 3 @ 40038E0C
	; base 0x4003.8000 (ADC control) offset 0xE0C
	; Disable trigger function, enable interrupt, and configure hysteresis once middle trigger
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0x13
	ldr r4, [r2, #0xE0C]
	bfi r4, r3, #0, #5
	mov r3, #0x00
	bfi r4, r3, #8, #5
	str r4, [r2, #0xE0C]

	; Set range for middle threshold of comparator 0 @ 40038E40
	; base 0x4003.8000 (ADC control) offset 0xE40
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0x8
	ldr r4, [r2, #0xE40]
	bfi r4, r3, #8, #4
	mov r3, #0x9
	bfi r4, r3, #24, #4
	str r4, [r2, #0xE40]

	; Set range for middle threshold of comparator 1 @ 40038E44
	; base 0x4003.8000 (ADC control) offset 0xE44
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0x8
	ldr r4, [r2, #0xE44]
	bfi r4, r3, #8, #4
	mov r3, #0x9
	bfi r4, r3, #24, #4
	str r4, [r2, #0xE44]

	; Set range for middle threshold of comparator 2 @ 40038E48
	; base 0x4003.8000 (ADC control) offset 0xE48
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0x8
	ldr r4, [r2, #0xE48]
	bfi r4, r3, #8, #4
	mov r3, #0x9
	bfi r4, r3, #24, #4
	str r4, [r2, #0xE48]

	; Set range for middle threshold of comparator 3 @ 40038E4C
	; base 0x4003.8000 (ADC control) offset 0xE4C
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0x8
	ldr r4, [r2, #0xE4C]
	bfi r4, r3, #8, #4
	mov r3, #0x9
	bfi r4, r3, #24, #4
	str r4, [r2, #0xE4C]

	; Move sample sequence values to digital comparator @ 40038070
	; base 0x4003.8000 (ADC control) offset 0x070
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0x3
	ldr r4, [r2, #0x070]
	bfi r4, r3, #0, #1
	bfi r4, r3, #4, #1
	bfi r4, r3, #8, #1
	bfi r4, r3, #12, #1
	str r4, [r2, #0x070]

	; Configure interrupts from comparator onto sequencer @ 40038008
	; base 0x4003.8000 (ADC control) offset 0x008
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0x0
	ldr r4, [r2, #0x008]
	bfi r4, r3, #1, #1
	mov r3, #0x1
	bfi r4, r3, #17, #1
	str r4, [r2, #0x008]

	; Reset comparator
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0xFF
	ldr r4, [r2, #0xD00]
	bfi r4, r3, #0, #8
	str r4, [r2, #0xD00]

	; Configure Processor to allow ADC to interrupt Processor
	mov r2, #0xE004
	movt r2, #0xE000
	mov r3, #0x1
	ldr r4, [r2, #0x100]
	bfi r4, r3, #17, #1
	str r4, [r2, #0x100]

	; Enable sample sequencer 1 @ 0x40038000
	; base 0x4003.8000 (ADC control) offset 0x0
	mov r2, #0x9000
	movt r2, #0x4003
	mov r3, #0x1
	ldrb r4, [r2, #0x0]
	bfi r4, r3, #1, #1
	strb r4, [r2, #0x0]

	POP{lr, r4-r10}
	MOV pc, lr
