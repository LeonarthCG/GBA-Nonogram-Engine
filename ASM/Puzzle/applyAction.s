.thumb
push	{lr}
push	{r4-r7}

ldr	r0,=#0x0200016E
ldrb	r4,[r0]			@action
ldrb	r5,[r0,#1]		@action color
cmp	r4,#0
beq	End

ldr	r0,=#0x02000160
ldrb	r1,[r0,#1]
ldrb	r0,[r0]
ldr	r2,=#0x02000A00
lsl	r0,#1
add	r2,r0
mov	r0,#40
mul	r1,r0
add	r6,r1,r2		@current tile data

cmp	r4,#1
beq	placeSquare

cmp	r4,#2
beq	placeCross

cmp	r4,#3
beq	erase

End:
pop	{r4-r7}
pop	{r0}
bx	r0

placeSquare:
ldrb	r0,[r6]
cmp	r0,#0
bne	End
strb	r4,[r6]
strb	r5,[r6,#1]
b	End

placeCross:
ldrb	r0,[r6]
cmp	r0,#0
bne	End
strb	r4,[r6]
mov	r0,#0xFF
strb	r0,[r6,#1]
b	End

erase:
mov	r0,#0
strb	r0,[r6]
strb	r0,[r6,#1]
b	End
