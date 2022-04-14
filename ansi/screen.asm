	%IFNDEF _SCREEN_ASM_
	%DEFINE _SCREEN_ASM_

    section .text


clear_screen:
	push rdi
	push rsi

	xor rdi, rdi
	mov rsi, _cmd_buffer
	call write_set_cursor
    lea rsi, [rsi+rax]
    mov rdi, rsi
    call write_erase_from_cursor
    lea rdx, [rsi+rax]
    mov rsi, _cmd_buffer
    sub rdx, _cmd_buffer
    call write_stdout

    pop rsi
    pop rdi
    ret

; rdi - destination buffer
; clobber - nothing
; return  - number of bytes written
write_erase_from_cursor:
    push rdi
    push rsi

    mov rsi, _erase_from_cursor
    call strcpy

    pop rsi
    pop rdi
    ret


    section .data
_erase_from_cursor: db 0x1b, "[J", 0
_erase_from_cursor_len equ $ - _erase_from_cursor - 1
    %ENDIF
