SYSWRITE = 1
SYSREAD = 0
STDOUT = 1
STDIN = 0
SYSEXIT = 60
EXIT_SUCCESS = 0
FILE_OPEN = 2
CLOSE = 3
WRITE = 1
WRITE_ONLY = 1
APPEND = 1024

.bss
.data
.lcomm tabx, 1000 * 1000 * 4
.lcomm taby, 1000 * 1000 * 4
.lcomm results, 4
.lcomm str_results, 32
.lcomm str_results_reversed, 32
.lcomm file_fd, 8

#output: .string "rowsoutput.csv"
output: .string "columnsoutput.csv"
newline: .string "\n"

.text


row_array:
	mov $0, %r14 # i
fill_row_i:
	mov $0, %r13 # j
fill_row_j:
	mov %r14, %rax
	mul %r15
	add %r13, %rax
	
	mov %r13, tabx(, %rax, 4)
	
	inc %r13
	cmp %r15, %r13
	jl fill_row_j

	inc %r14
	cmp %r15, %r14
	jl fill_row_i

	ret

column_array:
	mov $0, %r14
fill_col_i:
	mov $0, %r13
fill_col_j:
	mov %r13, %rax
	mul %r15
	add %r14, %rax

	mov %r14, taby(, %rax, 4)

	inc %r13
	cmp %r15, %r13
	jl fill_col_j
	
	inc %r14
	cmp %r15, %r14
	jl fill_col_i

	ret
	

num_to_str:
	# w rax
	
	xor %rdx, %rdx
	div %rcx # przez 10
	add $48, %rdx
	mov %rdx, str_results(, %r9, 1)
	inc %r9

	cmp $0, %rax
	jz end_num

	jmp num_to_str

end_num:
	push %r9
	dec %r9
	mov $0, %r8
write_reversed:
	movb str_results(, %r9, 1), %al
	movb %al, str_results_reversed(, %r8, 1)
	cmp $0, %r9
	jz end_reverse
	dec %r9
	inc %r8
	jmp write_reversed
end_reverse:
	
	pop %r9
	ret

clear_results:
	mov $0, %r8
clear_str_results:
	movb $0, str_results(, %r8, 1)
	movb $0, str_results_reversed(, %r8, 1)
	inc %r8
	cmp $32, %r8
	jl clear_str_results
	ret

write_results:
	call clear_results
	mov $0, %r9
	mov $10, %rcx
	call num_to_str	
label:
	mov file_fd, %rdi
	mov $WRITE, %rax
	mov $str_results_reversed, %rsi
	mov %r9, %rdx
	syscall

	mov file_fd, %rdi
	mov $WRITE, %rax
	mov $newline, %rsi
	mov $1, %rdx
	syscall	

	ret

.global _start

_start:
	
	mov $FILE_OPEN, %rax
	mov $output, %rdi
	mov $(WRITE_ONLY | APPEND), %rsi
	syscall
	mov %rax, file_fd

	mov $4, %r15 # size
	mov $10, %rcx # 10 tries

test_row_sizes:
	mov $0, %r10
	mov $10, %rcx
test_row_ten:
	rdtsc
	shl $32, %rdx
	or %rdx, %rax
	mov %rax, %r12 # row start
	
	#call row_array
	call column_array
	
	rdtsc
	shl $32, %rdx
	or %rdx, %rax
	mov %rax, %r11 # row end

	sub %r12, %r11
	add %r11, %r10 # clock cycles sum

	loop test_row_ten
	
get_avg:
	mov %r10, %rax
	xor %rdx, %rdx
	mov $10, %rcx
	div %rcx

	call write_results

	inc %r15
	cmp $1000, %r15
	jle test_row_sizes
	
	mov $CLOSE, %rax
	mov file_fd, %rdi
	syscall	

end:
	mov $SYSEXIT, %rax
	mov $EXIT_SUCCESS, %rdi
	syscall
	