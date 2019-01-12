;**********************************************************************
; ASMOS -- Assembly Operating System
; 
; Esto esta cargado desde el Bootloader.bin como kernel.bin
; Y estan las llamadas de los archivos y funciones
; ********************************************************************

        [BITS 16]    ; Le dice a Assembler que trabaje en "Real mode" (16 bit mode)
        

        %DEFINE ASMOS_VER 'ASMOS 16-Bit, version 1.0.0b'   ; Version del sistema Operativo 
        %DEFINE OS_NAME   'ASMOS'                               ; Nombre del sistema opeativo
        %DEFINE ASMOS_API_VER 16	; API version for programs to check

        
       disk_buffer        equ      24576 ; 24 Kb


; *******************************************************************
; Llamadas a las funciones

    
boot_screen:

    mov ax, start_os
    mov bx, os_info
    

    call os_clear_screen
    jmp os_command_line

 ; DECLARACION DE DATOS
        
        start_os db 'Bienvenido a Nuesto S.O.!',0
        press_key db '>>> Presiona una Tecla para Continuar <<<', 0

        login_username db 'Usuario    : ',0
        login_password db 'Contrasena : ',0

        os_name db 'ASMOS',0
        os_info db 10, 'ASMOS 16-Bit, version = 1.0.0',13,0


; ********************************************************************


; SYSTEM VARIABLES -- Settings for programs and system calls


	; ; Time and date formatting

	fmt_12_24	db 1		; Non-zero = 24-hr format

	fmt_date	db 1, '/'	; 0, 1, 2 = M/D/Y, D/M/Y or Y/M/D
	; 				; Bit 7 = use name for months
	; 				; If bit 7 = 0, second byte = separator character

; ********************************************************************
;   INCLUSION DE ARCHIVOS
        ; PROPIO 
        ; %INCLUDE "00-boot/boot.asm"
        %INCLUDE "02-video/string.asm"
	%INCLUDE "02-video/screen.asm"
        %INCLUDE "03-shell/CommandLine.asm"
        
        ; GUIA 
 	%INCLUDE "06-Other/disk.asm"
	%INCLUDE "06-Other/keyboard.asm"
	%INCLUDE "06-Other/math.asm"
	%INCLUDE "06-Other/misc.asm"
	%INCLUDE "06-Other/ports.asm"
	%INCLUDE "06-Other/sound.asm"
	%INCLUDE "06-Other/basic.asm"


;********************************************************************

; FIN DEL KERNEL

; ********************************************************************