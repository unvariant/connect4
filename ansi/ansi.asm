    %IFNDEF _ANSI_ASM_
    %DEFINE _ANSI_ASM_

    %include "cursor.asm"
    %include "attributes.asm"
    %include "screen.asm"
    section .text

	section .data
_separator: equ ';'
CSI:        equ 0x5b1b
CSI_len     equ 2

_cmd_buffer: times 32 db 0

    %ENDIF
