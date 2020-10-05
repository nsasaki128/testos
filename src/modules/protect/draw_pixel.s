draw_pixel:

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
	push	edi

	;-------------------------------------
	; 80 times Y axis
	;-------------------------------------
	mov	edi,	[ebp +12]
	shl	edi,	4
	lea	edi,	[edi * 4 + edi + 0xA_0000]

	;-------------------------------------
	; 1/8 times X axis
	;-------------------------------------
	mov	ebx,	[ebp + 8]
	mov	ecx,	ebx
	shr	ebx,	3
	add	edi,	ebx

	;-------------------------------------
	; Calculate bit postion from mod of X axis by 8
	; (0=0x80, 1=0x40, ... 7=0x01
	;-------------------------------------
	and	ecx,	0x07
	mov	ebx,	0x80
	shr	ebx,	cl

	;-------------------------------------
	; Set color
	;-------------------------------------
	mov	ecx,	[ebx +16]

	;-------------------------------------
	; Output for each plane
	;-------------------------------------
	cdecl	vga_set_read_plane,	0x03
	cdecl	vga_set_write_plane,	0x08
	cdecl	vram_bit_copy,	ebx,	edi,	0x08,	ecx

	cdecl	vga_set_read_plane,	0x02
	cdecl	vga_set_write_plane,	0x04
	cdecl	vram_bit_copy,	ebx,	edi,	0x04,	ecx

	cdecl	vga_set_read_plane,	0x01
	cdecl	vga_set_write_plane,	0x02
	cdecl	vram_bit_copy,	ebx,	edi,	0x02,	ecx

	cdecl	vga_set_read_plane,	0x00
	cdecl	vga_set_write_plane,	0x01
	cdecl	vram_bit_copy,	ebx,	edi,	0x01,	ecx

	;-------------------------------------
	; Recover register
	;-------------------------------------
	pop	edi
	pop	ecx
	pop	ebx
	pop	eax

	;-------------------------------------
	; Scrap stack frame
	;-------------------------------------
	mov	esp,	ebp
	pop	ebp

	ret

