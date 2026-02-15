SYSWRITE = 4
SYSREAD = 3
STDOUT = 1
STDIN = 0
SYSEXIT = 1
EXIT_SUCCESS = 0
FILE_OPEN = 5
READ_ONLY = 0
READ = 3
CLOSE = 6
WRITE = 4
WRITE_ONLY = 1

.bss
.lcomm buffer, 256

.lcomm encoded_buffer, 256

.data

input: .string "input.txt"
output: .string "output.txt"

key: .byte 0x9d

.text

.global _start

_start:
	# open(*pathname, flags)
	mov $FILE_OPEN, %eax
	mov $input, %ebx
	mov $READ_ONLY, %ecx
	int $0x80

	# read(fd, *buf, count)
	mov %eax, %ebx
	mov $READ, %eax
	mov $buffer, %ecx
	mov $256, %edx
	int $0x80

	mov %eax, %esi
	dec %esi # actual text length without newline character
	
	# close(fd)
	mov $CLOSE, %eax
	int $0x80
		
	mov $0, %ecx # array counter
encode:
	mov buffer(, %ecx, 1), %ah
	xorb key, %ah
	
	mov %ah, encoded_buffer(, %ecx, 1)

	inc %ecx
	cmp %ecx, %esi 
	jge encode

save_to_file:
	mov $FILE_OPEN, %eax
	mov $output, %ebx
	mov $WRITE_ONLY, %ecx
	int $0x80

	# write(fd, *buf, count)
	mov %eax, %ebx
	mov $WRITE, %eax
	mov $encoded_buffer, %ecx
	mov %esi, %edx
	int $0x80

	mov $CLOSE, %eax
	int $0x80

end:
	mov $SYSEXIT, %eax
	mov $EXIT_SUCCESS, %ebx
	int $0x80