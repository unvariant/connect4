    %IFNDEF _MEM_ASM_
    %DEFINE _MEM_ASM_

    section .text


; rdi - destination
; rsi - source
; rcx - number of bytes to copy
; clobber - rdi, rsi, rcx
; return  - nothing
; copies rcx bytes from rsi into rdi
; TODO: optimize
memcpy:
    cld
    rep movsb
    ret

    %ENDIF
