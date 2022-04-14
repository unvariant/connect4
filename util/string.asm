    %IFNDEF _STRING_ASM_
    %DEFINE _STRING_ASM_

    section .text


; rdi - destination buffer
; rsi - source buffer
; clobber - rdi, rsi
; return  - number of bytes written
strcpy:
    push rsi
    cmp byte [rsi], 0
    jz .end

    cld
.loop:
    movsb
    cmp byte [rsi], 0
    jnz .loop

.end:
    mov rax, rsi
    sub rax, qword [rsp]
    add rsp, 8
    ret

    %ENDIF
