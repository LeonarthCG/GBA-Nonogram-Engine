.thumb

push	{lr}
push	{r4}

ldr	r0,=#0x04000050
mov	r4,#0xFF
strb	r4,[r0]
mov	r4,#0
strb	r4,[r0,#4]

loop:
swi	#5
ldr	r0,=#0x04000050
add	r4,#1
strb	r4,[r0,#4]
cmp	r4,#0x1F
bhs	End
b	loop

End:
pop	{r4}
pop	{r0}
bx	r0
