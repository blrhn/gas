SYSWRITE = 4
SYSREAD = 3
STDOUT = 1
STDIN = 0
SYSEXIT = 1
EXIT_SUCCESS = 0


.bss
.lcomm string, 10

.lcomm new_string, 10

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

change:
	mov $0, %edi
	mov $10, %ecx
	mov $0, %edx

change_loop:
	mov string(,%edi,1), %ah
	
	cmp $90, %ah
	jg increment
	cmp $65, %ah
	jl increment
	
	mov %ah, new_string(,%edx,1)
	inc %edx
	

increment:
	inc %edi
	loop change_loop
	
	
end:
	mov $SYSEXIT, %eax
	mov $EXIT_SUCCESS, %ebx
	int $0x80