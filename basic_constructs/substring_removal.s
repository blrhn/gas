SYSWRITE = 4
SYSREAD = 3
STDOUT = 1
STDIN = 0
SYSEXIT = 1
EXIT_SUCCESS = 0

.bss
.lcomm string, 10

.lcomm sub, 3

.lcomm new_string, 10

.text

msg: .ascii "Type in a random text (length of 10):\n"
msg_len = . - msg

msg_two: .ascii "Text to remove from given text (length of 3):\n"
msg_two_len = . - msg_two

.global _start

_start:
	mov $SYSWRITE, %eax
	mov $STDOUT, %ebx
	mov $msg, %ecx
	mov $msg_len, %edx
	int $0x80

	mov $SYSREAD, %eax
	mov $STDIN, %ebx
	mov $string, %ecx
	mov $10, %edx
	int $0x80

	mov %eax, %esi
	dec %esi # actual text length without newline character
	
	mov $SYSWRITE, %eax
	mov $STDOUT, %ebx
	mov $msg_two, %ecx
	mov $msg_two_len, %edx
	int $0x80

	mov $SYSREAD, %eax
	mov $STDIN, %ebx
	mov $sub, %ecx
	mov $3, %edx
	int $0x80

delete:
	mov $0, %edi
	mov $0, %ecx

delete_loop:
	cmp %edi, %esi
	jle end

	mov %edi, %ebx
	add $2, %ebx # if substring can fit
	cmp %ebx, %esi
	jl rewrite

check_first:
	mov $0, %edx
	mov string(, %edi, 1), %ah
	mov sub(, %edx, 1), %al;

	cmp %ah, %al
	jne rewrite

check_second:
	mov $1, %edx
	mov %edi, %ebx
	inc %ebx
	
	mov string(, %ebx, 1), %ah
	mov sub(, %edx, 1), %al

	cmp %al, %ah
	jne rewrite

check_third:
	mov $2, %edx	
	inc %ebx

	mov string(, %ebx, 1), %ah
	mov sub(, %edx, 1), %al

	cmp %al, %ah
	jne rewrite

	add $3, %edi
	jmp delete_loop

rewrite:
	mov string(, %edi, 1), %ah
	mov %ah, new_string(, %ecx, 1)
	inc %ecx
	inc %edi
	jmp delete_loop

end:
	mov $SYSEXIT, %eax
	mov $EXIT_SUCCESS, %ebx
	int $0x80