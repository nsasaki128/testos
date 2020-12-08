wait_tick:

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

	;-------------------------------------
	; Wait
	;-------------------------------------
	mov	ecx,	[ebp + 8]
	mov	eax,	[TIMER_COUNT]

.10L:	cmp	[TIMER_COUNT],	eax
	je	.10L
	inc	eax
	loop	.10L

	;-------------------------------------
	; Recover register
	;-------------------------------------
	pop	ecx
	pop	eax

	;-------------------------------------
	; Scrap stack frame
	;-------------------------------------
	mov	esp,	ebp
	pop	ebp

	ret
