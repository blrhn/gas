SYSEXIT = 1
EXIT_SUCCESS = 0

.bss 
.lcomm tab, 100 # allocate 100 bytes

.text
# fill up 100 bytes with one
automatic: .space 100, 1


.global _start

_start:
	mov $tab, %edi
	mov $100, %ecx 
fill:	
	movl $1, (%edi) # filling up at address
	inc %edi
	loop fill	
	
end:
	mov $SYSEXIT, %eax
	mov $EXIT_SUCCESS, %ebx
	int $0x80
	