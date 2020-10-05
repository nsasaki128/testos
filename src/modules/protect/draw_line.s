draw_line:

	;-------------------------------------
	; Build stack frame
	;-------------------------------------
	push	ebp
	mov	ebp,	esp

	push	dword	0
	push	dword	0
	push	dword	0
	push	dword	0
	push	dword	0
	push	dword	0
	push	dword	0

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
	; Calculate width
	;-------------------------------------
	mov	eax,	[ebp + 8]
	mov	ebx,	[ebp +16]
	sub	ebx,	eax
	jge	.10F

	neg	ebx
	mov	esi,	-1
	jmp	.10E
.10F:
	mov	esi,	1

.10E:

	;-------------------------------------
	; Calculate height
	;-------------------------------------
	mov	ecx,	[ebp +12]
	mov	edx,	[ebp +20]
	sub	edx,	ecx
	jge	.20F

	neg	edx
	mov	edi,	-1
	jmp	.20E
.20F:
	mov	edi,	1

.20E:
	;-------------------------------------
	; X axis
	;-------------------------------------
	mov	[ebp - 8],	eax
	mov	[ebp -12],	ebx
	mov	[ebp -16],	esi

	;-------------------------------------
	; Y axis
	;-------------------------------------
	mov	[ebp -20],	ecx
	mov	[ebp -24],	edx
	mov	[ebp -28],	edi

	;-------------------------------------
	; Define base axis
	;-------------------------------------
	cmp	ebx,	edx
	jg	.22F

	lea	esi,	[ebp -20]
	lea	edi,	[ebp - 8]

	jmp	.22E
.22F:
	lea	esi,	[ebp - 8]
	lea	edi,	[ebp -20]

.22E:

	;-------------------------------------
	; Repeat number (dot num of base axis)
	;-------------------------------------
	mov	ecx,	[esi - 4]
	cmp	ecx,	0
	jnz	.30E
	mov	ecx,	1
.30E:
	;-------------------------------------
	; Draw line
	;-------------------------------------
.50L:
	cdecl	draw_pixel,	dword [ebp - 8], \
				dword [ebp -20], \
				dword [ebp +24]

	mov	eax,	[esi - 8]
	add	[esi - 0],	eax

	mov	eax,	[ebp - 4]
	add	eax,	[edi - 4]

	mov	ebx,	[esi - 4]

	cmp	eax,	ebx
	jl	.52E
	sub	eax,	ebx

	mov	ebx,	[edi - 8]
	add	[edi - 0],	ebx
.52E:
	mov	[ebp - 4],	eax

	loop	.50L
.50E:
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

