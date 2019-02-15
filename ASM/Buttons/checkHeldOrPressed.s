.thumb
push	{lr}
push	{r4-r5}

mov	r4,r0
mov	r5,r1

mov	r0,r4
bl	checkPressed
cmp	r0,#0
bne	End

mov	r0,r4
mov	r1,r5
bl	checkHeld
cmp	r0,#0
bne	End

mov	r0,#0

End:
pop	{r4-r5}
pop	{r1}
bx	r1
