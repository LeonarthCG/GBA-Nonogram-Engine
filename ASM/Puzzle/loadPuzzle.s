.thumb

push	{lr}
push	{r4-r7}
@r0 = puzzle data

mov	r4,r0
mov	r5,r1

ldrh	r6,[r4,#0]
ldrh	r7,[r4,#2]

@set width and height, reset cursor position
ldr	r0,=#0x02000160
mov	r1,#0
strb	r1,[r0]
strb	r1,[r0,#1]
strb	r6,[r0,#2]
strb	r7,[r0,#3]

ldr	r4,[r4,#4]
ldr	r5,=#0x02000000
loadLoop:
mov	r1,#0
everyRow:
mov	r2,#0
everyColumn:
ldrb	r0,[r4]
mov	r3,#1
and	r3,r2
cmp	r3,#0
beq	rightNibble
leftNibble:
lsr	r0,#4
b	afterNibble
rightNibble:
mov	r3,#0xF
and	r0,r3
b	afterNibble
afterNibble:
sub	r0,#1
strb	r0,[r5,r2]
mov	r3,#1
and	r3,r2
cmp	r3,#0
beq	nextColumn
add	r4,#1
nextColumn:
add	r2,#1
cmp	r2,r6
beq	nextRow
b	everyColumn
nextRow:
doneRow:
mov	r3,#1
and	r3,r2
cmp	r3,#0
beq	dontadd1
add	r4,#1
dontadd1:
ldrb	r3,[r4]
cmp	r3,#0
bne	dontadd2
add	r4,#1
b	dontadd1
dontadd2:
add	r5,#20
add	r1,#1
cmp	r1,r7
beq	End
b	everyRow

End:
pop	{r4-r7}
pop	{r0}
bx	r0
