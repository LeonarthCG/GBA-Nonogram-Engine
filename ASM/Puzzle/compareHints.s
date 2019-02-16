.thumb
push	{lr}
push	{r4,r5}

mov	r4,r0
mov	r5,r1

mov	r2,#0
ldr	r3,=#0x400
loop:
ldr	r0,[r4,r2]
ldr	r1,[r5,r2]
cmp	r0,r1
bne	False
add	r2,#4
cmp	r2,r3
blo	loop

True:
pop	{r4,r5}
pop	{r1}
mov	r0,#1
bx	r1

False:
pop	{r4,r5}
pop	{r1}
mov	r0,#0
bx	r1
