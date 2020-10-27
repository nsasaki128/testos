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
	; Call default interrupt process
	;---------------------------------------
	push	0x11223344			; dummy
	pushf					; save EFLAGS
	call	0x0008:int_default

	;---------------------------------------
	; Finish process
	;---------------------------------------
	jmp	$

.s0	db	" Hello, kernel! ",	0
ALIGN 4,	db	0
FONT_ADR:	dd	0
RTC_TIME:	dd	0
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
%include	"../modules/protect/draw_rect.s"
%include	"../modules/protect/itoa.s"
%include	"../modules/protect/rtc.s"
%include	"../modules/protect/draw_time.s"
%include	"modules/interrupt.s"

;**********************************************
; Padding
;**********************************************
	times	KERNEL_SIZE - ($ - $$)	db	0
