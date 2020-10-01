KBC_Data_Write:

	;-------------------------------------
	; Build stack frame
	;-------------------------------------
	push	bp
	mov	bp,	sp

	;-------------------------------------
	; Save register
	;-------------------------------------
	push	cx

	;-------------------------------------
	; Start process
	;-------------------------------------
	mov	cx,	0

.10L:
	in	al,	0x64
	test	al,	0x02
	loopnz	.10L

	cmp	cx,	0
	jz	.20E

	mov	al,	[bp + 4]
	out	0x60,	al
.20E:
	mov	ax,	cx

	;-------------------------------------
	; Recover register
	;-------------------------------------
	pop	cx

	;-------------------------------------
	; Scrap stack frame
	;-------------------------------------
	mov	sp,	bp
	pop	bp

	ret

KBC_Data_Read:

	;-------------------------------------
	; Build stack frame
	;-------------------------------------
	push	bp
	mov	bp,	sp

	;-------------------------------------
	; Save register
	;-------------------------------------
	push	cx

	;-------------------------------------
	; Start process
	;-------------------------------------
	mov	cx,	0

.10L:
	in	al,	0x64
	test	al,	0x01
	loopz	.10L

	cmp	cx,	0
	jz	.20E

	mov	ah,	0x00
	in	al,	0x60

	mov	di,	[bp + 4]
	mov	[di + 0],	ax
.20E:
	mov	ax,	cx

	;-------------------------------------
	; Recover register
	;-------------------------------------
	pop	cx

	;-------------------------------------
	; Scrap stack frame
	;-------------------------------------
	mov	sp,	bp
	pop	bp

	ret

KBC_Cmd_Write:

	;-------------------------------------
	; Build stack frame
	;-------------------------------------
	push	bp
	mov	bp,	sp

	;-------------------------------------
	; Save register
	;-------------------------------------
	push	cx

	;-------------------------------------
	; Start process
	;-------------------------------------
	mov	cx,	0

.10L:
	in	al,	0x64
	test	al,	0x02
	loopnz	.10L

	cmp	cx,	0
	jz	.20E

	mov	al,	[bp + 4]
	out	0x64,	al
.20E:
	mov	ax,	cx

	;-------------------------------------
	; Recover register
	;-------------------------------------
	pop	cx

	;-------------------------------------
	; Scrap stack frame
	;-------------------------------------
	mov	sp,	bp
	pop	bp

	ret
