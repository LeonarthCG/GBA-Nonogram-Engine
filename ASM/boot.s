.arm
ldr	r0,=toThumb
add	r0,#1
bx	r0

.thumb

toThumb:
ldr	r0,=#0x04000200
mov	r1,#1
strb	r1,[r0,#8]	@set Master Interrupt Control to 1, enabling interrupts

ldr	r0,=#0x04000200
mov	r1,#0x59
strh	r1,[r0]		@set first bit of REG_IE (enable irq v-blank), third and fourth for timer 0 and 1 overflow, sixth for timer 3

ldr	r0,=#0x04000004
mov	r2,#8
strh	r2,[r0]		@set 3rd bit of DISPSTAT (enable irq v-blank)

ldr	r0,=#0x03007FFC
ldr	r1,=interrupt
str	r1,[r0]		@set the interrupt routine

ldr	r0,=#0x04000050
mov	r1,#0xFF
strb	r1,[r0]
mov	r1,#0x1F
strb	r1,[r0,#4]	@start with a black screen

@turn on bg layers
ldr	r0,=#0x04000000
ldr	r1,=#0x1F40
strh	r1,[r0]
	
@set the offset for the bg map
ldr	r1,=#0x1C02
strh	r1,[r0,#8]	@set the offset for the bg map 0
ldr	r1,=#0x1D01
strh	r1,[r0,#10]	@set the offset for the bg map 1
ldr	r1,=#0x1E01
strh	r1,[r0,#12]	@set the offset for the bg map 2
ldr	r1,=#0x1F0B
strh	r1,[r0,#14]	@set the offset for the bg map 3

@prepare seconds timer (timer 3)
ldr	r0,=#0x04000100
ldr	r1,=#-0x4000
strh	r1,[r0,#0xC]
mov	r1,#0xC3
strh	r1,[r0,#0xE]

bl	testPuzzle
