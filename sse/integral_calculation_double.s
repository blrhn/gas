SYSEXIT = 60
EXIT_SUCCESS = 0

.bss

.data

n: .int 5000
a: .double 3.0
b: .double 5.0
amb: .double 0
dx: .double 0.0
result: .double 0.0

.align 64

one: .double 1.0, 1.0
two: .double 2.0, 2.0
i: .double 1.0, 2.0

.text

.global _start

_start:	
	movsd b, %xmm0
	subsd a, %xmm0
	movsd %xmm0, amb

	cvtsi2sd n, %xmm1
	divsd %xmm1, %xmm0
	movsd %xmm0, dx

	mov $2500, %ecx

	movapd i, %xmm0
	
	movsd a, %xmm1
	shufpd $0x0,  %xmm1, %xmm1

	movsd amb, %xmm2
	shufpd $0x0, %xmm2, %xmm2

	cvtsi2sd n, %xmm3
	shufpd $0x0, %xmm3, %xmm3

	movsd dx, %xmm4
	shufpd $0x0, %xmm4, %xmm4

calc_points:
	# x0 + (i*amb/n)
	# x0 + ((i+1)*amb/n)

	movapd %xmm0, %xmm5
	mulpd %xmm2, %xmm5
	divpd %xmm3, %xmm5
	addpd %xmm1, %xmm5

	movapd %xmm5, %xmm6
	mulpd %xmm6, %xmm6
	addpd one, %xmm6
	sqrtpd %xmm6, %xmm6

	mulpd %xmm4, %xmm6
	
	haddpd %xmm6, %xmm7
	shufpd $0x01, %xmm7, %xmm7
	
	addsd %xmm7, %xmm8

	addpd two, %xmm0
	loop calc_points
	
	movsd %xmm8, result

	
end:
	mov $SYSEXIT, %rax
	mov $EXIT_SUCCESS, %rdi
	syscall