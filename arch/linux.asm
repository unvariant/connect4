    %IFNDEF _LINUX_ASM_
    %DEFINE _LINUX_ASM_

    STDIN equ     0
    STDOUT equ    1

    ICANON equ    1<<1
    ECHO equ      1<<3

    SYS_READ equ  0
    SYS_WRITE equ 1
    SYS_IOCTL equ 16

    %ENDIF
