.thumb
push	{lr}
push	{r4-r7}
@r0 = puzzle data
@r1 = hints

mov	r4,r1
mov	r7,r0

ldr	r0,=bgTilemapsBuffer
ldr	r0,[r0]
mov	r1,r0
mov	r3,#0xFF
findTileLoop:
ldrh	r2,[r1]
and	r2,r3
cmp	r2,#0x12
beq	stopTileLoop
add	r1,#2
bne	findTileLoop
stopTileLoop:
sub	r1,r0
ldr	r2,=bgTilemapsBuffer
ldr	r2,[r2,#4]
add	r5,r2,r1
sub	r5,#0x40

@check how many colors there are, if only one then we draw nothing
mov	r1,r4
mov	r6,#0
mov	r2,#0
colorsLoop:
ldrb	r0,[r1,#1]
cmp	r0,r6
blo	nextColorsLoop
mov	r6,r0
nextColorsLoop:
add	r1,#2
add	r2,#1
cmp	r2,#20
bhs	doneColors
b	colorsLoop
doneColors:
ldr	r0,=#0x0200016C
strb	r6,[r0,#1]
cmp	r6,#1
bls	End

@draw L and R
mov	r4,r5
mov	r7,r6
ldr	r0,=bgTilemapsBuffer
ldr	r0,[r0,#4]
sub	r4,r0
ldr	r0,=bgTilemapsBuffer
ldr	r0,[r0]
add	r4,r0
ldr	r0,=#0x201C
strh	r0,[r4]
add	r4,#2
lsl	r1,r7,#1
ldrh	r0,[r4,r1]
mov	r3,#0xFF
and	r0,r3
cmp	r0,#0x11
beq	borderR
ldr	r0,=#0x201E
b	storeR
borderR:
ldr	r0,=#0x201B
storeR:
strh	r0,[r4,r1]
@draw the background squares the colors go in
mov	r3,#0
ldr	r0,=#0x0200016C
ldrb	r2,[r0]
drawColorTilesLoop:
ldr	r0,=#0x201D
cmp	r2,r3
bne	notCurrentColorTiles
add	r0,#2
notCurrentColorTiles:
strh	r0,[r4]
add	r4,#2
add	r3,#1
sub	r7,#1
cmp	r7,#0
bne	drawColorTilesLoop

@draw the colors
ldr	r0,=#0x0200016C
mov	r4,#0
ldrb	r7,[r0]
drawColorSquaresLoop:
add	r5,#2
ldr	r0,=#0x1064
mov	r1,r4
mov	r2,#0x30
mul	r1,r2
add	r0,r1
cmp	r4,r7
bne	notCurrentColorSquares
add	r0,#1
notCurrentColorSquares:
strh	r0,[r5]
add	r4,#1
sub	r6,#1
cmp	r6,#0
bne	drawColorSquaresLoop

End:
pop	{r4-r7}
pop	{r0}
bx	r0
