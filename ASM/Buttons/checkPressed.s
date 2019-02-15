.thumb

ldr	r3,=#0x02000130
lsl	r0,#2
add	r0,r3

ldrb	r0,[r0]

bx	lr
