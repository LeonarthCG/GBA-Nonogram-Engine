.arm
ldr	r0,=toThumb
add	r0,#1
bx	r0

.thumb

toThumb:
push	{r4}
push	{lr}
@check what type of interrupt we got
ldr	r0,=#0x04000200
ldrh	r4,[r0,#2]
mov	r0,#1
and	r0,r4
cmp	r0,#1
bne	notvblank
bl	wasvblank
notvblank:
mov	r0,#0x8
and	r0,r4
cmp	r0,#0x8
bne	notcounter0
bl	wascounter0
notcounter0:
mov	r0,#0x10
and	r0,r4
cmp	r0,#0x10
bne	notcounter1
bl	wascounter1
notcounter1:
mov	r0,#0x20
and	r0,r4
cmp	r0,#0x20
bne	notcounter2
bl	wascounter2
notcounter2:
mov	r0,#0x40
and	r0,r4
cmp	r0,#0x40
bne	notcounter3
bl	wascounter3
notcounter3:
b	End

wascounter0:
wascounter1:
wascounter2:
b	End

wascounter3:
@mark the interrupt
mov	r0,#0x40
ldr	r1,=#0x04000200		@mark the bit for the interrupt
strh	r0,[r1,#2]
ldr	r1,=#0x03007FF8		@mark the bit for the interrupt
strh	r0,[r1]
@increase the second counter
ldr	r0,=#0x02000160
ldr	r1,[r0,#4]
add	r1,#1
str	r1,[r0,#4]
b	End

@if vblank, just acknowledge and return
wasvblank:
push	{r4-r7}
mov	r0,#1
ldr	r1,=#0x04000200		@mark the bit for the interrupt
strh	r0,[r1,#2]
ldr	r1,=#0x03007FF8		@mark the bit for the interrupt
strh	r0,[r1]
@increase timer
ldr	r0,=#0x02000164
ldr	r1,[r0,#4]
mov	r2,#1
and	r1,r2
cmp	r1,#1
bne	noTimer
ldr	r1,[r0]
add	r1,#1
str	r1,[r0]
noTimer:
@set DMA for bg buffers
ldr	r0,=#0x40000D4
ldr	r1,=bgTilemapsBuffer
ldr	r1,[r1]
str	r1,[r0]
ldr	r1,=#0x600E000
str	r1,[r0,#4]
ldr	r1,=#0x800
strh	r1,[r0,#8]
ldr	r1,=#0x8400
strh	r1,[r0,#10]
@grab button inputs
ldr	r4,=#0x4000130
ldrh	r4,[r4]
mov	r5,#1
lsl	r5,#9
mov	r6,#1
ldr	r7,=#0x02000130
keyInputLoop:
mov	r0,r6
and	r0,r4
cmp	r0,#0
bne	notCurrentlyPressed
@check if it was pressed last frame
ldrb	r0,[r7]
ldrb	r1,[r7,#1]
orr	r0,r1
cmp	r0,#0
beq	wasNotHeld
mov	r0,#0
strb	r0,[r7]
mov	r0,#1
strb	r0,[r7,#1]
ldrb	r0,[r7,#3]
cmp	r0,#0xFF
bhs	wasMaxed
add	r0,#1
wasMaxed:
strb	r0,[r7,#3]
b	nextKey
wasNotHeld:
@mark as pressed this frame
mov	r0,#1
strb	r0,[r7]
b	nextKey
notCurrentlyPressed:
@check if it was pressed last frame
ldrb	r0,[r7]
ldrb	r1,[r7,#1]
orr	r0,r1
cmp	r0,#0
beq	notReleased
@set released
mov	r0,#1
strb	r0,[r7,#2]
mov	r0,#0
@reset everything else
strb	r0,[r7]
strb	r0,[r7,#1]
strb	r0,[r7,#3]
b	nextKey
notReleased:
mov	r0,#0
str	r0,[r7]
nextKey:
add	r7,#4
lsl	r6,#1
cmp	r6,r5
bls	keyInputLoop
pop	{r4-r7}
b	End

End:
pop	{r0,r4}
bx	r0
