
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
	; Draw string
	;---------------------------------------
	cdecl	draw_font,	63,	13
	cdecl	draw_color_bar,	63,	4
	cdecl	draw_str,	25,	14,	0x010F,	.s0

	;---------------------------------------
	; Draw line
	;---------------------------------------
	cdecl	draw_line,	100,	100,	0,	0,	0x0F
	cdecl	draw_line,	100,	100,	200,	0,	0x0F
	cdecl	draw_line,	100,	100,	200,	200,	0x0F
	cdecl	draw_line,	100,	100,	0,	200,	0x0F

	cdecl	draw_line,	100,	100,	50,	0,	0x02
	cdecl	draw_line,	100,	100,	150,	0,	0x03
	cdecl	draw_line,	100,	100,	150,	200,	0x04
	cdecl	draw_line,	100,	100,	50,	200,	0x05

	cdecl	draw_line,	100,	100,	0,	50,	0x02
	cdecl	draw_line,	100,	100,	200,	50,	0x03
	cdecl	draw_line,	100,	100,	200,	150,	0x04
	cdecl	draw_line,	100,	100,	0,	150,	0x05

	cdecl	draw_line,	100,	100,	100,	0,	0x0F
	cdecl	draw_line,	100,	100,	200,	100,	0x0F
	cdecl	draw_line,	100,	100,	100,	200,	0x0F
	cdecl	draw_line,	100,	100,	0,	100,	0x0F

	;---------------------------------------
	; Finish process
	;---------------------------------------
	jmp	$

.s0	db	" Hello, kernel!",	0
ALIGN 4,	db	0
FONT_ADR:	dd	0
;**********************************************
; Moduel
;**********************************************
%include	"../modules/protect/vga.s"
%include	"../modules/protect/draw_char.s"
%include	"../modules/protect/draw_font.s"
%include	"../modules/protect/draw_str.s"
%include	"../modules/protect/draw_color_bar.s"
%include	"../modules/protect/draw_pixel.s"
%include	"../modules/protect/draw_line.s"

;**********************************************
; Padding
;**********************************************
	times	KERNEL_SIZE - ($ - $$)	db	0
