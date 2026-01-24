SYSEXIT = 1
SYSWRITE = 4
SYSREAD = 3
STDOUT = 1
EXIT_SUCCESS = 0


.text
star: .ascii "*"
star_len = . - star

.global _start

_start:
	mov $0, %edi # stars counter
loop:
	cmp $5, %edi # for 5 + 1 stars printout
	ja end

	mov $SYSWRITE, %eax
	mov $STDOUT, %ebx
	mov $star, %ecx
	mov $star_len, %edx
	int $0x80
	
	inc %edi
	jmp loop

end:

	mov $SYSEXIT, %eax
	mov $EXIT_SUCCESS, %ebx
	int $0x80