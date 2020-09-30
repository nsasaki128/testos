
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
; Inormation which is got at real mode
;**********************************************
FONT:
.seg:	dw	0
.off:	dw	0
ACPI_DATA:
.adr:	dd	0
.len:	dd	0

;**********************************************
; Module
;**********************************************
%include	"../modules/real/itoa.s"
%include	"../modules/real/get_drive_param.s"
%include	"../modules/real/get_font_adr.s"
%include	"../modules/real/get_mem_info.s"

;**********************************************
; Boot Process 2nd stage
;**********************************************
stage_2:
	;---------------------------------------
	; Show string
	;---------------------------------------
	cdecl	puts,	.s0

	;---------------------------------------
	; Get drive information
	;---------------------------------------
	cdecl	get_drive_param,	BOOT
	cmp	ax,	0
.10Q:	jne	.10E
.10T:	cdecl	puts,	.e0
	call	reboot
.10E:

	;---------------------------------------
	; Show drive information
	;---------------------------------------
	mov	ax,	[BOOT + drive.no]
	cdecl	itoa,	ax,	.p1,	2,	16,	0b0100
	mov	ax,	[BOOT + drive.cyln]
	cdecl	itoa,	ax,	.p2,	4,	16,	0b0100
	mov	ax,	[BOOT + drive.head]
	cdecl	itoa,	ax,	.p3,	2,	16,	0b0100
	mov	ax,	[BOOT + drive.sect]
	cdecl	itoa,	ax,	.p4,	2,	16,	0b0100
	cdecl	puts,	.s1

	;---------------------------------------
	; Go to next stage
	;---------------------------------------
	jmp 	stage_3

	;---------------------------------------
	; Data
	;---------------------------------------
.s0	db	"2nd stage...",	0x0A,	0x0D,	0

.s1	db	" Drive:0x"
.p1	db	"  , C:0x"
.p2	db	"    , H:0x"
.p3	db	"  , S:0x"
.p4	db	"  ",	0x0A,	0x0D,	0

.e0	db	"Can't get drive parameter,",	0

;**********************************************
; Boot Process 3rd stage
;**********************************************
stage_3:
	;---------------------------------------
	; Show string
	;---------------------------------------
	cdecl	puts,	.s0

	;---------------------------------------
	; A font used at protect mode is same
	; as the one saved at BOIS
	;---------------------------------------
	cdecl	get_font_adr,	FONT

	;---------------------------------------
	; Show font address
	;---------------------------------------
	cdecl	itoa,	word	[FONT.seg],	.p1,	4,	16,	0b0100
	cdecl	itoa,	word	[FONT.off],	.p2,	4,	16,	0b0100
	cdecl	puts,	.s1

	;---------------------------------------
	; Get and show memory information
	;---------------------------------------
	cdecl	get_mem_info,	ACPI_DATA

	mov	eax,	[ACPI_DATA.adr]
	cmp	eax,	0
	je	.10E

	cdecl	itoa,	ax,	.p4,	4,	16,	0b0100
	shr	eax,	16
	cdecl	itoa,	ax,	.p3,	4,	16,	0b0100
	cdecl	puts,	.s2
.10E:

	;---------------------------------------
	; Finish process
	;---------------------------------------
	jmp	$

	;---------------------------------------
	; Data
	;---------------------------------------
.s0	db	"3rd stage...",	0x0A,	0x0D,	0

.s1	db	" FONT Address="
.p1	db	"ZZZZ:"
.p2	db	"ZZZZ",	0x0A,	0x0D,	0
	db	0x0A,	0x0D,	0

.s2	db	" ACPI data="
.p3	db	"ZZZZ"
.p4	db	"ZZZZ",	0x0A,	0x0D,	0
;**********************************************
; Padding
;**********************************************
	times	BOOT_SIZE - ($ - $$)	db	0	; 8K byte

