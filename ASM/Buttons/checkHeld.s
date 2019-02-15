.thumb

ldr	r3,=#0x02000130
lsl	r2,r0,#2
add	r2,r3

ldrb	r0,[r2,#1]
cmp	r0,#0
beq	End

ldrb	r2,[r2,#3]
cmp	r1,r2
blo	End

mov	r0,#0

End:
bx	lr
