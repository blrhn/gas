SYSEXIT = 1
SYSWRITE = 4
SYSREAD = 3
STDOUT = 1
EXIT_SUCCESS = 0

.text

star: .ascii "\033[32m* " # green
star_len = . - star
space: .ascii " "
space_len = . - space
newline: .ascii "\n"
newline_len = . - newline
trunk: .ascii "\033[33m*" # brown
trunk_len = . - trunk
 

.global _start

_start: 
	mov $0, %edi # row counter

rows:
	cmp $4, %edi # 4 rows
	jae prepare_trunk
	
	mov $4, %esi
	sub %edi, %esi
	shl $1, %esi
	dec %esi # space counter 2*(rows - edi) - 1

draw_space: # print space
	cmp $0, %esi
	jle prepare_stars
	
	mov $SYSWRITE, %eax
	mov $STDOUT, %ebx
	mov $space, %ecx
	mov $space_len, %edx
	int $0x80

	dec %esi
	jmp draw_space

prepare_stars: # stars counter
	mov %edi, %esi
	shl $1, %esi
	inc %esi # 2*esi(edi) + 1

draw_stars: # stars printout
	cmp $0, %esi
	jle print_newline
	
	mov $SYSWRITE, %eax
	mov $STDOUT, %ebx
	mov $star, %ecx
	mov $star_len, %edx
	int $0x80

	dec %esi
	jmp draw_stars

print_newline: # new line after printing out all stars
	mov $SYSWRITE, %eax
	mov $STDOUT, %ebx
	mov $newline, %ecx
	mov $newline_len, %edx
	int $0x80

	inc %edi
	jmp rows
	
prepare_trunk: # trunk printout
	mov $0, %edi # trunk counter

draw_trunk:
	cmp $2, %edi # how many stars in a trunk
	jae end
	
	mov $4, %esi # rows
	shl %esi
	dec %esi # 2 * esi - 1 - > how much space is needed before a star

trunk_space:
	cmp $0, %esi
	jle trunk_star

	mov $SYSWRITE, %eax
	mov $STDOUT, %ebx
	mov $space, %ecx
	mov $space_len, %edx
	int $0x80

	dec %esi
	jmp trunk_space

trunk_star:
	mov $SYSWRITE, %eax
	mov $STDOUT, %ebx
	mov $trunk, %ecx
	mov $trunk_len, %edx
	int $0x80
	
	# nowa linia
	mov $SYSWRITE, %eax
	mov $STDOUT, %ebx
	mov $newline, %ecx
	mov $newline_len, %edx
	int $0x80

	inc %edi
	jmp draw_trunk

end:
	mov $SYSEXIT, %eax
	mov $EXIT_SUCCESS, %ebx
	int $0x80