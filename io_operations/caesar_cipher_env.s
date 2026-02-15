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

env_name: .string "KEY="
env_name_len = . - env_name
input: .string "input.txt"
output: .string "output.txt"

.text

.global _start

_start:
	lea 24(%rsp), %r14

get_env:
	mov (%r14), %rdi
	cmp $0, %rdi
	je end
	
	mov $0, %rcx

compare:
	mov env_name(, %rcx, 1), %al
	cmp $0, %al
	je found_env

	mov (%rdi, %rcx, 1), %bl
	cmp %al, %bl
	jne next_env

	inc %rcx
	cmp $env_name_len, %rcx
	jl compare

next_env:
	add $8, %r14
	jmp get_env

found_env:
	mov (%r14), %rsi
	
	mov $env_name_len, %rcx
	dec %rcx

	lea (%rsi, %rcx, 1), %r9
	
	# open(*pathname, flags)
	mov $FILE_OPEN, %rax
	mov $input, %rdi
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
	xorb (%r9), %al
	
	mov %al, encoded_buffer(, %rcx, 1)

	inc %rcx
	cmp %rcx, %r10 
	jge encode

save_to_file:
	mov $FILE_OPEN, %rax
	mov $output, %rdi
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