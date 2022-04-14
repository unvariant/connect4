    %IFNDEF _MACOS_ASM_
    %DEFINE _MACOS_ASM_
    
    STDIN equ 0
    STDOUT equ 1

    %DEFINE __SYS_BASE, 0x2000000

    %MACRO macos_syscall 2
    %1 equ %2 + 0x2000000
    %ENDMACRO

    macos_syscall SYS_READ, 3
    macos_syscall SYS_WRITE, 4

    %ENDIF
