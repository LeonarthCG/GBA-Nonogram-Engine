.thumb
push	{lr}
push	{r4-r7}

mov	r4,r0
ldrh	r6,[r4,#0]
ldrh	r7,[r4,#2]

@erase any extra columns
mov	r5,#20
columnsLoop:
cmp	r5,r6
blo	columnsLoopEnd
mov	r0,r5
bl	eraseColumn
sub	r5,#1
b	columnsLoop
columnsLoopEnd:

@erase any extra rows
mov	r5,#15
rowsLoop:
cmp	r5,r7
blo	rowsLoopEnd
mov	r0,r5
bl	eraseRow
sub	r5,#1
b	rowsLoop
rowsLoopEnd:

@add a border to the right
mov	r0,r6
bl	addBorderColumn

@add a border to the left
mov	r0,r7
bl	addBorderRow

shiftBackground:
@move the background
shifSideLoopNext:
cmp	r6,#10
bls	shifSideLoopDone
cmp	r6,#15
blo	noissueside
mov	r0,r6
mov	r6,#15
sub	r0,#15
sub	r6,r0
cmp	r6,#10
bls	shifSideLoopDone
noissueside:
ldr	r5,=bgTilemapsBuffer
ldr	r5,[r5]
ldr	r0,=#0x800
add	r5,r0
mov	r4,r5
sub	r4,#2
mov	r1,#0
ldr	r3,=#0x400
shifSideLoop:
ldrh	r0,[r4]
cmp	r0,#0
bne	noextendside
extendside:
ldrh	r0,[r5]
cmp	r0,#3
beq	noextendside
cmp	r0,#11
beq	noextendside
cmp	r0,#23
beq	noextendside
mov	r0,#0
noextendside:
strh	r0,[r5]
sub	r4,#2
sub	r5,#2
add	r1,#1
cmp	r1,r3
blo	shifSideLoop
sub	r6,#1
b	shifSideLoopNext
shifSideLoopDone:

shifDownLoopNext:
cmp	r7,#5
bls	End
cmp	r7,#10
blo	noissuedown
mov	r0,r7
mov	r7,#10
sub	r0,#10
sub	r7,r0
cmp	r7,#5
bls	End
noissuedown:
ldr	r5,=bgTilemapsBuffer
ldr	r5,[r5]
ldr	r0,=#0x800
add	r5,r0
mov	r4,r5
sub	r4,#0x40
mov	r1,#0
ldr	r3,=#0x400
ldr	r2,=bgTilemapsBuffer
ldr	r2,[r2]
add	r2,#0x80
shifDownLoop:
ldrh	r0,[r4]
cmp	r0,#0
bne	noextenddown
cmp	r4,r2
bhi	noextenddown
ldrh	r0,[r5]
cmp	r0,#0x11
bls	noextenddown
mov	r0,#0
noextenddown:
strh	r0,[r5]
sub	r4,#2
sub	r5,#2
add	r1,#1
cmp	r1,r3
blo	shifDownLoop
sub	r7,#1
b	shifDownLoopNext

End:
pop	{r4-r7}
pop	{r0}
bx	r0

eraseRow:
add	r0,#5
ldr	r3,=bgTilemapsBuffer
ldr	r3,[r3]
mov	r2,#0x40
mul	r0,r2
add	r0,r3
mov	r1,#0
mov	r2,#0
eraseRowLoop:
strh	r1,[r0]
add	r0,#2
add	r2,#1
cmp	r2,#0x1F
bhi	eraseRowEnd
b	eraseRowLoop
eraseRowEnd:
bx	lr

eraseColumn:
add	r0,#10
ldr	r3,=bgTilemapsBuffer
ldr	r3,[r3]
lsl	r0,#1
add	r0,r3
mov	r1,#0
mov	r2,#0
eraseColumnLoop:
strh	r1,[r0]
add	r0,#0x40
add	r2,#1
cmp	r2,#0x13
bhi	eraseColumnEnd
b	eraseColumnLoop
eraseColumnEnd:
bx	lr

addBorderRow:
add	r0,#4
ldr	r3,=bgTilemapsBuffer
ldr	r3,[r3]
mov	r2,#0x40
mul	r0,r2
add	r0,r3
mov	r2,#0
addBorderRowLoop:
ldrh	r1,[r0]
mov	r3,#0xF
and	r1,r3
cmp	r1,#0x5
beq	addBorderRowIncrease
cmp	r1,#0x7
beq	addBorderRowIncrease
cmp	r1,#0xD
beq	addBorderRowIncrease
cmp	r1,#0xF
beq	addBorderRowIncrease
b	addBorderRowNext
addBorderRowIncrease:
ldrh	r1,[r0]
add	r1,#1
strh	r1,[r0]
addBorderRowNext:
add	r0,#2
add	r2,#1
cmp	r2,#0x1F
bhi	addBorderRowEnd
b	addBorderRowLoop
addBorderRowEnd:
bx	lr

addBorderColumn:
add	r0,#9
ldr	r3,=bgTilemapsBuffer
ldr	r3,[r3]
lsl	r0,#1
add	r0,r3
mov	r2,#0
addBorderColumnLoop:
ldrh	r1,[r0]
mov	r3,#0xF
and	r1,r3
cmp	r1,#0x5
beq	addBorderColumnIncrease
cmp	r1,#0x7
beq	addBorderColumnNext
cmp	r1,#0xD
beq	addBorderColumnIncrease
cmp	r1,#0xF
beq	addBorderColumnNext
cmp	r1,#0x6
beq	addBorderColumnIncrease
cmp	r1,#0xE
beq	addBorderColumnIncrease
b	addBorderColumnNext
addBorderColumnIncrease:
ldrh	r1,[r0]
add	r1,#2
strh	r1,[r0]
addBorderColumnNext:
add	r0,#0x40
add	r2,#1
cmp	r2,#0x13
bhi	addBorderColumnEnd
b	addBorderColumnLoop
addBorderColumnEnd:
bx	lr
