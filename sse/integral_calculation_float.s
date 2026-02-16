SYSEXIT = 60
EXIT_SUCCESS = 0

.bss

.data

a: .float 0.0
b: .float 1.0
amb: .float 0.0
n: .int 5000
dx: .float 0.0
result: .float 0.0

.align 32

one: .float 1.0, 1.0, 1.0, 1.0
two: .float 2.0, 2.0, 2.0, 2.0
i: .float 1.0, 2.0, 0.0, 0.0

.text

.global _start

_start:
	movss b, %xmm0
	subss a, %xmm0
	movss %xmm0, amb
	
	cvtsi2ss n, %xmm1
	divss %xmm1, %xmm0
	movss %xmm0, dx # dx = (b-a)/n

	mov $2500, %ecx

	movaps i, %xmm0

	movss a, %xmm1 
	shufps $0x0, %xmm1, %xmm1
	
	movss amb, %xmm2
	shufps $0x0, %xmm2, %xmm2

	cvtsi2ss n, %xmm3
	shufps $0x0, %xmm3, %xmm3
	
	movss dx, %xmm4
	shufps $0x0, %xmm4, %xmm4

calc_points:
	# x0 + (i*amb/n)
	# x0 + ((i+1)*amb/n)
	
	movaps %xmm0, %xmm5 # i
	mulps %xmm2, %xmm5 # i*amb
	divps %xmm3, %xmm5 # above / n
	addps %xmm1, %xmm5 # above + x0

	# sqrt(1+xx)
	movaps %xmm5, %xmm6
	mulps %xmm6, %xmm6
	addps one, %xmm6
	sqrtps %xmm6, %xmm6

	mulps %xmm4, %xmm6 # dx * function value
	
	movaps %xmm6, %xmm7
	shufps $0x01, %xmm7, %xmm7
	
	addss %xmm6, %xmm7
	addss %xmm7, %xmm8

	addps two, %xmm0
	loop calc_points

	movss %xmm8, result

end:
	mov $SYSEXIT, %rax
	mov $EXIT_SUCCESS, %rdi
	syscall