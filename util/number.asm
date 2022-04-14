    %IFNDEF _NUMBER_ASM_
    %DEFINE _NUMBER_ASM_

    section .text

; rdi - unsigned number
; rsi - buffer
; clobber - nothing
; return  - number of bytes written
fast_itoa:
	push rsi
	push rbx
	push rcx
	push rdx

	mov rcx, 0xcccccccccccccccd
	mov rax, rdi
	mov rdi, rsi
	xor rsi, rsi

.loop:
    mov rbx, rax
	mul rcx
	shr rdx, 3
	mov rax, rdx
	lea rdx, [rdx*4+rdx]
	shl rdx, 1
	sub rbx, rdx
	shl rsi, 8
	add bl, 0x30
	mov sil, bl
	test rax, rax
	jnz .loop

	mov qword [rdi], rsi
    mov rax, 8
	lzcnt rdx, rsi
	shr rdx, 3
    sub rax, rdx

	pop rdx
	pop rcx
	pop rbx
	pop rsi
	ret

    %ENDIF
