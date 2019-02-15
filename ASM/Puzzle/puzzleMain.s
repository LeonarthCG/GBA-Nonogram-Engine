.thumb

push	{lr}
push	{r4-r7}

mov	r4,r0

@load grid stuff
ldr	r0,=gridIMG
ldr	r1,=#0x06000000
ldrh	r2,[r0]
ldrh	r3,[r0,#2]
add	r0,#4
bl	loadData
ldr	r0,=gridCursorIMG
ldr	r1,=#0x06010000
ldrh	r2,[r0]
ldrh	r3,[r0,#2]
add	r0,#4
bl	loadData
ldr	r0,[r4,#12]
ldr	r1,=#0x05000000
ldrh	r2,[r0]
ldrh	r3,[r0,#2]
add	r0,#4
bl	loadData
ldr	r0,[r4,#12]
ldr	r1,=#0x05000200
ldrh	r2,[r0]
ldrh	r3,[r0,#2]
add	r0,#4
bl	loadData
ldr	r0,=gridTSA
ldr	r1,=bgTilemapsBuffer
ldr	r1,[r1]
ldrh	r2,[r0]
ldrh	r3,[r0,#2]
add	r0,#4
bl	loadData

@and the numbers
ldr	r0,=puzzleColors
ldr	r1,=#0x06000400
ldrh	r2,[r0]
ldrh	r3,[r0,#2]
add	r0,#4
bl	loadData
ldr	r0,[r4,#8]
ldr	r1,=#0x05000020
ldrh	r2,[r0]
ldrh	r3,[r0,#2]
add	r0,#4
bl	loadData

mov	r0,r4
bl	loadPuzzle

mov	r0,r4
bl	drawGrid

swi	#5

mov	r0,r4
bl	getHints

mov	r0,r4
ldr	r1,=#0x02000200
bl	drawHints

swi	#5

bl	fadeIn

self:
swi	#5
b	self

pop	{r4-r7}
pop	{r0}
bx	r0
