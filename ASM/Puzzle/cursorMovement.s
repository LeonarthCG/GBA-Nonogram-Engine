.thumb
push	{lr}

mov	r0,#4
mov	r1,#6
mov	r2,#1
mov	r3,#0
bl	checkCursorMovement

mov	r0,#5
mov	r1,#6
mov	r2,#0
mov	r3,#0
bl	checkCursorMovement

mov	r0,#6
mov	r1,#6
mov	r2,#0
mov	r3,#1
bl	checkCursorMovement

mov	r0,#7
mov	r1,#6
mov	r2,#1
mov	r3,#1
bl	checkCursorMovement

End:
pop	{r0}
bx	r0

checkCursorMovement:
push	{lr}
push	{r4-r7}
mov	r4,r0
mov	r5,r1
mov	r6,r2
mov	r7,r3
mov	r0,r4
bl	checkPressed
cmp	r0,#0
bne	setDelay
mov	r0,r4
mov	r1,r5
bl	checkHeld
cmp	r0,#0
bne	checkIfDelayed
b	endCursorMovement
checkIfDelayed:
ldr	r0,=#0x02000130
lsl	r1,r4,#2
add	r1,#3
ldrb	r2,[r0,r1]
cmp	r2,#0xEA
blo	moveCursor
add	r2,#1
strb	r2,[r0,r1]
b	endCursorMovement
setDelay:
ldr	r0,=#0x02000130
lsl	r1,r4,#2
add	r1,#3
mov	r2,#0xEA
strb	r2,[r0,r1]
moveCursor:
mov	r0,r4
mov	r1,r5
mov	r2,r6
mov	r3,r7
cmp	r6,#0
bne	goIncreaseCursor
bl	decreaseCursor
b	endCursorMovement
goIncreaseCursor:
bl	increaseCursor
endCursorMovement:
pop	{r4-r7}
pop	{r0}
bx	r0

increaseCursor:
push	{lr}
push	{r4-r7}
mov	r4,r0
mov	r5,r1
mov	r6,r2
mov	r7,r3
ldr	r0,=#0x02000130
lsl	r1,r4,#2
add	r1,#3
ldrb	r2,[r0,r1]
cmp	r2,#0xEA
bhs	dontResetIncrease
mov	r2,#0
strb	r2,[r0,r1]
dontResetIncrease:
ldr	r0,=#0x02000160
add	r0,r7
ldrb	r1,[r0]
ldrb	r2,[r0,#2]
add	r1,#1
cmp	r1,r2
blo	increaseTile
mov	r1,#0
increaseTile:
strb	r1,[r0]
pop	{r4-r7}
pop	{r0}
bx	r0

decreaseCursor:
push	{lr}
push	{r4-r7}
mov	r4,r0
mov	r5,r1
mov	r6,r2
mov	r7,r3
ldr	r0,=#0x02000130
lsl	r1,r4,#2
add	r1,#3
ldrb	r2,[r0,r1]
cmp	r2,#0xEA
bhs	dontResetDecrease
mov	r2,#0
strb	r2,[r0,r1]
dontResetDecrease:
ldr	r0,=#0x02000160
add	r0,r7
ldrb	r1,[r0]
ldrb	r2,[r0,#2]
sub	r1,#1
cmp	r1,r2
blo	decreaseTile
mov	r1,r2
sub	r1,#1
decreaseTile:
strb	r1,[r0]
pop	{r4-r7}
pop	{r0}
bx	r0
