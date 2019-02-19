.thumb
push	{lr}
push	{r4-r7}
@r0 = puzzle data
mov	r4,r1
ldr	r5,=#0x02000600
mov	r7,r0

@get hints for every column
mov	r6,#0
everyColumn:
mov	r0,r4
mov	r1,r5
mov	r2,r6
mov	r3,r7
bl	getColumnHints
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
bl	getRowHints
add	r6,#1
ldrh	r0,[r7,#2]
cmp	r6,r0
bhs	everyRowStop
b	everyRow
everyRowStop:

pop	{r4-r7}
pop	{r0}
bx	r0

getColumnHints:
push	{r4-r7}
@get source
mov	r4,r0
add	r4,r2		@+ row number*2
add	r4,r2
@get destination
mov	r5,r1
mov	r3,#20		@+20 for every column checked
mul	r3,r2
add	r5,r3
@now we can check every color on this column
mov	r6,#0		@current color index
mov	r7,#0		@size of hint
ldrb	r1,[r4]
cmp	r1,#1
beq	isSquareColumn1
mov	r1,#0
b	notSquareColumn1
isSquareColumn1:
ldrb	r1,[r4,#1]
notSquareColumn1:
everyColorColumn:
ldrb	r0,[r4]
cmp	r0,#1
beq	isSquareColumn2
mov	r0,#0
b	notSquareColumn2
isSquareColumn2:
ldrb	r0,[r4,#1]
notSquareColumn2:
cmp	r0,r1
beq	sameColorColumn
b	differentColorColumn
sameColorColumn:
cmp	r0,#0
beq	nextColorColumn
add	r7,#1
b	nextColorColumn
differentColorColumn:
cmp	r1,#0
beq	notHintColumn
strb	r7,[r5]
strb	r1,[r5,#1]
mov	r1,r0
add	r5,#2
mov	r7,#1
b	nextColorColumn
notHintColumn:
mov	r1,r0
mov	r7,#1
b	nextColorColumn
nextColorColumn:
add	r6,#2
add	r4,#40
cmp	r6,#40
beq	endColumnHints
b	everyColorColumn
endColumnHints:
@check if there is one last hint
cmp	r1,#0
beq	notLastHintColumn
strb	r7,[r5]
strb	r1,[r5,#1]
notLastHintColumn:
pop	{r4-r7}
bx	lr

getRowHints:
push	{r4-r7}
@get source
mov	r4,r0
mov	r3,#40		@+40 for every row checked
mul	r3,r2
add	r4,r3
@get destination
mov	r5,r1
ldr	r3,=#0x200
add	r5,r3		@+0x200 because rows are after columns
mov	r3,#20		@+20 for every row checked
mul	r3,r2
add	r5,r3
@now we can check every color on this row
mov	r6,#0		@current color index
mov	r7,#0		@size of hint
ldrb	r1,[r4,r6]
cmp	r1,#1
beq	isSquareRow1
mov	r1,#0
b	notSquareRow1
isSquareRow1:
mov	r1,r6
add	r1,#1
ldrb	r1,[r4,r1]
notSquareRow1:
everyColorRow:
ldrb	r0,[r4,r6]
cmp	r0,#1
beq	isSquareRow2
mov	r0,#0
b	notSquareRow2
isSquareRow2:
mov	r0,r6
add	r0,#1
ldrb	r0,[r4,r0]
notSquareRow2:
cmp	r0,r1
beq	sameColorRow
b	differentColorRow
sameColorRow:
cmp	r0,#0
beq	nextColorRow
add	r7,#1
b	nextColorRow
differentColorRow:
cmp	r1,#0
beq	notHintRow
strb	r7,[r5]
strb	r1,[r5,#1]
mov	r1,r0
add	r5,#2
mov	r7,#1
b	nextColorRow
notHintRow:
mov	r1,r0
mov	r7,#1
b	nextColorRow
nextColorRow:
add	r6,#2
cmp	r6,#40
beq	endRowHints
b	everyColorRow
endRowHints:
@check if there is one last hint
cmp	r1,#0
beq	notLastHintRow
strb	r7,[r5]
strb	r1,[r5,#1]
notLastHintRow:
pop	{r4-r7}
bx	lr
