acpi_find:
	;-------------------------------------
	; Build stack frame
	;-------------------------------------
	push	ebp
	mov	ebp,	esp

	;-------------------------------------
	; Save register
	;-------------------------------------
	push	eax
	push	ecx
	push	edi

	;-------------------------------------
	; Get args
	;-------------------------------------
	mov	edi,	[ebp + 8]
	mov	ecx,	[ebp +12]
	mov	eax,	[ebp +16]

	;-------------------------------------
	; Seach name
	;-------------------------------------
	cld

.10L:
	repne	scasb

	cmp	ecx,	0
	jnz	.11E
	mov	eax,	0
	jmp	.10E

.11E:
	cmp	eax,	[es:edi - 1]
	jne	.10L

	dec	edi
	mov	eax,	edi

.10E:
	;-------------------------------------
	; Recover register
	;-------------------------------------
	pop	edi
	pop	ecx
	pop	eax

	;-------------------------------------
	; Scrap stack frame
	;-------------------------------------
	mov	esp,	ebp
	pop	ebp

	ret
