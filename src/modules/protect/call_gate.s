call_gate:

	;-------------------------------------
	; Build stack frame
	;-------------------------------------
	push	ebp
	mov	ebp,	esp

	;-------------------------------------
	; Save register
	;-------------------------------------
	pusha
	push	ds
	push	es

	;-------------------------------------
	; Set data segment
	;-------------------------------------
	mov	ax,	0x0010
	mov	ds,	ax
	mov	es,	ax

	;-------------------------------------
	; Show string
	;-------------------------------------
	mov	eax,	dword [ebp +12]
	mov	ebx,	dword [ebp +16]
	mov	ecx,	dword [ebp +20]
	mov	edx,	dword [ebp +24]
	cdecl	draw_str,	eax,	ebx,	ecx,	edx

	;-------------------------------------
	; Recover register
	;-------------------------------------
	pop	es
	pop	ds
	popa

	;-------------------------------------
	; Scrap stack frame
	;-------------------------------------
	mov	esp,	ebp
	pop	ebp

	retf	4 * 4
