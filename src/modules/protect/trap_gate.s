trap_gate_81:

	;-------------------------------------
	; Show 1 char
	;-------------------------------------
	cdecl	draw_char,	ecx,	edx,	ebx,	eax

	iret

trap_gate_82:

	;-------------------------------------
	; Draw 1 pixel
	;-------------------------------------
	cdecl	draw_pixel,	ecx,	edx,	ebx

	iret
