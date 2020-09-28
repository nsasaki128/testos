	BOOT_LOAD	equ	0x7C00

	ORG	BOOT_LOAD

;********************************************
; Macro
;********************************************
%include	"../include/macro.s"

entry:
	jmp	ipl

	;-------------------------------------
	;BPB(BIOS Parameter Block)
	;-------------------------------------
	times	90 - ($ - $$)	db	0x90

	;-------------------------------------
	;IPL(Initial Program Loader)
	;-------------------------------------
ipl:
	cli					; CLear Interrupt Flag

	mov	ax,	0x0000			; AX = 0x0000;
	mov	ds,	ax			; DS = 0x0000;
	mov	es,	ax			; ES = 0x0000;
	mov	ss,	ax			; SS = 0x0000;
	mov	sp,	BOOT_LOAD

	sti					; SeT Interrupt Flag

	mov	[BOOT.DRIVE],	dl		; Save boot drive

	;-------------------------------------
	; Show string
	;-------------------------------------
	cdecl	puts,	.s0

	;-------------------------------------
	; Show number
	;-------------------------------------
	cdecl	itoa,	8086,	.s1,	8,	10,	0b0001	; "    8086"
	cdecl	puts,	.s1

	cdecl	itoa,	8086,	.s1,	8,	10,	0b0011	; "+   8086"
	cdecl	puts,	.s1

	cdecl	itoa,	-1,	.s1,	8,	10,	0b0001	; "-      1"
	cdecl	puts,	.s1

	cdecl	itoa,	-1,	.s1,	8,	10,	0b0000	; "   65535"
	cdecl	puts,	.s1

	cdecl	itoa,	-1,	.s1,	8,	16,	0b0000	; "    FFFF"
	cdecl	puts,	.s1

	cdecl	itoa,	12,	.s1,	8,	2,	0b0100	; "00001100"
	cdecl	puts,	.s1

	;-------------------------------------
	; Finish Processing
	;-------------------------------------
	jmp 	$

	;-------------------------------------
	; Data
	;-------------------------------------
.s0	db	"Booting...",	0x0A,	0x0D,	0
.s1	db	"--------",	0x0A,	0x0D,	0

ALIGN	2,	db	0
BOOT:						; Information about boot drive
.DRIVE:	dw	0				; drive number

;********************************************
; Module
;********************************************
%include	"../modules/real/puts.s"
%include	"../modules/real/itoa.s"

;********************************************
; Boot Flag (end of first 512 byte)
;********************************************
	times	510 - ($ - $$)	db	0x00
	db	0x55,	0xAA
