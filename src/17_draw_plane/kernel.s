
;**********************************************
; Macro
;**********************************************
%include	"../include/define.s"
%include	"../include/macro.s"

	ORG	KERNEL_LOAD

;**********************************************
; Entry point
;**********************************************
[BITS 32]
kernel:

	;---------------------------------------
	; Get font address
	;---------------------------------------
	mov	esi,	BOOT_LOAD + SECT_SIZE
	movzx	eax,	word [esi + 0]
	movzx	ebx,	word [esi + 2]
	shl	eax,	4
	add	eax,	ebx
	mov	[FONT_ADR],	eax

	;---------------------------------------
	; 8bit column
	;---------------------------------------
	mov	ah,	0x07
	mov	al,	0x02
	mov	dx,	0x03C4
	out	dx,	ax

	mov	[0x000A_0000 + 0],	byte	0xFF

	mov	ah,	0x04
	out	dx,	ax

	mov	[0x000A_0000 + 1],	byte	0xFF

	mov	ah,	0x02
	out	dx,	ax

	mov	[0x000A_0000 + 2],	byte	0xFF

	mov	ah,	0x01
	out	dx,	ax

	mov	[0x000A_0000 + 3],	byte	0xFF

	;---------------------------------------
	; Horizon over the screen
	;---------------------------------------
	mov	ah,	0x02
	out	dx,	ax

	lea	edi,	[0x000A_0000 + 80]
	mov	ecx,	 80
	mov	al,	0xFF
	rep	stosb

	;---------------------------------------
	; 8 dots rectangle for 2nd column
	;---------------------------------------
	mov	edi,	1

	shl	edi,	8
	lea	edi,	[edi * 4 + edi + 0xA_0000]

	mov	[edi + (80 * 0)],	word 0xFF
	mov	[edi + (80 * 1)],	word 0xFF
	mov	[edi + (80 * 2)],	word 0xFF
	mov	[edi + (80 * 3)],	word 0xFF
	mov	[edi + (80 * 4)],	word 0xFF
	mov	[edi + (80 * 5)],	word 0xFF
	mov	[edi + (80 * 6)],	word 0xFF
	mov	[edi + (80 * 7)],	word 0xFF

	;---------------------------------------
	; Draw char for 3rd line
	;---------------------------------------
	mov	esi,	'A'
	shl	esi,	4
	add	esi,	[FONT_ADR]

	mov	edi,	2
	shl	edi,	8
	lea	edi,	[edi * 4 + edi + 0xA_0000]

	mov	ecx,	16
.10L:

	movsb
	add	edi,	80 - 1
	loop	.10L

	;---------------------------------------
	; Finish process
	;---------------------------------------
	jmp	$

ALIGN 4,	db	0
FONT_ADR:	dd	0

;**********************************************
; Padding
;**********************************************
	times	KERNEL_SIZE - ($ - $$)	db	0
