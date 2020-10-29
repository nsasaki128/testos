int_keyboard:
	;-------------------------------------
	; Save register
	;-------------------------------------
	pusha
	push	ds
	push	es

	;-------------------------------------
	; Set data segmaent
	;-------------------------------------
	mov	ax,	0x0010
	mov	ds,	ax
	mov	es,	ax

	;-------------------------------------
	; Read KBC buffer
	;-------------------------------------
	in	al,	0x60

	;-------------------------------------
	; Save key codd
	;-------------------------------------
	cdecl	ring_wr,	_KEY_BUFF,	eax

	;-------------------------------------
	; Send interruption finish comand
	;-------------------------------------
	outp	0x20,	0x20

	;-------------------------------------
	; Recover register
	;-------------------------------------
	pop	es
	pop	ds
	popa

	iret

ALIGN 4,	db	0
_KEY_BUFF:	times	ring_buff_size	db	0

