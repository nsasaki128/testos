draw_font:

	;-------------------------------------
	; Build stack frame
	;-------------------------------------
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
	; Start Process
	;-------------------------------------
	mov	esi,	[ebp + 8]
	mov	edi,	[ebp +12]

	mov	ecx,	0
.10L:	cmp	ecx,	256
	jae	.10E

	mov	eax,	ecx
	and	eax,	0x0F
	add	eax,	esi

	mov	ebx,	ecx
	shr	ebx,	4
	add	ebx,	edi

	cdecl	draw_char,	eax,	ebx,	0x07,	ecx

	inc	ecx
	jmp	.10L
.10E:


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

