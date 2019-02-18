.thumb
push	{lr}
push	{r4-r7}
@r0 = puzzle data
@r1 = reformatted puzzle
@r2 = place to write hints to

mov	r4,r1
mov	r7,r0

ldr	r0,=bgTilemapsBuffer
ldr	r0,[r0]
mov	r1,r0
mov	r3,#0xFF
findTileLoop:
ldrh	r2,[r1]
and	r2,r3
cmp	r2,#5
beq	stopTileLoop
add	r1,#2
bne	findTileLoop
stopTileLoop:
sub	r1,r0
ldr	r2,=bgTilemapsBuffer
ldr	r2,[r2,#4]
add	r5,r2,r1

@get hints for every column
mov	r6,#0
everyColumn:
mov	r0,r4
mov	r1,r5
mov	r2,r6
mov	r3,r7
bl	drawColumnHints
add	r6,#1
ldrh	r0,[r7,#0]
cmp	r6,r0
bhs	everyColumnStop
b	everyColumn
everyColumnStop:

@get hints for every row
mov	r6,#0
everyRow:
mov	r0,r4
mov	r1,r5
mov	r2,r6
mov	r3,r7
bl	drawRowHints
add	r6,#1
ldrh	r0,[r7,#2]
cmp	r6,r0
bhs	everyRowStop
b	everyRow
everyRowStop:

End:
pop	{r4-r7}
pop	{r0}
bx	r0

drawColumnHints:
push	{r4-r7}
@get source
mov	r4,r0
mov	r3,#20		@+20 for every column checked
mul	r3,r2
add	r4,r3
@get destination
mov	r5,r1
lsl	r3,r2,#1	@+2 for every column checked
add	r5,r3
@check how many hints there are
mov	r6,#0
mov	r7,#0
columnAmmount:
ldrb	r0,[r4,r6]
cmp	r0,#0
beq	doneColumnAmmount
add	r7,#1
add	r6,#2
cmp	r6,#40
bhs	doneColumnAmmount
b	columnAmmount
doneColumnAmmount:
cmp	r7,#0
beq	drawColumn0
mov	r0,#0x40
mul	r0,r7
sub	r5,r0
mov	r6,#0
drawEveryColumnHint:
ldrb	r0,[r4,r6]
add	r6,#1
ldrb	r1,[r4,r6]
add	r6,#1
mov	r2,#0x30
mul	r1,r2
ldr	r2,=#0x101F
add	r1,r2
add	r0,r1
strh	r0,[r5]
sub	r7,#1
cmp	r7,#0
beq	endColumnDraw
add	r5,#0x40
b	drawEveryColumnHint
drawColumn0:
sub	r5,#0x40
ldr	r1,=#0x107D
strh	r1,[r5]
b	endColumnDraw
endColumnDraw:
pop	{r4-r7}
bx	lr

drawRowHints:
push	{r4-r7}
@get source
mov	r4,r0
ldr	r3,=#0x200
add	r4,r3
mov	r3,#20		@+20 for every row checked
mul	r3,r2
add	r4,r3
@get destination
mov	r5,r1
mov	r3,#0x40	@+0x40 for every row checked
mul	r3,r2
add	r5,r3
@check how many hints there are
mov	r6,#0
mov	r7,#0
rowAmmount:
ldrb	r0,[r4,r6]
cmp	r0,#0
beq	doneRowAmmount
add	r7,#1
add	r6,#2
cmp	r6,#40
bhs	doneRowAmmount
b	rowAmmount
doneRowAmmount:
cmp	r7,#0
beq	drawRow0
lsl	r0,r7,#1
sub	r5,r0
mov	r6,#0
drawEveryRowHint:
ldrb	r0,[r4,r6]
add	r6,#1
ldrb	r1,[r4,r6]
add	r6,#1
mov	r2,#0x30
mul	r1,r2
ldr	r2,=#0x101F
add	r1,r2
add	r0,r1
strh	r0,[r5]
sub	r7,#1
cmp	r7,#0
beq	endRowDraw
add	r5,#2
b	drawEveryRowHint
drawRow0:
sub	r5,#2
ldr	r1,=#0x107D
strh	r1,[r5]
b	endRowDraw
endRowDraw:
pop	{r4-r7}
bx	lr
