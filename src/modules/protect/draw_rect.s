draw_rect:

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
	; Start process
	;-------------------------------------
	mov	eax,	[ebp + 8]
	mov	ebx,	[ebp +12]
	mov	ecx,	[ebp +16]
	mov	edx,	[ebp +20]
	mov	esi,	[ebp +24]

	;-------------------------------------
	; Decide coordinate axes
	;-------------------------------------
	cmp	eax,	ecx
	jl	.10E
	xchg	eax,	ecx
.10E:
	cmp	ebx,	edx
	jl	.20E
	xchg	ebx,	edx
.20E:

	;-------------------------------------
	; Draw rectangle
	;-------------------------------------
	cdecl	draw_line,	eax,	ebx,	ecx,	ebx,	esi
	cdecl	draw_line,	eax,	ebx,	eax,	edx,	esi

	dec	edx
	cdecl	draw_line,	eax,	edx,	ecx,	edx,	esi
	inc	edx

	dec	ecx
	cdecl	draw_line,	ecx,	ebx,	ecx,	edx,	esi

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

