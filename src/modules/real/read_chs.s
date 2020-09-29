read_chs:

	;-------------------------------------
	; Build stack frame
	;-------------------------------------
	push	bp
	mov	bp,	sp
	push	3
	push	0

	;-------------------------------------
	; Save register
	;-------------------------------------
	push	bx
	push	cx
	push	dx
	push	es
	push	si


	;-------------------------------------
	; Start process
	;-------------------------------------
	mov	si,	[bp + 4]

	;-------------------------------------
	; Setting about CX register
	; Change for BIOS call
	;-------------------------------------
	mov	ch,	[si + drive.cyln + 0]
	mov	cl,	[si + drive.cyln + 1]
	shl	cl,	6
	or	cl,	[si + drive.sect]

	;-------------------------------------
	; Read sector
	;-------------------------------------
	mov	dh,	[si + drive.head]
	mov	dl,	[si + 0]
	mov	ax,	0x0000
	mov	es,	ax
	mov	bx,	[bp + 8]
.10L:
	mov	ah,	0x02
	mov	al,	[bp + 6]

	int	0x13
	jnc	.11E

	mov	al,	0
	jmp	.10E
.11E:
	cmp	al,	0
	jne	.10E

	mov	ax,	0
	dec	word	[bp - 2]
	jnz	.10L
.10E:
	mov	ah,	0
	;-------------------------------------
	; Recover register
	;-------------------------------------
	pop	si
	pop	es
	pop	dx
	pop	cx
	pop	bx

	;-------------------------------------
	; Scrap stack frame
	;-------------------------------------
	mov	sp,	bp
	pop	bp

	ret
