ring_rd:
	;-------------------------------------
	; Build stack frame
	;-------------------------------------
	push	ebp
	mov	ebp,	esp

	;-------------------------------------
	; Save register
	;-------------------------------------
	push	ebx
	push	esi
	push	edi

	;-------------------------------------
	; Get args
	;-------------------------------------
	mov	esi,	[ebp + 8]
	mov	edi,	[ebp +12]

	;-------------------------------------
	; Check reading position
	;-------------------------------------
	mov	eax,	0
	mov	ebx,	[esi + ring_buff.rp]
	cmp	ebx,	[esi + ring_buff.wp]
	je	.10E

	mov	al,	[esi + ring_buff.item + ebx]

	mov	[edi],	al

	inc	ebx
	and	ebx,	RING_INDEX_MASK
	mov	[esi + ring_buff.rp],	ebx

	mov	eax,	1
.10E:
	;-------------------------------------
	; Recover register
	;-------------------------------------
	pop	edi
	pop	esi
	pop	ebx

	;-------------------------------------
	; Scrap stack frame
	;-------------------------------------
	mov	esp,	ebp
	pop	ebp

	ret

ring_wr:
	;-------------------------------------
	; Build stack frame
	;-------------------------------------
	push	ebp
	mov	ebp,	esp

	;-------------------------------------
	; Save register
	;-------------------------------------
	push	ebx
	push	ecx
	push	esi

	;-------------------------------------
	; Get args
	;-------------------------------------
	mov	esi,	[ebp + 8]

	;-------------------------------------
	; Check writing position
	;-------------------------------------
	mov	eax,	0
	mov	ebx,	[esi + ring_buff.wp]
	mov	ecx,	ebx
	inc	ecx
	and	ecx,	RING_INDEX_MASK

	cmp	ecx,	[esi + ring_buff.rp]
	je	.10E

	mov	al,	[ebp +12]

	mov	[esi + ring_buff.item + ebx],	al
	mov	[esi + ring_buff.wp],	ecx
	mov	eax,	1

.10E:
	;-------------------------------------
	; Recover register
	;-------------------------------------
	pop	esi
	pop	ecx
	pop	ebx

	;-------------------------------------
	; Scrap stack frame
	;-------------------------------------
	mov	esp,	ebp
	pop	ebp

	ret

draw_key:
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
	; Get args
	;-------------------------------------
	mov	edx,	[ebp + 8]
	mov	edi,	[ebp +12]
	mov	esi,	[ebp +16]

	;-------------------------------------
	; Get ring buffer information
	;-------------------------------------
	mov	ebx,	[esi + ring_buff.rp]
	lea	esi,	[esi + ring_buff.item]
	mov	ecx,	RING_ITEM_SIZE

.10L:
	dec	ebx
	and	ebx,	RING_INDEX_MASK
	mov	al,	[esi + ebx]

	cdecl	itoa,	eax,	.tmp,	2,	16,	0b0100
	cdecl	draw_str,	edx,	edi,	0x02,	.tmp

	add	edx,	3

	loop	.10L
.10E:

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

.tmp	db	"-- ",	0
