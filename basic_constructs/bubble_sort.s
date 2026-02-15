SYSWRITE = 4
SYSREAD = 3
STDOUT = 1
STDIN = 0
SYSEXIT = 1
EXIT_SUCCESS = 0

.bss
.lcomm string, 10

.text

msg: .ascii "Type a text that is 10 chars long: \n"
msg_len = . - msg

.global _start

_start:
	mov $SYSWRITE, %eax
	mov $STDOUT, %ebx
	mov $msg, %ecx
	mov $msg_len, %edx
	int $0x80

	# reading 10 characters
	mov $SYSREAD, %eax
	mov $STDIN, %ebx
	mov $string, %ecx
	mov $10, %edx
	int $0x80
	
sort:
	# actual size
	mov %eax, %esi
	# omit the newline character when sorting
	sub $2, %esi
	mov %esi, %edi

sort_out_loop:
	mov $0, %ecx

sort_in_loop:
	mov string(, %ecx, 1), %al
	mov %ecx, %ebx
	inc %ebx
	mov string(, %ebx, 1), %ah

	cmp %al, %ah
	jge skip

	mov  %ah, string(, %ecx, 1)
	mov  %al, string(, %ebx, 1) 

skip:
	inc %ecx
	cmp %ecx, %esi
	jg sort_in_loop
	
	dec %edi
	jnz sort_out_loop

end:
	mov $SYSEXIT, %eax
	mov $EXIT_SUCCESS, %ebx
	int $0x80