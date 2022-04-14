	global _start

    %include "ansi.asm"
    %include "string.asm"
    %include "mem.asm"
    %include "output.asm"
    %include "input.asm"
    section .text

_start:
    call save_termios
    call echo_off
    call canonical_off

    call hide_cursor
	call draw_board

main:
    mov r12, 0xff0000
    mov rdi, r12
    call set_foreground_color
gameloop:
    mov rsi, input_buffer
    call get_char
    cmp rax, 0
    jle gameloop

    movzx rax, byte [input_buffer]
    jmp qword [switch+rax*8]
switch.end:

    movzx rdi, word [horizontal]
    lea rdi, [rdi*2+2]
    mov rsi, buffer
    call write_set_cursor
    mov byte [rsi+rax], 'O'
    lea rdx, [rsi+rax+1]
    sub rdx, buffer
    mov rsi, buffer
    call write_stdout

gameloop.end:
    jmp gameloop

cleanup:
    call show_cursor
    call restore_termios
    call reset_attributes

exit:
    mov rax, 60
    xor rdi, rdi
    syscall

left:
    movzx rax, word [horizontal]
    test rax, rax
    jz .next
    dec word [horizontal]
.next:
    jmp switch.end

right:
    movzx rax, word [horizontal]
    cmp rax, 6
    jz .next
    inc word [horizontal]
.next:
    jmp switch.end

quit:
    jmp cleanup

place:
    movzx rax, word [horizontal]
    lea rdi, [rax*2+2]
    imul rax, bytes_per_row
    add rax, slots
    xor rdx, rdx
    cmp dword [rax], 0
    jnz gameloop.end
fall:
    inc rdx
    cmp rdx, depth
    jz .end
    cmp dword [rax+rdx*4], 0
    jz fall
.end:
    mov dword [rax+(rdx-1)*4], r12d
    inc rdx
    shl rdx, 16
    or rdi, rdx
    mov rsi, buffer
    call write_set_cursor
    add rsi, rax
    mov rdi, r12
    call write_foreground_color
    mov byte [rsi+rax], 'O'
    lea rdx, [rsi+rax+1]
    sub rdx, buffer
    mov rsi, buffer
    call write_stdout
    xchg r12d, dword [color]
    jmp switch.end

draw_board:
    mov rdi, 0x00010001
    mov rsi, buffer
    call write_set_cursor
    lea rdi, [rsi+rax]
    call write_erase_from_cursor
    lea rsi, [rdi+rax]
    mov rdi, FOREGROUND_COLOR
    call write_foreground_color
    add rsi, rax
    mov rdi, BACKGROUND_COLOR
    call write_background_color
    lea rdi, [rsi+rax]

    mov rsi, board
    mov rcx, board_len
    call memcpy

    mov rdx, rdi
    mov rsi, buffer
    sub rdx, buffer
    call write_stdout

    ret

	section .data
BACKGROUND_COLOR equ 0x000000
FOREGROUND_COLOR equ 0xffffff
rows:  equ 6
cols:  equ 7
width  equ cols
bytes_per_row: equ cols * 4
bytes_per_col: equ rows * 4
depth: equ rows

horizontal: dw 0
color: dd 0xffff00

switch:
times 32  dq switch.end
dq place
times 48  dq switch.end
dq quit
times 15  dq switch.end
dq left
times 2   dq switch.end
dq right
times 155 dq switch.end

board:
db "               ", 0x0a
db "| | | | | | | |", 0x0a
db "| | | | | | | |", 0x0a
db "| | | | | | | |", 0x0a
db "| | | | | | | |", 0x0a
db "| | | | | | | |", 0x0a
db "| | | | | | | |", 0x0a
db " - - - - - - - ", 0x0a
board_len: equ $ - board

slots:
times (rows+1) * cols dd 0

    section .bss
buffer:       resb 256
input_buffer: resb 32
