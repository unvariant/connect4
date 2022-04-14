    %IFNDEF _COLOR_ASM_

    %include "output.asm"
    section .text


; no arguments
reset_attributes:
    mov rsi, _reset_attributes
    mov rdx, _reset_attributes_len
    call write_stdout
    ret

; rdi - buffer to write to
; clobber - nothing
; return  - number of bytes written
write_reset_attributes:
    push rdi
    push rsi

    mov rsi, _reset_attributes
    call strcpy

    pop rsi
    pop rdi
    ret

; rdi - color
set_foreground_color:
    push rdi
    push rsi
    push rdx

    mov rsi, _cmd_buffer
    mov rdx, _foreground_select
    call _write_color

    mov rdx, rsi
    mov rsi, _cmd_buffer
    sub rdx, _cmd_buffer
    call write_stdout

    pop rdx
    pop rsi
    pop rdi
    ret

; rdi - color
; rsi - buffer to write to
; clobber - rdi, rsi
; return  - number of bytes written
write_foreground_color:
    push rdi
    push rsi
    push rdx

    mov rdx, _foreground_select
    call _write_color

    mov rax, rsi
    sub rax, qword [rsp+8]

    pop rdx
    pop rsi
    pop rdi
    ret

; rdi - color
set_background_color:
    push rdi
    push rsi
    push rdx

    mov rsi, _cmd_buffer
    mov rdx, _background_select
    call _write_color

    mov rdx, rsi
    mov rsi, _cmd_buffer
    sub rdx, _cmd_buffer
    call write_stdout

    pop rdx
    pop rsi
    pop rdi
    ret

write_background_color:
    push rdi
    push rsi
    push rdx

    mov rdx, _background_select
    call _write_color

    mov rax, rsi
    sub rax, qword [rsp+8]

    pop rdx
    pop rsi
    pop rdi
    ret

; rdi - color
; rsi - buffer
; rdx - foreground/background selector
; clobber - nothing
; return  - number of bytes written
write_color:
    push rdi
    push rsi
    push rdx

    call _write_color
    mov rax, rsi
    sub rax, qword [rsp]

    pop rdx
    pop rsi
    pop rdi
    ret

; red    - third byte of rdi
; green  - second byte of rdi
; blue   - first byte of rdi
; rsi    - destination buffer
; rdx    - (fore|back)ground selector
; clobber - rdi, rsi, rdx
; return  - updates pointer is rsi
_write_color:
    mov word [rsi], CSI
    add rsi, CSI_len
    mov qword [rsi], rdx
    add rsi, 5
    mov rdx, rdi
    and rdi, 0xff0000
    shr rdi, 16
    call fast_itoa
    mov byte [rsi+rax], _separator
    lea rsi, [rsi+rax+1]
    mov rdi, rdx
    and rdi, 0xff00
    shr rdi, 8
    call fast_itoa
    mov byte [rdi+rax], _separator
    lea rsi, [rsi+rax+1]
    mov rdi, rdx
    and rdi, 0xff
    call fast_itoa
    mov byte [rsi+rax], _graphics_attributes
    lea rsi, [rsi+rax+1]

    ret

; destination buffer in rdi
write_set_underline:
    push rdi
    push rsi

    mov rsi, _set_underline
    call strcpy

    pop rsi
    pop rdi
    ret

; destination buffer in rdi
write_clear_underline:
    push rdi
    push rsi

    mov rsi, _clear_underline
    call strcpy

    pop rsi
    pop rdi
    ret


    section .data
_graphics_attributes   equ 'm'
_foreground_select     equ 0x0000003b323b3833
_background_select     equ 0x0000003b323b3834

_reset_attributes:     db 0x1b, "[0m", 0
_reset_attributes_len: equ $ - _reset_attributes - 1
_set_underline:        db 0x1b, "[4m", 0
_set_underline_len:    equ $ - _set_underline
_clear_underline:      db 0x1b, "[24m", 0
_clear_underline_len   equ $ - _clear_underline

    %ENDIF
