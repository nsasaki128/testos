task_3:
	;---------------------------------------
	; Build stack frame
	;---------------------------------------
	mov	ebp,	esp

	push	dword	0
	push	dword	0
	push	dword	0
	push	dword	0
	push	dword	0

	;---------------------------------------
	; Initialize
	;---------------------------------------
	mov	esi,	0x0010_7000

	;---------------------------------------
	; Show title
	;---------------------------------------
	mov	eax,	[esi + rose.x0]
	mov	ebx,	[esi + rose.y0]

	shr	eax,	3
	shr	ebx,	4
	dec	ebx
	mov	ecx,	[esi + rose.color_s]
	lea	edx,	[esi + rose.title]

	cdecl	draw_str,	eax,	ebx,	ecx,	edx

	;---------------------------------------
	; Center of X axis
	;---------------------------------------
	mov	eax,	[esi + rose.x0]
	mov	ebx,	[esi + rose.x1]
	sub	ebx,	eax
	shr	ebx,	1
	add	ebx,	eax
	mov	[ebp - 4],	ebx

	;---------------------------------------
	; Center of Y axis
	;---------------------------------------
	mov	eax,	[esi + rose.y0]
	mov	ebx,	[esi + rose.y1]
	sub	ebx,	eax
	shr	ebx,	1
	add	ebx,	eax
	mov	[ebp - 8],	ebx

	;---------------------------------------
	; Draw X axis
	;---------------------------------------
	mov	eax,	[esi + rose.x0]
	mov	ebx,	[ebp - 8]
	mov	ecx,	[esi + rose.x1]

	cdecl	draw_line,	eax,	ebx,	ecx,	ebx,	dword [esi + rose.color_x]

	;---------------------------------------
	; Draw Y axis
	;---------------------------------------
	mov	eax,	[esi + rose.y0]
	mov	ebx,	[ebp - 4]
	mov	ecx,	[esi + rose.y1]

	cdecl	draw_line,	ebx,	eax,	ebx,	ecx,	dword [esi + rose.color_y]

	;---------------------------------------
	; Draw a frame
	;---------------------------------------
	mov	eax,	[esi + rose.x0]
	mov	ebx,	[esi + rose.y0]
	mov	ecx,	[esi + rose.x1]
	mov	edx,	[esi + rose.y1]

	cdecl	draw_rect,	eax,	ebx,	ecx,	edx,	dword [esi + rose.color_z]

	;---------------------------------------
	; An amptitude is almost 95% of X axis
	;---------------------------------------
	mov	eax,	[esi + rose.x1]
	sub	eax,	[esi + rose.x0]
	shr	eax,	1
	mov	ebx,	eax
	shr	ebx,	4
	sub	eax,	ebx

	;---------------------------------------
	; Initialize FPU
	;---------------------------------------
	cdecl	fpu_rose_init,	eax,	dword [esi + rose.n],	dword [esi + rose.d]

	;---------------------------------------
	; Main loop
	;---------------------------------------
.10L:
	;---------------------------------------
	; Calculate coordinate
	;---------------------------------------
	lea	ebx,	[ebp -12]
	lea	ecx,	[ebp -16]
	mov	eax,	[ebp -20]

	cdecl	fpu_rose_update,	ebx,	ecx,	eax

	;---------------------------------------
	; Update angle
	;---------------------------------------
	mov	edx,	0
	inc	eax
	mov	ebx,	360 * 100
	div	ebx
	mov	[ebp -20],	edx

	;---------------------------------------
	; Draw a dot
	;---------------------------------------
	mov	ecx,	[ebp -12]
	mov	edx,	[ebp -16]

	add	ecx,	[ebp - 4]
	add	edx,	[ebp - 8]

	mov	ebx,	[esi + rose.color_f]
	int 0x82
	;---------------------------------------
	; Wait
	;---------------------------------------
	cdecl	wait_tick,	1

	;---------------------------------------
	; Erase a dot
	;---------------------------------------
	mov	ebx,	[esi + rose.color_b]
	int	0x82

	jmp	.10L
	;---------------------------------------
	; data
	;---------------------------------------
ALIGN 4,	db	0
DRAW_PARAM:
.t3:
	istruc	rose
	    at	rose.x0,	dd	32
	    at	rose.y0,	dd	32
	    at	rose.x1,	dd	208
	    at	rose.y1,	dd	208

	    at	rose.n,		dd	2
	    at	rose.d,		dd	1

	    at	rose.color_x,	dd	0x0007
	    at	rose.color_y,	dd	0x0007
	    at	rose.color_z,	dd	0x000F
	    at	rose.color_s,	dd	0x030F
	    at	rose.color_f,	dd	0x000F
	    at	rose.color_b,	dd	0x0003

	    at	rose.title,	db	"Task-3",	0
	iend

.t4:
	istruc	rose
	    at	rose.x0,	dd	248
	    at	rose.y0,	dd	32
	    at	rose.x1,	dd	424
	    at	rose.y1,	dd	208

	    at	rose.n,		dd	3
	    at	rose.d,		dd	1

	    at	rose.color_x,	dd	0x0007
	    at	rose.color_y,	dd	0x0007
	    at	rose.color_z,	dd	0x000F
	    at	rose.color_s,	dd	0x040F
	    at	rose.color_f,	dd	0x000F
	    at	rose.color_b,	dd	0x0004

	    at	rose.title,	db	"Task-4",	0
	iend

.t5:
	istruc	rose
	    at	rose.x0,	dd	32
	    at	rose.y0,	dd	272
	    at	rose.x1,	dd	208
	    at	rose.y1,	dd	448

	    at	rose.n,		dd	2
	    at	rose.d,		dd	6

	    at	rose.color_x,	dd	0x0007
	    at	rose.color_y,	dd	0x0007
	    at	rose.color_z,	dd	0x000F
	    at	rose.color_s,	dd	0x050F
	    at	rose.color_f,	dd	0x000F
	    at	rose.color_b,	dd	0x0005

	    at	rose.title,	db	"Task-5",	0
	iend

.t6:
	istruc	rose
	    at	rose.x0,	dd	248
	    at	rose.y0,	dd	272
	    at	rose.x1,	dd	424
	    at	rose.y1,	dd	448

	    at	rose.n,		dd	4
	    at	rose.d,		dd	6

	    at	rose.color_x,	dd	0x0007
	    at	rose.color_y,	dd	0x0007
	    at	rose.color_z,	dd	0x000F
	    at	rose.color_s,	dd	0x060F
	    at	rose.color_f,	dd	0x000F
	    at	rose.color_b,	dd	0x0006

	    at	rose.title,	db	"Task-6",	0
	iend

fpu_rose_init:
	;---------------------------------------
	; Build stack frame
	;---------------------------------------
	push	ebp
	mov	ebp,	esp

	push	dword	180

	;---------------------------------------
	; Set FPU stack
	;---------------------------------------
	fldpi
	fidiv	dword	[ebp - 4]
	fild	dword	[ebp +12]
	fidiv	dword	[ebp +16]
	fild	dword	[ebp + 8]

	;---------------------------------------
	; Scrap stack frame
	;---------------------------------------
	mov	esp,	ebp
	pop	ebp

	ret

fpu_rose_update:
	;---------------------------------------
	; Build stack frame
	;---------------------------------------
	push	ebp
	mov	ebp,	esp

	;---------------------------------------
	; Save register
	;---------------------------------------
	push	eax
	push	ebx

	;---------------------------------------
	; Set X/Y axios
	;---------------------------------------
	mov	eax,	[ebp +  8]
	mov	ebx,	[ebp + 12]

	;---------------------------------------
	; Convert radian
	;---------------------------------------
	fild	dword	[ebp + 16]
	fmul	st0,	st3
	fld	st0

	fsincos
	fxch	st2
	fmul	st0,	st4
	fsin
	fmul	st0,	st3

	;---------------------------------------
	; x = A * sin(kθ) * cos(θ)
	;---------------------------------------
	fxch	st2
	fmul	st0,	st2
	fistp	dword	[eax]

	;---------------------------------------
	; y = A * sin(kθ) * sin(θ)
	;---------------------------------------
	fmulp	st1,	st0
	fchs
	fistp	dword	[ebx]

	;---------------------------------------
	; Recover register
	;---------------------------------------
	pop	ebx
	pop	eax

	;---------------------------------------
	; Scrap stack frame
	;---------------------------------------
	mov	esp,	ebp
	pop	ebp

	ret
