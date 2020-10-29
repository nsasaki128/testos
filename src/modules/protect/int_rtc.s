int_rtc:
	;-------------------------------------
	; Save register
	;-------------------------------------
	pusha
	push	ds
	push	es

	;-------------------------------------
	; Set data segment selector
	;-------------------------------------
	mov	ax,	0x0010
	mov	ds,	ax
	mov	es,	ax

	;-------------------------------------
	; Get time from RTC
	;-------------------------------------
	cdecl	rtc_get_time,	RTC_TIME

	;-------------------------------------
	; Get RTC interruption cause
	;-------------------------------------
	outp	0x70,	0x0C
	in	al,	0x71

	;-------------------------------------
	; Clear interruption flag (EOI)
	;-------------------------------------
	mov	al,	0x20
	outp	0xA0,	al			; Slave PIC
	outp	0x20,	al			; Master PIC

	;-------------------------------------
	; Recover register
	;-------------------------------------
	pop	es
	pop	ds
	popa

	iret

rtc_int_en:
	;-------------------------------------
	; Build stack frame
	;-------------------------------------
	push	ebp
	mov	ebp,	esp

	;-------------------------------------
	; Save register
	;-------------------------------------
	push	eax

	;-------------------------------------
	; Set interrupt-enable
	;-------------------------------------
	outp	0x70,	0x0B

	in	al,	0x71
	or	al,	[ebp + 8]

	out	0x71,	al
	;-------------------------------------
	; Recover register
	;-------------------------------------
	pop	eax

	;-------------------------------------
	; Scrap stack frame
	;-------------------------------------
	mov	esp,	ebp
	pop	ebp

	ret
