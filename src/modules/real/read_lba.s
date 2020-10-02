read_lba:

	;-------------------------------------
	; Build stack frame
	;-------------------------------------
	push	bp
	mov	bp,	sp

	;-------------------------------------
	; Save register
	;-------------------------------------
	push	si


	;-------------------------------------
	; Start process
	;-------------------------------------
	mov	si,	[bp + 4]

	;-------------------------------------
	; LBA -> CHS
	;-------------------------------------
	mov	ax,	[bp + 6]
	cdecl	lba_chs,	si,	.chs,	ax


	;-------------------------------------
	; Copy drive number
	;-------------------------------------
	mov	al,	[si + drive.no]
	mov	[.chs + drive.no],	al

	;-------------------------------------
	; Read sector
	;-------------------------------------
	cdecl	read_chs,	.chs,	word[bp + 8],	word[bp + 10]
	;-------------------------------------
	; Recover register
	;-------------------------------------
	pop	si

	;-------------------------------------
	; Scrap stack frame
	;-------------------------------------
	mov	sp,	bp
	pop	bp

	ret

ALIGN	2
.chs:	times	drive_size	db	0