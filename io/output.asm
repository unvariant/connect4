    %IFNDEF _OUTPUT_ASM_
    %DEFINE _OUTPUT_ASM_

    %include "arch.asm"
    section .text

; rdx - length of string
; rsi - buffer to write from
write_stdout:
	mov rax, SYS_WRITE
	mov rdi, STDOUT
	syscall
	ret

    %ENDIF
