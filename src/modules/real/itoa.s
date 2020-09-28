itoa:
	;-------------------------------------
	; Build stack frame
	;-------------------------------------
						;   +12| flags
						;   +10| base
						;   + 8| buffer size
						;   + 6| buffer address
						;   + 4| number
						;   + 2| IP(return adress)
						; BP+ 0| BP
						;------+------
	push	bp
	mov	bp,	sp

	;-------------------------------------
	; Save register
	;-------------------------------------
	push	ax
	push	bx
	push	cx
	push	dx
	push	si
	push	di

	;-------------------------------------
	; Get arguments
	;-------------------------------------
	mov	ax,	[bp + 4]		; val = number;
	mov	si,	[bp + 6]		; dst = buffer address;
	mov	cx,	[bp + 8]		; size = size of rest buffer

	mov	di,	si			; // Tail of buffer
	add	di,	cx			; dst = &dst[size - 1]
	dec	di				;

	mov	bx,	word	[bp + 12]	; flags = option

	;-------------------------------------
	; Judge signature
	;-------------------------------------
	test	bx,	0b0001			; if (flags & 0x01) // with signature
.10Q:	je	.10E				; {
	cmp	ax,	0			;   if (val < 0)
.12Q:	jge	.12E				;   {
	or	bx,	0b0010			;     flags |= 2; // show signature
.12E:						;   }
.10E:						; }

	;-------------------------------------
	; Judge output signature
	;-------------------------------------
	test	bx,	0b0010			; if (flags & 0x02) // judge output signature
.20Q:	je	.20E				; {
	cmp	ax,	0			;   if (val < 0)
.22Q:	jge	.22F				;   {
	neg	ax				;     val *= -1; // reverse signature
	mov	[si],	byte	'-'		;     *dst = '-';
	jmp	.22E				;   }
.22F:						;   else
						;   {
	mov	[si],	byte	'+'		;     *dst = '+';
.22E:						;   }
	dec	cx				;   size--;
.20E:						; }


	;-------------------------------------
	; ASCII
	;-------------------------------------
	mov	bx,	[bp + 10]		; BX = base
.30L:

	mov	dx,	0
	div	bx


	mov	si,	dx
	mov	dl,	byte	[.ascii + si]

	mov	[di],	dl
	dec	di

	cmp	ax,	0
	loopnz	.30L
.30E:

	;-------------------------------------
	; fill empty
	;-------------------------------------
	cmp	cx,	0
.40Q:	je	.40E
	mov	al,	' '
	cmp	[bp + 12],	word	0b0100
.42Q:	jne	.42E
	mov	al,	'0'
.42E:
	std
	rep	stosb
.40E:

	;-------------------------------------
	; Recover register
	;-------------------------------------
	pop	di
	pop	si
	pop	dx
	pop	cx
	pop	bx
	pop	ax

	;-------------------------------------
	; Scrap stack frame
	;-------------------------------------
	mov	sp,	bp
	pop	bp

	ret

.ascii	db	"0123456789ABCDEF"
