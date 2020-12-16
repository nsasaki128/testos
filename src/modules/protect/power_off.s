power_off:
	;-------------------------------------
	; Save register
	;-------------------------------------
	push	eax
	push	ebx
	push	ecx
	push	edx
	push	esi

	;-------------------------------------
	; Show message
	;-------------------------------------
	cdecl	draw_str,	25,	14,	0x020F,	.s0

	;-------------------------------------
	; Paging disable
	;-------------------------------------
	mov	eax,	cr0
	and	eax,	0x7FFF_FFFF
	mov	cr0,	eax
	jmp	$ + 2

	;-------------------------------------
	; Check ACPI data
	;-------------------------------------
	mov	eax,	[0x7C00 + 512 + 4]
	mov	ebx,	[0x7C00 + 512 + 8]
	cmp	eax,	0
	je	.10E

	;-------------------------------------
	; Find RSDT table
	;-------------------------------------
	cdecl	acpi_find,	eax,	ebx,	'RSDT'

	cmp	eax,	0
	je	.10E

	;-------------------------------------
	; Find FACP table
	;-------------------------------------
	cdecl	find_rsdt_entry,	eax,	'FACP'
	cmp	eax,	0
	je	.10E

	mov	ebx,	[eax + 40]
	cmp	ebx,	0
	je	.10E

	;-------------------------------------
	; Save ACPI register
	;-------------------------------------
	mov	ecx,	[eax + 64]
	mov	[PM1a_CNT_BLK],	ecx

	mov	ecx,	[eax + 68]
	mov	[PM1b_CNT_BLK],	ecx

	;-------------------------------------
	; Search S5 name space
	;-------------------------------------
	mov	ecx,	[ebx + 4]
	sub	ecx,	36
	add	ebx,	36
	cdecl	acpi_find,	ebx,	ecx,	'_S5_'
	cmp	eax,	0
	je	.10E

	;-------------------------------------
	; Get package data
	;-------------------------------------
	add	eax,	4
	cdecl	acpi_package_value,	eax
	mov	[S5_PACKAGE],	eax

.10E:

	;-------------------------------------
	; Paging enable
	;-------------------------------------
	mov	eax,	cr0
	or	eax,	(1 << 31)
	mov	cr0,	eax
	jmp	$ + 2

	;-------------------------------------
	; Get ACPI register
	;-------------------------------------
	mov	edx,	[PM1a_CNT_BLK]
	cmp	edx,	0
	je	.20E

	;-------------------------------------
	; Show count down
	;-------------------------------------
	cdecl	draw_str,	38,	14,	0x020F,	.s3
	cdecl	wait_tick,	100
	cdecl	draw_str,	38,	14,	0x020F,	.s2
	cdecl	wait_tick,	100
	cdecl	draw_str,	38,	14,	0x020F,	.s1
	cdecl	wait_tick,	100

	;-------------------------------------
	; PM1a_CNT_BLK settings
	;-------------------------------------
	movzx	ax,	[S5_PACKAGE.0]
	shl	ax,	10
	or	ax,	1 << 13
	out	dx,	ax

	;-------------------------------------
	; Check PM1b_CNT_BLK
	;-------------------------------------
	mov	edx,	[PM1b_CNT_BLK]
	cmp	edx,	0
	je	.20E

	;-------------------------------------
	; PM1b_CNT_BLK settings
	;-------------------------------------
	movzx	ax,	[S5_PACKAGE.1]
	shl	ax,	10
	or	ax,	1 << 13
	out	dx,	ax
.20E:
	;-------------------------------------
	; Wait shut down
	;-------------------------------------
	cdecl	wait_tick,	100

	;-------------------------------------
	; Shut down failure message
	;-------------------------------------
	cdecl	draw_str,	38,	14,	0x020F,	.s4

	;-------------------------------------
	; Recover register
	;-------------------------------------
	pop	esi
	pop	edx
	pop	ecx
	pop	ebx
	pop	eax

	ret

.s0	db	" Power off...   ", 0
.s1	db	" 1",	0
.s2	db	" 2",	0
.s3	db	" 3",	0
.s4	db	"NG",	0

ALIGN 4,	db	0
PM1a_CNT_BLK:	dd	0
PM1b_CNT_BLK:	dd	0
S5_PACKAGE:
.0:	db	0
.1:	db	0
.2:	db	0
.3:	db	0
