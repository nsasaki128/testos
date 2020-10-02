
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
%include	"../modules/real/lba_chs.s"
%include	"../modules/real/read_chs.s"
%include	"../modules/real/read_lba.s"

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
%include	"../modules/real/kbc.s"

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
	jmp	stage_4

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
; Boot Process 4th stage
;**********************************************
stage_4:

	;---------------------------------------
	; Show string
	;---------------------------------------
	cdecl	puts,	.s0

	;---------------------------------------
	; Enable A20 gate
	;---------------------------------------
	cli

	cdecl	KBC_Cmd_Write,	0xAD

	cdecl	KBC_Cmd_Write,	0xD0
	cdecl	KBC_Data_Read,	.key

	mov	bl,	[.key]
	or	bl,	0x02

	cdecl	KBC_Cmd_Write,	0xD1
	cdecl	KBC_Data_Write,	bx

	cdecl	KBC_Cmd_Write,	0xAE

	sti

	;---------------------------------------
	; Showi A20 finish message
	;---------------------------------------
	cdecl	puts,	.s1

	;---------------------------------------
	; keyboard LED test
	;---------------------------------------
	cdecl	puts,	.s2

	mov	bx,	0
.10L:
	mov	ah,	0x00
	int	0x16

	cmp	al,	'1'
	jb	.10E

	cmp	al,	'3'
	ja	.10E

	mov	cl,	al
	dec	cl
	and	cl,	0x03
	mov	ax,	0x0001
	shl	ax,	cl
	xor	bx,	ax

	;---------------------------------------
	; Send LED command
	;---------------------------------------
	cli

	cdecl	KBC_Cmd_Write,	0xAD

	cdecl	KBC_Data_Write,	0xED
	cdecl	KBC_Data_Read,	.key

	cmp	[.key],	byte	0xFA
	jne	.11F

	cdecl	KBC_Data_Write,	bx
	jmp	.11E
.11F:
	cdecl	itoa,	word[.key],	.e1,	2,	16,	0b0100
	cdecl	puts,	.e0

.11E:
	cdecl	KBC_Cmd_Write,	0xAE

	sti

	jmp	.10L
.10E:

	;---------------------------------------
	; Showi LED finish message
	;---------------------------------------
	cdecl	puts,	.s3

	;---------------------------------------
	; Finish process
	;---------------------------------------
	jmp	stage_5

	;---------------------------------------
	; Data
	;---------------------------------------
.s0	db	"4th stage...",	0x0A,	0x0D,	0
.s1	db	" A20 Gate Enalbed.",	0x0A,	0x0D,	0
.s2	db	" Keyboard LED Test...",	0
.s3	db	" (done)",	0x0A,	0x0D,	0
.e0	db	"["
.e1	db	"ZZ]",	0

.key:	dw	0

;**********************************************
; Boot Process 5th stage
;**********************************************
stage_5:

	;---------------------------------------
	; Show string
	;---------------------------------------
	cdecl	puts,	.s0

	;---------------------------------------
	; Read kernel
	;---------------------------------------
	cdecl	read_lba,	BOOT,	BOOT_SECT,	KERNEL_SECT,	BOOT_END
	cmp	ax,	KERNEL_SECT

.10Q:
	jz	.10E
.10T:
	cdecl	puts,	.e0
	call	reboot
.10E:

	;---------------------------------------
	; Finish process
	;---------------------------------------
	jmp	stage_6

	;---------------------------------------
	; Data
	;---------------------------------------
.s0	db	"5th stage...",	0x0A,	0x0D,	0
.e0	db	" Failure load kernel...", 0x0A, 0x0D, 0

;**********************************************
; Boot Process 6th stage
;**********************************************
stage_6:

	;---------------------------------------
	; Show string
	;---------------------------------------
	cdecl	puts,	.s0

	;---------------------------------------
	; Wait user input
	;---------------------------------------
.10L:
	mov	ah,	0x00
	int	0x16
	cmp	al, ' '
	jne	.10L

	;---------------------------------------
	; Settings for video mode
	;---------------------------------------
	mov	ax,	0x0012
	int	0x10

	;---------------------------------------
	; Finish process
	;---------------------------------------
	jmp	stage_7

	;---------------------------------------
	; Data
	;---------------------------------------
.s0	db	"6th stage...",	0x0A,	0x0D,	0x0A,	0x0D
	db	" [Push SPACE key to protect mode...]", 0x0A, 0x0D, 0


;**********************************************
; GLOBAL DESCRRIPTOR TABLE
;**********************************************
ALIGN 4,	db	0
GDT:	dq	0x00_0_0_0_0_000000_0000	; NULL
.cs:	dq	0x00_C_F_9_A_000000_FFFF	; CODE segment 4G
.ds:	dq	0x00_C_F_9_2_000000_FFFF	; DATA segment 4G
.gdt_end:

;==============================================
; Selector
;==============================================
SEL_CODE	equ	.cs - GDT
SEL_DATA	equ	.ds - GDT

;==============================================
; GDT
;==============================================
GDTR:	dw	GDT.gdt_end - GDT - 1
	dd	GDT

;==============================================
; IDT (mimick for prohibiting interruption
;==============================================
IDTR:	dw	0
	dd	0

;**********************************************
; Boot Process 7th stage
;**********************************************
stage_7:

	cli
	;---------------------------------------
	; GDT load
	;---------------------------------------
	lgdt	[GDTR]
	lidt	[IDTR]

	;---------------------------------------
	; Change Protect mode
	;---------------------------------------
	mov	eax,	cr0
	or	ax,	1
	mov	cr0,	eax

	jmp	$ + 2				; Clear lookahead

	;---------------------------------------
	; Jump among Segment
	;---------------------------------------
[BITS 32]
	DB	0x66				; Operand size override prefix
	jmp	SEL_CODE:CODE_32

;**********************************************
; Start 32bit code
;**********************************************
CODE_32:

	;---------------------------------------
	; Initialise selector
	;---------------------------------------
	mov	ax,	SEL_DATA
	mov	ds,	ax
	mov	es,	ax
	mov	fs,	ax
	mov	gs,	ax
	mov	ss,	ax

	;---------------------------------------
	; Copy kernel part
	;---------------------------------------
	mov	ecx,	(KERNEL_SIZE) / 4
	mov	esi,	BOOT_END
	mov	edi,	KERNEL_LOAD
	cld
	rep	movsd

	;---------------------------------------
	; Finish process
	;---------------------------------------
	jmp	KERNEL_LOAD


;**********************************************
; Padding
;**********************************************
	times	BOOT_SIZE - ($ - $$)	db	0	; 8K byte

