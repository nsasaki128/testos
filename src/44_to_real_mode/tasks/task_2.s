task_2:
	;---------------------------------------
	; Show string
	;---------------------------------------
	cdecl	draw_str,	63,	1,	0x07,	.s0

	fild	dword	[.c1000]
	fldpi
	fidiv	dword	[.c180]
	fldpi
	fadd	st0,	st0
	fldz

.10L:
	;---------------------------------------
	; sin θ
	;---------------------------------------
	fadd	st0,	st2
	fprem
	fld	st0
	fsin
	fmul	st0,	st4
	fbstp	[.bcd]

	;---------------------------------------
	; Show value
	;---------------------------------------
	mov	eax,	[.bcd]
	mov	ebx,	eax

	and	eax,	0x0F0F
	or	eax,	0x3030

	shr	ebx,	4
	and	ebx,	0x0F0F
	or	ebx,	0x3030

	mov	[.s2 + 0],	bh
	mov	[.s3 + 0],	ah
	mov	[.s3 + 1],	bl
	mov	[.s3 + 2],	al

	mov	eax,	7
	bt	[.bcd + 9],	eax
	jc	.10F

	mov	[.s1 + 0],	byte	'+'
	jmp	.10E
.10F:
	mov	[.s1 + 0],	byte	'-'
.10E:
	cdecl	draw_str,	72,	1,	0x07,	.s1
	;---------------------------------------
	; Wait
	;---------------------------------------
	cdecl	wait_tick,	10

	jmp	.10L

	;---------------------------------------
	; data
	;---------------------------------------

ALIGN 4,	db	0
.c1000:	dd	1000
.c180:	dd	180

.bcd:	times	10	db	0x00

.s0	db	"Task-2",	0
.s1:	db	"-"
.s2:	db	"0,"
.s3:	db	"000",	0
