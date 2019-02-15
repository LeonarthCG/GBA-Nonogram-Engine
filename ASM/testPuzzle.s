.thumb

ldr	r0,=puzzletest
bl	puzzleMain

self:
swi	#5
b	self
