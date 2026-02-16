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
i: .int 1
one: .int 1
temp_x: .float 0.0
format: .ascii "%f\n"
d_result: .double 0
.text

.global main
.extern printf

main:
	flds b
	fsubs a
	fstps amb

	flds amb
	fidivs n
	fstps dx 

	mov $5000, %ecx
calc_points:
	flds amb
	fimuls i
	fidivs n
	fadds a

	fsts temp_x
	
	fmuls temp_x
	fiadds one
	fsqrt

	fmuls dx

	fadds result
	fstps result

	filds i
	fiadds one
	fistps i	

	loop calc_points

print:
	flds result
	fstpl d_result

	sub $8, %rsp
	mov $1, %rax
	lea format, %rdi
	movsd d_result, %xmm0
	call printf

end:
	mov $SYSEXIT, %rax
	mov $EXIT_SUCCESS, %rdi
	syscall