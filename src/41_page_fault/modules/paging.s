init_page:
	;-------------------------------------
	; Save register
	;-------------------------------------
	pusha

	;-------------------------------------
	; Create page convert table
	;-------------------------------------
	cdecl	pase_set_4m,	CR3_BASE
	mov	[0x0010_6000 + 0x107 * 4],	dword	0

	;-------------------------------------
	; Recover register
	;-------------------------------------
	popa

	ret

pase_set_4m:
	;-------------------------------------
	; Build stack frame
	;-------------------------------------
	push	ebp
	mov	ebp,	esp

	;-------------------------------------
	; Save register
	;-------------------------------------
	pusha

	;-------------------------------------
	; Create page directory (P=0)
	;-------------------------------------
	cld
	mov	edi,	[ebp + 8]
	mov	eax,	0x00000000
	mov	ecx,	1024
	rep	stosd

	;-------------------------------------
	; Set head entry
	;-------------------------------------
	mov	eax,	edi
	and	eax,	~0x0000_0FFF
	or	eax,	7
	mov	[edi - (1024 * 4)],	eax

	;-------------------------------------
	; Set page table (linear)
	;-------------------------------------
	mov	eax,	0x00000007
	mov	ecx,	1024

.10L:
	stosd
	add	eax,	0x00001000
	loop	.10L

	;-------------------------------------
	; Recover register
	;-------------------------------------
	popa

	;-------------------------------------
	; Scrap stack frame
	;-------------------------------------
	mov	esp,	ebp
	pop	ebp

	ret