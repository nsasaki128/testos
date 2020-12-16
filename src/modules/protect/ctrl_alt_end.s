ctrl_alt_end:
	;-------------------------------------
	; Build stack frame
	;-------------------------------------
	push	ebp
	mov	ebp,	esp

	;-------------------------------------
	; Save key status
	;-------------------------------------
	mov	eax,	[ebp + 8]
	btr	eax,	7
	jc	.10F
	bts	[.key_state],	eax
	jmp	.10E
.10F:
	btc	[.key_state],	eax
.10E:
	;-------------------------------------
	; Check key push
	;-------------------------------------
	; Instead of ctrl alt delete, here we check A S D
	mov	eax,	0x1E
	;mov	eax,	0x1D			;	ctrl
	bt	[.key_state],	eax
	jnc	.20E

	mov	eax,	0x1F
	;mov	eax,	0x38			;	alt
	bt	[.key_state],	eax
	jnc	.20E

	mov	eax,	0x20
	;mov	eax,	0x4F			;	del
	bt	[.key_state],	eax
	jnc	.20E

	mov	eax,	-1
.20E:
	sar	eax,	8

	;-------------------------------------
	; Scrap stack frame
	;-------------------------------------
	mov	esp,	ebp
	pop	ebp

	ret
.key_state:	times	32	db	0
