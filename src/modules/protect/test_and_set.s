test_and_set:

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

	;-------------------------------------
	; Test and set
	;-------------------------------------
	mov	eax,	0
	mov	ebx,	[ebp + 8]

.10L:
	lock	bts [ebx],	eax
	jnc	.10E

.12L:
	bt	[ebx],	eax
	jc	.12L

	jmp	.10L
.10E:

	;-------------------------------------
	; Recover register
	;-------------------------------------
	pop	ebx
	pop	eax

	;-------------------------------------
	; Scrap stack frame
	;-------------------------------------
	mov	esp,	ebp
	pop	ebp

	ret
