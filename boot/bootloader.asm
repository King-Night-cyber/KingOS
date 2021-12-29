[org 0x7c00]
KERNEL_OFFSET equ 0x1000            ; Memory offset where the kernel is

  mov [BOOT_DRIVE], dl              ; BIOS loads BOOT_DRIVE in dl
  
  mov bp, 0x9000                    ; Setting up stack at 0x9000
  mov sp, bp
  
  call clear_screen
  
  call newline
  
  mov si, REAL_MODE                 ; Say we successfully started in 16 bits real mode
  call print
  
  call newline
  
  call load_kernel                  ; Loading kernel in memory
  
  call switch_pm                    ; Switching to 32 bits protected mode
  
  jmp $

%include "drivers/print.asm"
%include "drivers/disk.asm"
%include "drivers/gdt.asm"
%include "drivers/prot_mode.asm"

[bits 16]

load_kernel:                        ; Load kernel
  mov si, LOAD_KERNEL
  call print
  
  mov bx, KERNEL_OFFSET             ; Parameters for load_disk routine
  mov dh, 10
  mov dl, [BOOT_DRIVE]
  call load_disk
  
  ret

[bits 32]

BEGIN_PM:
  mov ebx, PROT_MODE_OK
  call print_32m                    ; Say we are officially in 32 bits protected mode
  
  call KERNEL_OFFSET                ; Jmp to the kernel position
  
  jmp $

BOOT_DRIVE          db 0
REAL_MODE           db "Started in 16 bits mode...", 0
PROT_MODE_OK        db "Landed in 32 bits protected mode...", 0
LOAD_KERNEL         db "Loading Kernel into memory...", 0

times 510-($-$$) db 0               ; Pad the remaining space with zeros
dw 0xaa55                           ; Boot signature
