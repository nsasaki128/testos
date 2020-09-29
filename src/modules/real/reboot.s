reboot:
	;-------------------------------------
	; Show message
	;-------------------------------------
	cdecl	puts,	.s0

	;-------------------------------------
	; Wait key input
	;-------------------------------------

.10L:
	mov	ah,	0x10
	int	0x16

	cmp	al, ' '
	jne	.10L

	;-------------------------------------
	; Output newline
	;-------------------------------------
	cdecl	puts,	.s1

	;-------------------------------------
	; Reboot
	;-------------------------------------
	int	0x19

	;-------------------------------------
	; String data
	;-------------------------------------
.s0	db	0x0A,	0x0D,	"Push SPACE key to reboot...",	0
.s1	db	0x0A,	0x0D,	0x0A,	0x0D,	0

