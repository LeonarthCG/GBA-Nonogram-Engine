.thumb

ldr	r0,=puzzletest2
bl	puzzleMain

ldr	r0,=puzzletest
bl	puzzleMain

self:
swi	#5
b	self
