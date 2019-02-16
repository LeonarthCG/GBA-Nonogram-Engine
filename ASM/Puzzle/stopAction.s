.thumb
push	{lr}
push	{r4-r7}
ldr	r0,=#0x0200016E
ldrb	r1,[r0]
cmp	r1,#0
bne	checkIfStop

End:
pop	{r4-r7}
pop	{r0}
bx	r0

checkIfStop:
cmp	r1,#1
bne	checkIfX
ldr	r1,=#0x02000130
ldrb	r1,[r1,#2]
cmp	r1,#0
beq	End
mov	r1,#0
strb	r1,[r0]
strb	r1,[r0,#1]
b	End
checkIfX:
cmp	r1,#2
bne	checkIfErase
ldr	r1,=#0x02000130
ldrb	r1,[r1,#6]
cmp	r1,#0
beq	End
mov	r1,#0
strb	r1,[r0]
strb	r1,[r0,#1]
b	End
checkIfErase:
ldr	r1,=#0x02000130
ldrb	r2,[r1,#2]
ldrb	r1,[r1,#6]
orr	r1,r2
cmp	r1,#0
beq	End
mov	r1,#0
strb	r1,[r0]
strb	r1,[r0,#1]
b	End
