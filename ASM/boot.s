.arm
ldr	r0,=toThumb
add	r0,#1
bx	r0

.thumb

toThumb:

self:
b	self
