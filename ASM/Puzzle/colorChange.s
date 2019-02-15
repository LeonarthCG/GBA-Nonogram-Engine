.thumb
push	{lr}
push	{r4-r7}
mov	r4,#0
mov	r5,#0
@check if both are pressed at the same time
mov	r0,#8
bl	checkPressed
orr	r4,r0
mov	r0,#8
mov	r1,#0
bl	checkHeld
orr	r4,r0
mov	r0,#9
bl	checkPressed
orr	r5,r0
mov	r0,#9
mov	r1,#0
bl	checkHeld
orr	r5,r0
add	r4,r5
cmp	r4,#1
bhi	conflict

mov	r0,#8
bl	checkPressed
cmp	r0,#0
bne	increaseColor

mov	r0,#9
bl	checkPressed
cmp	r0,#0
bne	decreaseColor

mov	r0,#8
mov	r1,#18
bl	checkHeld
cmp	r0,#0
bne	increaseColorAndReset

mov	r0,#9
mov	r1,#18
bl	checkHeld
cmp	r0,#0
bne	decreaseColorAndReset

End:
pop	{r4-r7}
pop	{r0}
bx	r0

conflict:
ldr	r0,=#0x02000150
mov	r1,#0
strb	r1,[r0,#3]
strb	r1,[r0,#7]
b	End

increaseColorAndReset:
ldr	r0,=#0x02000150
mov	r1,#0
strb	r1,[r0,#3]
increaseColor:
ldr	r0,=#0x0200016C
ldrb	r1,[r0]
ldrb	r2,[r0,#1]
add	r1,#1
cmp	r1,r2
blo	storeColor
mov	r1,#0
b	storeColor

decreaseColorAndReset:
ldr	r0,=#0x02000150
mov	r1,#0
strb	r1,[r0,#7]
decreaseColor:
ldr	r0,=#0x0200016C
ldrb	r1,[r0]
ldrb	r2,[r0,#1]
cmp	r1,#0
bhi	newColor
mov	r1,r2
sub	r1,#1
b	storeColor
newColor:
sub	r1,#1

storeColor:
strb	r1,[r0]
b	End
