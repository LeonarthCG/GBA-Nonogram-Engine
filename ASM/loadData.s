.thumb

push	{lr}
push	{r4-r7}

mov	r4,r0		@source
mov	r5,r1		@destination
mov	r6,r2		@0 = uncompressed
mov	r7,r3		@size in words

cmp	r6,#0
bne	compressed
lsl	r7,#2		@size in bytes
mov	r1,#0

uncompressedLoop:	@just copy words until the end of the source is reached
cmp	r7,r1
beq	End
ldr	r2,[r4,r1]
str	r2,[r5,r1]
add	r1,#4
b	uncompressedLoop

compressed:		@I doubt this will happen tbh
b	End

End:
pop	{r4-r7}
pop	{r0}
bx	r0
