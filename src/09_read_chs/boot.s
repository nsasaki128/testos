
;**********************************************
; Macro
;**********************************************
%include	"../include/define.s"
%include	"../include/macro.s"

	ORG	BOOT_LOAD

entry:
	jmp	ipl

	;---------------------------------------
	;BPB(BIOS Parameter Block)
	;---------------------------------------
	times	90 - ($ - $$)	db	0x90

	;---------------------------------------
	;IPL(Initial Program Loader)
	;---------------------------------------
ipl:
	cli						; CLear Interrupt Flag

	mov	ax,	0x0000				; AX = 0x0000;
	mov	ds,	ax				; DS = 0x0000;
	mov	es,	ax				; ES = 0x0000;
	mov	ss,	ax				; SS = 0x0000;
	mov	sp,	BOOT_LOAD

	sti						; SeT Interrupt Flag

	mov	[BOOT + drive.no],	dl		; Save boot drive

	;---------------------------------------
	; Show string
	;---------------------------------------
	cdecl	puts,	.s0

	;---------------------------------------
	; Read rest sectors
	;---------------------------------------
	mov	bx,	BOOT_SECT - 1
	mov	cx,	BOOT_LOAD + SECT_SIZE

	cdecl	read_chs,	BOOT,	bx,	cx

	cmp	ax,	bx
.10Q:	jz	.10E
.10T:	cdecl	puts,	.e0
	call	reboot
.10E:

	;---------------------------------------
	; Go to next stage
	;---------------------------------------
	jmp 	stage_2

	;---------------------------------------
	; Data
	;---------------------------------------
.s0	db	"Booting...",	0x0A,	0x0D,	0
.e0	db	"Error:sector read",	0x0A,	0x0D,	0

;**********************************************
; Information about Boot drive
;**********************************************
ALIGN	2,	db	0
BOOT:
	istruc	drive
	    at	drive.no,	dw	0
	    at	drive.cyln,	dw	0
	    at	drive.head,	dw	0
	    at	drive.sect,	dw	2
	iend

;**********************************************
; Module
;**********************************************
%include	"../modules/real/puts.s"
%include	"../modules/real/reboot.s"
%include	"../modules/real/read_chs.s"

;**********************************************
; Boot Flag (end of first 512 byte)
;**********************************************
	times	510 - ($ - $$)	db	0x00
	db	0x55,	0xAA

;**********************************************
; Boot Process 2nd stage
;**********************************************
stage_2:
	;---------------------------------------
	; Show string
	;---------------------------------------
	cdecl	puts,	.s0

	;---------------------------------------
	; Finish process
	;---------------------------------------
	jmp	$

	;---------------------------------------
	; Data
	;---------------------------------------
.s0	db	"2nd stage...",	0x0A,	0x0D,	0

;**********************************************
; Padding
;**********************************************
	times	BOOT_SIZE - ($ - $$)	db	0	; 8K byte

