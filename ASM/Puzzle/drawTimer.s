.thumb
push	{lr}
push	{r4-r7}

@get seconds
ldr	r7,=#0x02000160
ldr	r7,[r7,#4]

@find the top-left tile of the grid
ldr	r0,=bgTilemapsBuffer
ldr	r4,[r0]
mov	r6,r4
ldr	r5,[r0,#4]
findTileLoop:
ldrh	r2,[r4]
cmp	r2,#0x12
beq	stopTileLoop
add	r4,#2
bne	findTileLoop
stopTileLoop:
sub	r4,#8
sub	r6,r4,r6
add	r5,r6

@draw Time
ldr	r0,=#0x14A
strh	r0,[r4]
add	r0,#1
strh	r0,[r4,#2]
add	r0,#1
strh	r0,[r4,#4]
add	r0,#1
strh	r0,[r4,#6]
add	r0,#1
add	r4,#0x40
sub	r0,#4
add	r0,#0x20
strh	r0,[r4]
add	r0,#1
strh	r0,[r4,#2]
add	r0,#1
strh	r0,[r4,#4]
add	r0,#1
strh	r0,[r4,#6]
add	r0,#1
add	r4,#0x40

@check if seconds are odd or even
mov	r1,#1
and	r1,r7
cmp	r1,#0
bne	odd

@draw the ":"
even:
add	r5,#0x82
ldr	r0,=#0x14E
strh	r0,[r5]
add	r0,#1
strh	r0,[r5,#2]
add	r0,#0x1F
mov	r2,#0x40
strh	r0,[r5,r2]
add	r0,#1
mov	r2,#0x42
strh	r0,[r5,r2]
b	afterdots

@erase the ":"
odd:
add	r5,#0x82
mov	r0,#0
strh	r0,[r5]
strh	r0,[r5,#2]
mov	r2,#0x40
strh	r0,[r5,r2]
add	r2,#2
strh	r0,[r5,r2]
b	afterdots

@draw the time
afterdots:
ldr	r0,=#3600
ldr	r5,=#0x140
ldr	r6,=#0x160
cmp	r7,r0
blo	notMaxed
mov	r7,r0
notMaxed:
@draw minute 10s
mov	r0,r7
mov	r1,#60
swi	#6
mov	r1,#10
swi	#6
add	r1,r0,r6
add	r0,r0,r5
strh	r0,[r4]
mov	r2,#0x40
strh	r1,[r4,r2]

@draw minute 1s
mov	r0,r7
mov	r1,#60
swi	#6
mov	r1,r0
divideminutes:
cmp	r1,#10
blo	getminutes
mov	r1,#10
swi	#6
b	divideminutes
getminutes:
mov	r0,r1
add	r1,r0,r6
add	r0,r0,r5
strh	r0,[r4,#2]
mov	r2,#0x42
strh	r1,[r4,r2]

@draw second 10s
mov	r0,r7
mov	r1,#60
swi	#6
mov	r0,r1
mov	r1,#10
swi	#6
add	r1,r0,r6
add	r0,r0,r5
strh	r0,[r4,#4]
mov	r2,#0x44
strh	r1,[r4,r2]

@draw second 1s
mov	r0,r7
mov	r1,#60
swi	#6
divideseconds:
mov	r0,r1
cmp	r0,#10
blo	getseconds
mov	r1,#10
swi	#6
b	divideseconds
getseconds:
add	r0,r1,r5
add	r1,r1,r6
strh	r0,[r4,#6]
mov	r2,#0x46
strh	r1,[r4,r2]

End:
pop	{r4-r7}
pop	{r0}
bx	r0
