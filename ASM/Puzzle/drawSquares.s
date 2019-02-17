.thumb
push	{lr}
push	{r4-r7}

@find the top-left tile of the grid
ldr	r0,=bgTilemapsBuffer
ldr	r0,[r0]
mov	r1,r0
findTileLoop:
ldrh	r2,[r1]
cmp	r2,#5
beq	stopTileLoop
add	r1,#2
bne	findTileLoop
stopTileLoop:
sub	r1,r0
ldr	r2,=bgTilemapsBuffer
ldr	r2,[r2,#4]
add	r6,r2,r1

@for every tile, check what we want it to be, then check what it currently is
@if they match do nothing, otherwise either move more towards empty square or towards target
mov	r0,r6
mov	r2,r6
mov	r5,#0
mov	r6,#0
ldr	r7,=#0x02000A00
mov	r3,r7
checkEveryTile:
push	{r2-r3}

@check if it is empty and should be empty
ldrh	r4,[r0]
ldrb	r1,[r7]
cmp	r4,r1
beq	nextTile

@check if we want to empty it
cmp	r1,#0
bne	dontErase
bl	eraseTile
dontErase:

@check if square
cmp	r1,#1
bne	notSquare
bl	doSquare
notSquare:

@check if cross
cmp	r1,#2
bne	notCross
bl	doCross
notCross:

nextTile:
pop	{r2-r3}
push	{r2-r3}
mov	r7,r3
ldr	r3,=#0x02000160
ldrb	r1,[r3,#2]
ldrb	r3,[r3,#3]
add	r5,#1
cmp	r5,r1
blo	notNextRow
mov	r5,#0
add	r6,#1
cmp	r6,r3
bhs	EndPop
notNextRow:
mov	r0,r2
lsl	r1,r5,#1
add	r0,r1
add	r7,r1
mov	r1,#0x40
mul	r1,r6
add	r0,r1
mov	r1,#40
mul	r1,r6
add	r7,r1
ldr	r2,=#0x2000B2C
pop	{r2-r3}
cmp	r7,r2
bne	checkEveryTile

End:
pop	{r4-r7}
pop	{r0}
bx	r0

EndPop:
pop	{r2-r3}
b	End

doCross:
@might add crosses of diferent colors in the future
mov	r1,#0xAF
cmp	r4,r1
beq	stopCross
cmp	r4,#0
bne	increaseCross
mov	r4,#0xAC
b	storeCross
increaseCross:
add	r4,#1
storeCross:
strh	r4,[r0]
stopCross:
bx	lr

doSquare:
ldr	r1,=#0x1027
ldr	r2,=#0x1050
stopSquareLoop:
cmp	r4,r1
beq	stopSquare
add	r1,#12
cmp	r1,r2
bhs	beginSquare
b	stopSquareLoop
beginSquare:
cmp	r4,#0
bne	increaseSquare
ldr	r4,=#0x1018
ldr	r1,=#0x0200016E
ldrb	r1,[r1,#1]
mov	r2,#12
mul	r1,r2
add	r4,r1
b	storeSquare
increaseSquare:
add	r4,#1
storeSquare:
strh	r4,[r0]
stopSquare:
bx	lr

eraseTile:
mov	r1,#0xAC
cmp	r4,r1
beq	blankTile
ldr	r1,=#0x1020
ldr	r2,=#0x1050
eraseLoop:
cmp	r4,r1
beq	blankTile
add	r1,#4
cmp	r1,r2
bhs	decreaseTile
b	eraseLoop
decreaseTile:
sub	r4,#1
b	storeErase
blankTile:
mov	r4,#0
strh	r4,[r0]
storeErase:
strh	r4,[r0]
stopErase:
bx	lr
