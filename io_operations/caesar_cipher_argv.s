SYSWRITE = 1
SYSREAD = 0
STDOUT = 1
STDIN = 0
SYSEXIT = 60
EXIT_SUCCESS = 0
FILE_OPEN = 2
READ_ONLY = 0
READ = 0
CLOSE = 3
WRITE = 1
WRITE_ONLY = 1

.bss
.lcomm buffer, 256

.lcomm encoded_buffer, 256

.data

output: .string "output.txt"

key: .byte 0x9d

.text

.global _start

_start:
    # argv
	mov 16(%rsp), %rdi
	push 24(%rsp)

	# open(*pathname, flags)
	mov $FILE_OPEN, %rax
	mov $READ_ONLY, %rsi
	syscall	

	# read(fd, *buf, count)
	mov %rax, %rdi
	mov $READ, %rax
	mov $buffer, %rsi
	mov $256, %rdx
	syscall

	mov %rax, %r10
	dec %r10 # actual text length without newline character	
	
	# close(fd)
	mov $CLOSE, %rax
	syscall
		
	mov $0, %rcx # array counter
encode:
	mov buffer(, %rcx, 1), %al
	xorb key, %al
	
	mov %al, encoded_buffer(, %rcx, 1)

	inc %rcx
	cmp %rcx, %r10 
	jge encode

save_to_file:
	pop %rdi
	mov $FILE_OPEN, %rax
	mov $WRITE_ONLY, %rsi
	syscall

	# write(fd, *buf, count)
	mov %rax, %rdi
	mov $WRITE, %rax
	mov $encoded_buffer, %rsi
	mov %r10, %rdx

	syscall

	mov $CLOSE, %rax
	syscall

end:
	mov $SYSEXIT, %rax
	mov $EXIT_SUCCESS, %rdi
	syscall