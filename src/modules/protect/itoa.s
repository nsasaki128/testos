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
	push	ebp
	mov	ebp,	esp

	;-------------------------------------
	; Save register
	;-------------------------------------
	push	eax
	push	ebx
	push	ecx
	push	edx
	push	esi
	push	edi

	;-------------------------------------
	; Get arguments
	;-------------------------------------
	mov	eax,	[ebp + 8]		; val = number;
	mov	esi,	[ebp + 12]		; dst = buffer address;
	mov	ecx,	[ebp + 16]		; size = size of rest buffer

	mov	edi,	esi			; // Tail of buffer
	add	edi,	ecx			; dst = &dst[size - 1]
	dec	edi				;

	mov	ebx,	[ebp + 24]	; flags = option

	;-------------------------------------
	; Judge signature
	;-------------------------------------
	test	ebx,	0b0001			; if (flags & 0x01) // with signature
.10Q:	je	.10E				; {
	cmp	eax,	0			;   if (val < 0)
.12Q:	jge	.12E				;   {
	or	ebx,	0b0010			;     flags |= 2; // show signature
.12E:						;   }
.10E:						; }

	;-------------------------------------
	; Judge output signature
	;-------------------------------------
	test	ebx,	0b0010			; if (flags & 0x02) // judge output signature
.20Q:	je	.20E				; {
	cmp	eax,	0			;   if (val < 0)
.22Q:	jge	.22F				;   {
	neg	eax				;     val *= -1; // reverse signature
	mov	[esi],	byte	'-'		;     *dst = '-';
	jmp	.22E				;   }
.22F:						;   else
						;   {
	mov	[esi],	byte	'+'		;     *dst = '+';
.22E:						;   }
	dec	ecx				;   size--;
.20E:						; }


	;-------------------------------------
	; ASCII
	;-------------------------------------
	mov	ebx,	[ebp +20]		; BX = base
.30L:

	mov	edx,	0
	div	ebx

	mov	esi,	edx
	mov	dl,	byte	[.ascii + esi]

	mov	[edi],	dl
	dec	edi

	cmp	eax,	0
	loopnz	.30L
.30E:

	;-------------------------------------
	; fill empty
	;-------------------------------------
	cmp	ecx,	0
.40Q:	je	.40E
	mov	al,	' '
	cmp	[ebp + 24],	word	0b0100
.42Q:	jne	.42E
	mov	al,	'0'
.42E:
	std
	rep	stosb
.40E:

	;-------------------------------------
	; Recover register
	;-------------------------------------
	pop	edi
	pop	esi
	pop	edx
	pop	ecx
	pop	ebx
	pop	eax

	;-------------------------------------
	; Scrap stack frame
	;-------------------------------------
	mov	esp,	ebp
	pop	ebp

	ret

.ascii	db	"0123456789ABCDEF"
