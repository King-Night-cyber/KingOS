;	16 bits mode

[bits 16]

print:
	pusha
	
	mov ah, 0Eh

print_repeat:
	lodsb
	
	cmp al, 0
	je print_done

	int 10h
	jmp print_repeat

print_done:
	popa
	ret
	
clear_screen:
	pusha

	mov dx, 0
	call move_cursor

	mov ah, 6
	mov al, 0
	mov bh, 7
	mov cx, 0
	mov dh, 24
	mov dl, 79
	int 10h

	popa
	ret

move_cursor:
	pusha

	mov bh, 0
	mov ah, 2
	int 10h

	popa
	ret

newline:
	pusha

	mov ah, 0Eh
	
	mov al, 13
	int 10h
	mov al, 10
	int 10h

	popa
	ret

; 32 bits protected mode

[bits 32]

VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

print_32m:
	pusha
	mov edx, VIDEO_MEMORY
	
print_32m_loop:
	mov al, [ebx]
	mov ah, WHITE_ON_BLACK
	
	cmp al, 0
	je print_32m_done
	
	mov [edx], ax
	
	add ebx, 1
	add edx, 2
	
	jmp print_32m_loop
	
print_32m_done:
	popa
	
	ret
