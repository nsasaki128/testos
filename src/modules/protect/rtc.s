rtc_get_time:
	;-------------------------------------
	; Build stack frame
	;-------------------------------------
	push	ebp
	mov	ebp,	esp

	;-------------------------------------
	; Save register
	;-------------------------------------
	push	ebx

	;-------------------------------------
	; Process start
	;-------------------------------------
	mov	al,	0x0A
	out	0x70,	al
	in	al,	0x71
	test	al,	0x80
	je	.10F
	mov	eax,	1
	jmp	.10E
.10F:
	mov	al,	0x04
	out	0x70,	al
	in	al,	0x71			; hour

	shl	eax,	8

	mov	al,	0x02
	out	0x70,	al
	in	al,	0x71			; miniute

	shl	eax,	8

	mov	al,	0x00
	out	0x70,	al
	in	al,	0x71			; second

	and 	eax,	0x00_FF_FF_FF

	mov	ebx,	[ebp + 8]
	mov	[ebx],	eax

	mov	eax,	0
.10E:
;-------------------------------------
	; Recover register
	;-------------------------------------
	pop	ebx

	;-------------------------------------
	; Scrap stack frame
	;-------------------------------------
	mov	esp,	ebp
	pop	ebp

	ret
