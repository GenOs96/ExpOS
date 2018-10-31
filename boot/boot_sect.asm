[org 0x7c00]
KERNEL_OFFSET equ 0x1000 

    mov [BOOT_DRIVE], dl 
    mov bp, 0x9000
    mov sp, bp

    mov bx, REAL_MODE 
    call print
    call print_nl

    call load_kernel 
    call switch_to_pm 
    jmp $ 

%include "boot_print.asm"
%include "boot_hexprint.asm"
%include "boot_disk.asm"
%include "32_bit_gdt.asm"
%include "32_bit_print.asm"
%include "32_bit_switch.asm"

[bits 16]
load_kernel:
    mov bx, KERNEL_LOAD
    call print
    call print_nl

    mov bx, KERNEL_OFFSET 
    mov dh, 16 
    mov dl, [BOOT_DRIVE]
    call disk_load
    ret

[bits 32]
BEGIN_PM:
    mov ebx, PROT_MODE
    call print_string_pm
    call KERNEL_OFFSET 
    jmp $


BOOT_DRIVE db 0 
REAL_MODE db "Started in 16-bit Real Mode", 0
PROT_MODE db "Landed in 32-bit Protected Mode", 0
KERNEL_MSG db "Loading kernel into memory", 0

times 510 - ($-$$) db 0
dw 0xaa55
