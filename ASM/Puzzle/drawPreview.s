.thumb
push	{lr}
push	{r4-r7}

@find tile
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
add	r4,r2,r1

@draw it
ldr	r5,=#0x1110
mov	r6,#0
loop:
strh	r5,[r4]
add	r5,#1
strh	r5,[r4,#2]
add	r5,#1
strh	r5,[r4,#4]
add	r5,#1
strh	r5,[r4,#6]
add	r5,#1
strh	r5,[r4,#8]
add	r5,#1
strh	r5,[r4,#10]
add	r5,#1
add	r4,#0x40
add	r6,#1
cmp	r6,#4
blo	loop

End:
pop	{r4-r7}
pop	{r0}
bx	r0
