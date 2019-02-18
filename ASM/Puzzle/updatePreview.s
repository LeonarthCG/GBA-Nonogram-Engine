.thumb
push	{lr}
push	{r4-r7}

@check if no action
ldr	r0,=#0x02000160
ldrb	r1,[r0,#0xE]
cmp	r1,#0
beq	End

@check if cross
cmp	r1,#2
beq	End

@get x
ldr	r3,=#0x02000160
ldrb	r0,[r3]
lsl	r0,#1
@center it
mov	r1,#20
ldrb	r2,[r3,#2]
sub	r1,r2
add	r4,r0,r1
add	r4,#4

@get y
ldrb	r1,[r3,#1]
lsl	r1,#1
@center it
mov	r2,#15
ldrb	r3,[r3,#3]
sub	r2,r3
add	r5,r1,r2
add	r5,#1

bl	paintPixel

add	r4,#1
bl	paintPixel

sub	r4,#1
add	r5,#1
bl	paintPixel

add	r4,#1
bl	paintPixel

End:
pop	{r4-r7}
pop	{r0}
bx	r0

paintPixel:
@get the offset
ldr	r7,=#0x06002200
@first find out what tile column we are one
mov	r0,r4
mov	r1,#8
swi	#6
@add the offset
lsl	r0,#5
lsr	r1,#1
add	r0,r1
add	r7,r0
@now same for y
mov	r0,r5
mov	r1,#8
swi	#6
@add the offset
mov	r2,#0xC0
mul	r0,r2
lsl	r1,#3
lsr	r1,#1
add	r0,r1
add	r7,r0
lsr	r7,#1
lsl	r7,#1

@get the color
mov	r6,#1
@check if painting or erasing
ldr	r0,=#0x02000160
ldrb	r1,[r0,#0xE]
cmp	r1,#3
beq	gotColor
ldrb	r6,[r0,#0xF]
add	r6,#1
gotColor:

@paint the pixel
mov	r2,#3
and	r2,r4
lsl	r2,#2
mov	r1,#0xF
lsl	r1,r2
mvn	r1,r1
ldrh	r0,[r7]
and	r0,r1
mov	r1,r6
lsl	r1,r2
orr	r0,r1
strh	r0,[r7]
bx	lr

