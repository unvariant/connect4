    %IFNDEF _CURSOR_ASM_
    %DEFINE _CURSOR_ASM_

    %include "number.asm"
    %include "string.asm"
    %include "output.asm"
    section .text


; clobber - nothing
; return  - nothing
show_cursor:
	push rdi
	push rsi
	push rdx

	mov rsi, _show_cursor
	mov rdx, _show_cursor_len
	call write_stdout

	pop rdx
	pop rsi
	pop rdi
	ret

; rdi - buffer to write to 
; clobber - rdi, rsi
; return  - number of bytes written
write_show_cursor:
    push rdi
    push rsi

	call _write_show_cursor

    pop rsi
    pop rdi
	ret

_write_show_cursor:
    mov rsi, _show_cursor
    call strcpy
    ret

; clobber - nothing
; return  - nothing
hide_cursor:
	push rdi
	push rsi
	push rdx
	
   	mov rsi, _hide_cursor
   	mov rdx, _hide_cursor_len
   	call write_stdout

	pop rdx
	pop rsi
	pop rdi
   	ret

; rdi - buffer to write to
; clobber - rdi, rsi
; return  - number of bytes written
write_hide_cursor:
    push rdi
    push rsi

	call _write_hide_cursor

    pop rsi
    pop rdi
	ret

_write_hide_cursor:
    mov rsi, _hide_cursor
    call strcpy
    ret

; rdi - second word holds row
; rdi - first  word holds col
; clobber - nothing
; return  - nothing
set_cursor:
	push rdi
	push rsi
	push rdx

	mov rsi, _cmd_buffer
	call _write_set_cursor
    mov rdx, rsi
	mov rsi, _cmd_buffer
    sub rdx, _cmd_buffer
	call write_stdout

	pop rdx
	pop rsi
	pop rdi
	ret

; rdi - second word holds row
; rdi - first  word holds col
; rsi - buffer to write to
; clobber - nothing
; return  - number of bytes written
write_set_cursor:
	push rdi
	push rsi
    push rdx

	call _write_set_cursor
    mov rax, rsi
    sub rax, qword [rsp+8]

    pop rdx
	pop rsi
    pop rdi
	ret

_write_set_cursor:
    mov rdx, rdi
    mov word [rsi], CSI
	add rsi, 2
	shr rdi, 16
	call fast_itoa
	mov byte [rsi+rax], _separator
	lea rsi, [rsi+rax+1]
	mov rdi, rdx
	and rdi, 0xffff
	call fast_itoa
	mov byte [rsi+rax], _set_cursor
    lea rsi, [rsi+rax+1]

    ret

; rdi - number of characters to move
; clobber - nothing
; return  - nothing
cursor_up:
    push rbx

    mov rbx, CURSOR_UP
    call cursor_move

    pop rbx
    ret

; rdi - number of character to move
; clobber - nothing
; return  - nothing
cursor_down:
    push rbx

    mov rbx, CURSOR_DOWN
    call cursor_move

    pop rbx
    ret

; rdi - number of characters to move
; clobber - nothing
; return  - nothing
cursor_right:
    push rbx

    mov rbx, CURSOR_RIGHT
    call cursor_move

    pop rbx
    ret

; rdi - number of characters to move
; clobber - nothing
; return  - nothing
cursor_left:
    push rbx

    mov rbx, CURSOR_LEFT
    call cursor_move

    pop rbx
    ret

; rdi - number of characters to move
; rbx - direction
; clobber - rbx
; return  - nothing
cursor_move:
    push rdi
    push rsi
    push rdx

    mov rsi, _cmd_buffer
    call write_cursor_move

    mov rsi, _cmd_buffer
    mov rdx, rax
    call write_stdout

    pop rdx
    pop rsi
    pop rdi
    ret

; rdi - number of characters to move
; rsi - buffer to write to
; rbx - direction
; clobber - rdi, rsi
; return  - number of bytes written
write_cursor_move:
    push rdi
    push rsi

    mov word [rsi], CSI
    add rsi, 2
    call fast_itoa
    mov byte [rsi+rax], bl
    lea rax, [rsi+rax+1]
    sub rax, qword [rsp]

    pop rsi
    pop rdi
    ret


    section .data
    _set_cursor   equ 'H'
    CURSOR_UP     equ 'A'
    CURSOR_DOWN   equ 'B'
    CURSOR_RIGHT  equ 'C'
    CURSOR_LEFT   equ 'D'

_show_cursor: db 0x1b, "[?25h", 0
_show_cursor_len equ $ - _show_cursor - 1
_hide_cursor: db 0x1b, "[?25l", 0
_hide_cursor_len equ $ - _hide_cursor - 1

    %ENDIF

