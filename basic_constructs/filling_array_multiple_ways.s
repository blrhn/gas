SYSEXIT = 1
EXIT_SUCCESS = 0

.bss
.lcomm tab, 4

.text

.global _start

_start:
	mov $tab, %edi
	mov $4, %ecx
	
fill:
	mov %ecx, (%edi)
	inc %edi
	loop fill

direct:
	mov tab, %ah
	mov tab+1, %ah
	mov tab+2, %ah
	mov tab+3, %ah
	

indexed:
	mov $0, %edi
	mov $4, %ecx
indexed_loop:
	mov tab(,%edi,1), %ah
	inc %edi
	loop indexed_loop


base_pointer:
	mov $0, %edi
	mov $4, %ecx
base_pointer_loop:
	mov tab(%edi), %ah
	inc %edi
	loop base_pointer_loop


base_pointer_shift:
    # shift = 0
	mov $4, %ecx
	mov $tab, %edi
base_pointer_shift_loop:
	mov 0(%edi), %ah
	inc %edi
	loop base_pointer_shift_loop
	

base_pointer_sh_scale:
	# shift = 0
	mov $4, %ecx
	mov $tab, %edi
base_pointer_sh_scale_loop:
	mov 0(, %edi, 1), %ah
	inc %edi
	loop base_pointer_sh_scale_loop
	
end:
	mov $SYSEXIT, %eax
	mov $EXIT_SUCCESS, %ebx
	int $0x80