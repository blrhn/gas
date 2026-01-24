SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4
STDOUT = 1
EXIT_SUCCESS = 0

.data 

msg_hello: .ascii "Hello World!\n"
msg_hello_len = . - msg_hello

.text

.global _start

_start:
	mov $msg_hello, %esi 
	mov $msg_hello_len, %ecx
	add %esi, %ecx # where msg ends
loop:
	cmp %ecx, %esi
	ja print
	mov (%esi), %ah # load value from memory address
	cmp $90, %ah
	jg increment
	cmp $65, %ah
	jl increment
	add $32, %ah
	mov %ah, (%esi) # load value to memory address
increment:
	inc %esi
	jmp loop
print:
	mov $SYSWRITE, %eax
	mov $STDOUT, %ebx
	mov $msg_hello, %ecx
	mov $msg_hello_len, %edx

	int $0x80

	mov $SYSEXIT, %eax
	mov $EXIT_SUCCESS, %ebx
	int $0x80