;---------------------------------------------
; Initialize interrupt vector
;---------------------------------------------
ALIGN 4
IDTR:	dw	8 * 256 - 1			; idt_limit
	dd	VECT_BASE			; idt location

;---------------------------------------------
; Initialize interrupt table
;---------------------------------------------
init_int:
	;-------------------------------------
	; Save register
	;-------------------------------------
	push	eax
	push	ebx
	push	ecx
	push	edi

	;-------------------------------------
	; Set default process for all interruptiojn
	;-------------------------------------
	lea	eax,	[int_default]		; EAX = interuption process address
	mov	ebx,	0x0008_8E00		; EBX = segment selector
	xchg	ax,	bx			; eXCHanGe lower bit

	mov	ecx,	256
	mov	edi,	VECT_BASE
.10L:
	mov	[edi + 0],	ebx
	mov	[edi + 4],	eax
	add	edi,	8
	loop	.10L

	;-------------------------------------
	; Set interrupt descriptor
	;-------------------------------------
	lidt	[IDTR]

	;-------------------------------------
	; Recover register
	;-------------------------------------
	pop	edi
	pop	ecx
	pop	ebx
	pop	eax

	ret


int_default:
	pushf
	push	cs
	push	int_stop

	mov	eax,	.s0
	iret

.s0	db	" <    STOP    > ",	0

int_stop:
	;-------------------------------------
	; Show strings in EAX
	;-------------------------------------
	cdecl	draw_str,	25,	15,	0x060F,	eax

	;-------------------------------------
	; Convert stack data to string
	;-------------------------------------
	mov	eax,	[esp + 0]
	cdecl	itoa,	eax,	.p1,	8,	16,	0b0100

	mov	eax,	[esp + 4]
	cdecl	itoa,	eax,	.p2,	8,	16,	0b0100

	mov	eax,	[esp + 8]
	cdecl	itoa,	eax,	.p3,	8,	16,	0b0100

	mov	eax,	[esp + 12]
	cdecl	itoa,	eax,	.p4,	8,	16,	0b0100

	;-------------------------------------
	; Show string
	;-------------------------------------
	cdecl	draw_str,	25,	16,	0x0F04,	.s1
	cdecl	draw_str,	25,	17,	0x0F04,	.s2
	cdecl	draw_str,	25,	18,	0x0F04,	.s3
	cdecl	draw_str,	25,	19,	0x0F04,	.s4

	;-------------------------------------
	; Infinite loop
	;-------------------------------------
	jmp	$

.s1	db	"ESP+ 0:"
.p1	db	"________ ",	0
.s2	db	"   + 4:"
.p2	db	"________ ",	0
.s3	db	"   + 8:"
.p3	db	"________ ",	0
.s4	db	"   +12:"
.p4	db	"________ ",	0

int_zero_div:
	pushf
	push	cs
	push	int_stop
	mov	eax,	.s0
	iret

.s0	db	" <  ZERO DIV  > ",	0
