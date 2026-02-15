SYSEXIT = 1
EXIT_SUCCESS = 0

.bss
.lcomm  variable, 16 # 16 bytes allocation

.text

.global _start

_start:
	mov $1, %eax    # immediate data movement (1) operation to eax register
	mov $25, %ebx   # immediate data movement (25) operation to ebx register
	mov $0xd, %ecx	# immediate data movement (d) operation to ecx register

	movl $2, variable # immediate data movement (2) operation to memory (variable)

	mov $SYSEXIT, %eax
	mov $EXIT_SUCCESS, %ebx
	int $0x80