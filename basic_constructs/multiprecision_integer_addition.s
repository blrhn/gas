SYSWRITE = 4
SYSREAD = 3
STDOUT = 1
SYSEXIT = 1
EXIT_SUCCESS = 0


.data

number1:
	.long 0xdddddddd#, 0xdd220101
	number1_len = .-number1
	no_numbers1 = number1_len / 4

number2:
	.long 0x220011a0, 0x12332101
	number2_len = .-number2
	no_numbers2 = number2_len / 4

.bss
carry:
	.space 4

result:
	.space number2_len + 4

.text

.global _start

_start:
	movl $no_numbers2, %ebx
	movl $no_numbers1, %esi
	movl $no_numbers2, %edi

add_loop:
	# esi - number1
	# edi - number2
	
	dec %ebx
	dec %esi
	dec %edi

	movl number1(, %esi, 4), %eax
	adcl number2(, %edi, 4), %eax
	
	movl %eax, result(, %ebx, 4)
	
	cmp $0, %esi
	jz add_edi
	
	cmp $0, %edi
	jz add_esi

	jmp add_loop

add_edi:
	cmp $0, %edi
	jz end

	dec %ebx
	dec %edi 

	movl number2(, %edi, 4), %eax
	adcl $0, %eax
	movl %eax, result(, %ebx, 4)
	jmp add_edi
	
add_esi:
	cmp $0, %esi
	jz end

	dec %ebx
	dec %edi

	movl number1(, %esi, 4), %eax
	adcl $0, %eax
	movl %eax, result(, %ebx, 4)
	jmp add_esi


end:
	mov $SYSEXIT, %eax
	mov $EXIT_SUCCESS, %ebx
	int $0x80