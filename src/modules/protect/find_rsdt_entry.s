find_rsdt_entry:
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
	push	edi

	;-------------------------------------
	; Get args
	;-------------------------------------
	mov	edi,	[ebp + 8]
	mov	ecx,	[ebp +12]

	mov	ebx,	0
	;-------------------------------------
	; Find ACPI table
	;-------------------------------------
	mov	edi,	esi
	add	edi,	[esi + 4]
	add	esi,	36

.10L:
	cmp	esi,	edi
	jge	.10E

	lodsb

	cmp	[eax],	ecx
	jne	.12E
	mov	ebx,	eax
	jmp	.10E

.12E:	jmp	.10L
.10E:
	mov	eax,	ebx

	;-------------------------------------
	; Recover register
	;-------------------------------------
	pop	edi
	pop	esi
	pop	ecx
	pop	ebx

	;-------------------------------------
	; Scrap stack frame
	;-------------------------------------
	mov	esp,	ebp
	pop	ebp

	ret
