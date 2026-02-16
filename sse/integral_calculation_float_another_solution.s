SYSEXIT = 60
EXIT_SUCCESS = 0

.bss

.data

a: .float 0
b: .float 1
amb: .float 0
n: .int 900
dx: .float 0
result: .float 0

.align 32

one: .float 1.0, 1.0, 1.0, 1.0
two: .float 2.0, 2.0, 2.0, 2.0
i: .float 1.0, 2.0, 0.0, 0.0

.text

.global _start

_start:
	movss a, %xmm0
	movss b, %xmm1
	subss %xmm0, %xmm1
	movss %xmm1, amb

	cvtsi2ss n, %xmm2
	divss %xmm2, %xmm1
	movss %xmm1, dx # dx = (b-a)/n

	mov $450, %ecx
	
	#movss %xmm0, result #x0 = a

	movss a, %xmm4
	mulss %xmm4, %xmm4
	movss one, %xmm5
	addss %xmm4, %xmm5
	sqrtss %xmm5, %xmm5
	mulss dx, %xmm5
	movss %xmm5, %xmm0 

	movaps i, %xmm3

calc_points:
	#x0 + (  i *  (amb / n))
	#x0 + ((i+1) * amb / n)

	movss amb, %xmm4
	shufps $0x0, %xmm4, %xmm4
	movaps %xmm3, %xmm5

	mulps %xmm4, %xmm5 #amb * i

	cvtsi2ss n, %xmm4
	shufps $0x0, %xmm4, %xmm4
	divps %xmm4, %xmm5 #amb * i / n
	
	movss a, %xmm4
	shufps $0x0, %xmm4, %xmm4
	addps %xmm4, %xmm5

	# sqrt(1+xx)
	movaps %xmm5, %xmm6 #temp
	mulps %xmm6, %xmm6
	addps one, %xmm6
	sqrtps %xmm6, %xmm6
	
	movss dx, %xmm7
	shufps $0x0, %xmm7, %xmm7
	mulps %xmm7, %xmm6


	addps two, %xmm3

	loop calc_points

end:
	mov $SYSEXIT, %rax
	mov $EXIT_SUCCESS, %rdi
	syscall