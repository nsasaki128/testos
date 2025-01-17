draw_color_bar:

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

	;-------------------------------------
	; Show color bar
	;-------------------------------------
	mov	ecx,	0
.10L:	cmp	ecx,	16
	jae	.10E

	mov	eax,	ecx
	and	eax,	0x01
	shl	eax,	3
	add	eax,	esi

	mov	ebx,	ecx
	shr	ebx,	1
	add	ebx,	edi

	mov	edx,	ecx
	shl	edx,	1
	mov	edx,	[.t0 + edx]

	cdecl	draw_str,	eax,	ebx,	edx,	.s0

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


.s0:	db	'        ',	0

.t0:	dw	0x0000,	0x0800
	dw	0x0100,	0x0900
	dw	0x0200,	0x0A00
	dw	0x0300,	0x0B00
	dw	0x0400,	0x0C00
	dw	0x0500,	0x0D00
	dw	0x0600,	0x0E00
	dw	0x0700,	0x0F00
