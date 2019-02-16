.thumb
push	{lr}
push	{r4-r7}
@check if there is a current action
ldr	r0,=#0x0200016E
ldrb	r1,[r0]
cmp	r1,#0
bne	End

@check if there is a new action
mov	r4,#0
mov	r5,#0
@check if both are pressed at the same time
mov	r0,#0
bl	checkPressed
orr	r4,r0
mov	r0,#0
mov	r1,#0
bl	checkHeld
orr	r4,r0
mov	r0,#1
bl	checkPressed
orr	r5,r0
mov	r0,#1
mov	r1,#0
bl	checkHeld
orr	r5,r0
add	r4,r5
cmp	r4,#1
bhi	End
cmp	r4,#0
beq	End

@otherwise we set the new action
mov	r4,#0
mov	r5,#0
@check if A is pressed
mov	r0,#0
bl	checkPressed
orr	r4,r0
mov	r0,#0
mov	r1,#0
bl	checkHeld
orr	r4,r0
cmp	r4,#0
bne	APressed
@check if B is pressed
mov	r0,#1
bl	checkPressed
orr	r5,r0
mov	r0,#1
mov	r1,#0
bl	checkHeld
orr	r5,r0
cmp	r5,#0
bne	BPressed

End:
pop	{r4-r7}
pop	{r0}
bx	r0

APressed:
ldr	r0,=#0x0200016E
ldr	r1,=#0x0200016C
ldrb	r1,[r1]
add	r1,#1
strb	r1,[r0,#1]
@check if hovering over anything, if so set erasing action
ldr	r0,=#0x02000160
ldrb	r1,[r0,#1]
ldrb	r0,[r0]
ldr	r2,=#0x02000A00
lsl	r0,#1
add	r2,r0
mov	r0,#40
mul	r1,r0
add	r0,r1,r2
ldrb	r0,[r0]
cmp	r0,#0
beq	notEraseA
ldr	r0,=#0x0200016E
mov	r1,#3
strb	r1,[r0]
b	End
notEraseA:
ldr	r0,=#0x0200016E
mov	r1,#1
strb	r1,[r0]
b	End

BPressed:
ldr	r0,=#0x0200016E
ldr	r1,=#0x0200016C
ldrb	r1,[r1]
add	r1,#1
strb	r1,[r0,#1]
@check if hovering over anything, if so set erasing action
ldr	r0,=#0x02000160
ldrb	r1,[r0,#1]
ldrb	r0,[r0]
ldr	r2,=#0x02000A00
lsl	r0,#1
add	r2,r0
mov	r0,#40
mul	r1,r0
add	r0,r1,r2
ldrb	r0,[r0]
cmp	r0,#0
beq	notEraseB
ldr	r0,=#0x0200016E
mov	r1,#3
strb	r1,[r0]
b	End
notEraseB:
ldr	r0,=#0x0200016E
mov	r1,#2
strb	r1,[r0]
b	End
