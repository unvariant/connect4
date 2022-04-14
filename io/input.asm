    %IFNDEF _INPUT_ASM_
    %DEFINE _INPUT_ASM_

    %include "arch.asm"
    section .text

canonical_off:
    call read_stdin_termios

    ; clear canonical bit in local mode flags
    and dword [termios+12], ~ICANON

    call write_stdin_termios
    ret

echo_off:
    call read_stdin_termios

    ; clear echo bit in local mode flags
    and dword [termios+12], ~ECHO

    call write_stdin_termios
    ret

canonical_on:
    call read_stdin_termios

    ; set canonical bit in local mode flags
    or dword [termios+12], ICANON

    call write_stdin_termios
    ret

echo_on:
    call read_stdin_termios

    ; set echo bit in local mode flags
    or dword [termios+12], ECHO

    call write_stdin_termios
    ret

read_stdin_termios:
    mov rdx, termios
    call get_termios

    ret

write_stdin_termios:
    mov rdx, termios
    call set_termios

    ret

; rdx - termios struct
get_termios:
    mov rax, SYS_IOCTL
    mov rdi, STDIN
    mov rsi, 0x5401
    syscall            ; ioctl(0, 0x5401, rdx)

    ret

; rdx - termios struct
set_termios:
    mov rax, SYS_IOCTL
    mov rdi, STDIN
    mov rsi, 5402h
    syscall            ; ioctl(0, 0x5402, rdx)

    ret

save_termios:
    mov rdx, old_termios
    call get_termios

    ret

restore_termios:
    mov rdx, old_termios
    call set_termios

    ret

; rsi - destination buffer
; rdx - number of bytes to read
; clobber - rdi
; return  - number of bytes read or err code
read_stdin:
    mov rax, SYS_READ
    mov rdi, STDIN
    syscall

    ret

; rsi - destinatin buffer
; clobber - rdi, rdx
; return  - number of bytes read or err code
get_char:
    mov rdx, 1
    call read_stdin

    ret


    section .bss
old_termios:    resb 36
termios:        resb 36

    %ENDIF
