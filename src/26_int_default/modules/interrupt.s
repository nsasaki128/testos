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
