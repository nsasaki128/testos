vga_set_read_plane:

	;-------------------------------------
	; Build stack frame
	;-------------------------------------
	push	ebp
	mov	ebp,	esp

	;-------------------------------------
	; Save register
	;-------------------------------------
	push	eax
	push	edx

	;-------------------------------------
	; Select read plane
	;-------------------------------------
	mov	ah,	[ebp + 8]
	and	ah,	0x03
	mov	al,	0x04
	mov	dx,	0x03CE
	out	dx,	ax

	;-------------------------------------
	; Recover register
	;-------------------------------------
	pop	edx
	pop	eax

	;-------------------------------------
	; Scrap stack frame
	;-------------------------------------
	mov	esp,	ebp
	pop	ebp

	ret

vga_set_write_plane:

	;-------------------------------------
	; Build stack frame
	;-------------------------------------
	push	ebp
	mov	ebp,	esp

	;-------------------------------------
	; Save register
	;-------------------------------------
	push	eax
	push	edx

	;-------------------------------------
	; Select read plane
	;-------------------------------------
	mov	ah,	[ebp + 8]
	and	ah,	0x0F
	mov	al,	0x02
	mov	dx,	0x03C4
	out	dx,	ax

	;-------------------------------------
	; Recover register
	;-------------------------------------
	pop	edx
	pop	eax

	;-------------------------------------
	; Scrap stack frame
	;-------------------------------------
	mov	esp,	ebp
	pop	ebp

	ret

vram_font_copy:

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
	mov	esi,	[ebp + 8]
	mov	edi,	[ebp +12]
	movzx	eax,	byte	[ebp +16]
	movzx	ebx,	word	[ebp +20]

	test	bh,	al
	setz	dh
	dec	dh

	test	bl,	al
	setz	dl
	dec	dl

	;-------------------------------------
	; Copy 16 bit font
	;-------------------------------------
	cld

	mov	ecx,	16

.10L:
	;-------------------------------------
	; Create font mask
	;-------------------------------------
	lodsb
	mov	ah,	al
	not	ah

	;-------------------------------------
	; Foreground color
	;-------------------------------------
	and	al,	dl

	;-------------------------------------
	; Background color
	;-------------------------------------
	test	ebx,	0x0010
	jz	.11F
	and	ah,	[edi]
	jmp	.11E

.11F:
	and	ah,	dh

.11E:
	;-------------------------------------
	; Compose foreground and background
	;-------------------------------------
	or	al,	ah

	;-------------------------------------
	; Output new value
	;-------------------------------------
	mov	[edi],	al

	add	edi,	80
	loop	.10L
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

vram_bit_copy:

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
	push	edi

	;-------------------------------------
	; Start process
	;-------------------------------------
	mov	edi,	[ebp +12]
	movzx	eax,	byte [ebp +16]
	movzx	ebx,	word [ebp +20]

	mov	bl,	al
	setz	bl
	dec	bl

	mov	al,	[ebp + 8]
	mov	ah,	al
	not	ah

	and	ah,	[edi]
	and	al,	bl
	or	al,	ah
	mov	[edi],	al

	;-------------------------------------
	; Recover register
	;-------------------------------------
	pop	edi
	pop	ebx
	pop	eax

	;-------------------------------------
	; Scrap stack frame
	;-------------------------------------
	mov	esp,	ebp
	pop	ebp

	ret
