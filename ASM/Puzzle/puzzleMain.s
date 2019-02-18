.thumb

push	{lr}
push	{r4-r7}

mov	r4,r0

@clean some ram stuff
mov	r0,#0
ldr	r1,=#0x02000000
ldr	r2,=#0x80
bl	fillDest
mov	r0,#0
ldr	r1,=#0x02000160
ldr	r2,=#0x300
bl	fillDest
mov	r0,#0
ldr	r1,=bgTilemapsBuffer
ldr	r1,[r1]
ldr	r2,=#0x600
bl	fillDest

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
ldr	r0,=gridTimeIMG
ldr	r1,=#0x06002800
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

@load the data for the puzzle
mov	r0,r4
bl	loadPuzzle

@draw the grid and change the size
mov	r0,r4
bl	drawGrid

@calculate hints
mov	r0,r4
bl	getHints

@and draw them
swi	#5		@make sure the grid was drawn to the screen first
mov	r0,r4
ldr	r1,=#0x02000200
bl	drawHints

@draw the color selection
swi	#5		@make sure the hints were drawn
ldr	r0,=#0x0200016C
mov	r1,#0
strb	r1,[r0]		@set selected color to 0
mov	r0,r4
ldr	r1,=#0x02000200
bl	drawColors

@draw cursor so that it exists for the fade
bl	drawCursor
swi	#5

@draw the puzzle preview tiles to the background
bl	drawPreview

@reset the seconds counter
ldr	r0,=#0x02000160
mov	r1,#0
str	r1,[r0,#4]

@draws/updates the timer
bl	drawTimer

@start fade
bl	fadeIn

Main:
@draws/updates the timer
bl	drawTimer

@check if current action should stop
bl	stopAction

@handle key input for moving the cursor
bl	cursorMovement

@redraw the cursor
bl	drawCursor

@handle key input for color change
bl	colorChange

@draw the color selection
mov	r0,r4
ldr	r1,=#0x02000200
bl	drawColors

@check if current action should change
bl	changeAction

@check if current action should be applied
bl	applyAction

@update graphics for squares and crosses
bl	drawSquares

@erase player hints
mov	r0,#0
ldr	r1,=#0x02000600
ldr	r2,=#0x100
bl	fillDest

@update player hints
mov	r0,r4
ldr	r1,=#0x02000A00
bl	getPlayerHints

@compare them to source puzzle hints
ldr	r0,=#0x02000200
ldr	r1,=#0x02000600
bl	compareHints
cmp	r0,#0
bne	win

swi	#5
b	Main

pop	{r4-r7}
pop	{r0}
bx	r0

win:
@stop timer
ldr	r0,=#0x04000100
mov	r1,#0xC7
strh	r1,[r0,#0xE]
@erase cursor
mov	r0,#0
ldr	r1,=#0x07000000
ldr	r2,=#0x100
bl	fillDest
@update tiles a few times
bl	drawSquares
swi	#5
bl	drawSquares
swi	#5
bl	drawSquares
swi	#5
bl	drawSquares
swi	#5
bl	drawSquares
swi	#5
bl	drawSquares
swi	#5
bl	drawSquares
swi	#5
bl	drawSquares
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
swi	#5
bl	fadeOut
winloop:
swi	#5
b	winloop
