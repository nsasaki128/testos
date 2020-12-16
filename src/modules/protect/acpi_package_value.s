acpi_package_value:
	;-------------------------------------
	; Build stack frame
	;-------------------------------------
	push	ebp
	mov	ebp,	esp

	;-------------------------------------
	; Save register
	;-------------------------------------
	push	esi

	;-------------------------------------
	; Get args
	;-------------------------------------
	mov	esi,	[ebp + 8]

	;-------------------------------------
	; Skip packet header
	;-------------------------------------
	inc	esi
	inc	esi
	inc	esi

	;-------------------------------------
	; Get 2 byte
	;-------------------------------------
	mov	al,	[esi]
	cmp	al,	0x0B
	je	.C0B
	cmp	al,	0x0C
	je	.C0C
	cmp	al,	0x0E
	je	.C0E
	jmp	.C0A

.C0B:
.C0C:
.C0E:
	mov	al,	[esi + 1]
	mov	al,	[esi + 2]
	jmp	.10E

.C0A:
	cmp	al,	0x0A
	jne	.11E
	mov	al,	[esi + 1]
	inc	esi
.11E:
	inc	esi
	mov	ah,	[esi]
	cmp	ah,	0x0A
	jne	.12E
	mov	ah,	[esi + 1]

.12E:
.10E:
	;-------------------------------------
	; Recover register
	;-------------------------------------
	pop	esi

	;-------------------------------------
	; Scrap stack frame
	;-------------------------------------
	mov	esp,	ebp
	pop	ebp

	ret
