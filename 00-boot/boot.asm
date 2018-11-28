; Bootloader 
[bits 16]    ; Le dice a Assembler que trabaje en "Real mode" (16 bit mode)
[org 0x7C00] ; localiza 0x7C00 en la memoria donde la BIOS lo cargará


start:                  ; Etiqueta donde comienza el codigo
        xor ax,ax       ; pone el registro ax en 0
        mov ds,ax       ; pone semgmentos en 0
        mov es,ax       ; pone mas segmentos en 0
        mov bx, 0x8000

        mov ax,0x13         ;clears the screen
	int 0x10            ;call bios video interrupt

        mov ah,02           ;clear the screen with big font
        int 0x10            ; display interrupt

        
        ;****************************************************
        ;INTRO

        mov ah,0x02         ; set value for change to cursor position
	mov bh,0x00         ; page
	mov dh,0x06         ; y cordinate/row
	mov dl,0x12         ; x cordinate/col
	int 0x10

        mov si, os_name
        call _print_string_white

        mov ax,0x00     ; Obtiene el input del teclado como getchar()
        int 0x16   


        ;*******************************************
        ; DECLARACION DE LA SEGUNDA INSTANCIA
        ; saltar de Real Mode a Protected Mode
        ; Usando la interrupcion de disco

        mov ah, 0x02    ; Carga la segunda instancia en la memoria
        mov al, 0x10    ; el numero de sectoes que se cargaran en la memoria
        mov dl, 0x80    ; sectores que leera el usb
        mov ch, 0       ; cylender number
        mov dh, 0       ; head number
        mov cl, 2       ; sector number
        mov bx, _Start  ; carga los segmentos offset de buffer
        int 0x13        ; interrupcion de I/O en el disco

       

        cli             ; Limpia las interrupciones antes del salto
        jmp _Start      ; Salta a modo protegido

        ; *****************************************
        ; DECLARACION DE DATOS
        
        start_os db 'Bienvenido a Nuesto S.O.!',0
        press_key db '>>> Presiona una Tecla para Continuar <<<', 0

        login_username db 'Usuario    : ',0
        login_password db 'Contrasena : ',0

        os_name db 'ASMOS',0
        os_info db 10, 'ASMOS 16-Bit, version = 1.0.0',13,0



        

_print_string:
	mov ah, 0x0E            ; Este valor le dice que tome el valor de al y lo imprima

.repeat_next_char:
	lodsb   			 ; get character from string
	cmp al, 0             		 ; cmp al with end of string
	je .done_print		    	 ; if char is zero, end of string
	int 0x10                	 ; otherwise, print it
	jmp .repeat_next_char   	 ; jmp to .repeat_next_char if not 0

.done_print:
	ret                 	    ;return

       

_print_string_white:
	mov bl,15
	mov ah, 0x0E

.repeat_next_char:
	lodsb
	cmp al, 0
	je .done_print
	int 0x10
	jmp .repeat_next_char

.done_print:
	ret

 ;*****************************************
        ; "Numeros magicos"
                times (510 - ($ - $$)) db 0x00
                dw 0xAA55


;***************************************************************************************

; X86 code 
_Start:

        mov al,2                    ; set font to normal mode
	mov ah,0                    ; clear the screen
	int 0x10                    ; call video interrupt

	mov cx,0                    ; initialize counter(cx) to get input


        ;****** display display_text on screen

                ;set x y position to text
                mov ah,0x02
                mov bh,0x00
                mov dh,0x08             ; Y
                mov dl,0x12             ; X
                int 0x10


                mov si, start_os		;display display_text on screen
                call _print_string


                ;set x y position to text
                mov ah,0x02
                mov bh,0x00
                mov dh,0x09
                mov dl,0x12
                int 0x10

                mov si, os_info		;display os_info on screen
                call _print_string

                ;set x y position to text
                mov ah,0x02
                mov bh,0x00
                mov dh,0x11
                mov dl,0x12
                int 0x10

                mov si, press_key		;display press_key_2 on screen
                call _print_string

                mov ah,0x00
                int 0x16


        ; Limpiar pantalla 




        ;set cursor to specific position on screen
                mov ah,0x02
                mov bh,0x00
                mov dh,0x02
                mov dl,0x00
                int 0x10

                mov si,login_username          ; point si to login_username
                call _print_string              ; display it on screen

                ;****** read password

                ;set x y position to text
                mov ah,0x02
                mov bh,0x00
                mov dh,0x03
                mov dl,0x00
                int 0x10


                mov si,login_password               ; point si to login_username
                call _print_string                   ; display it on screen


; *****************************************
_getUsernameinput:

	mov ax,0x00             ; get keyboard input
	int 0x16		        ; hold for input

	cmp ah,0x1C             ; compare input is enter(1C) or not
	je .exitinput           ; if enter then jump to exitinput

	cmp ah,0x01             ; compare input is escape(01) or not
	je _skipLogin           ; jump to _skipLogin

	mov ah,0x0E             ;display input char
	int 0x10

	inc cx                  ; increase counter
	cmp cx,5                ; compare counter reached to 5
	jbe _getUsernameinput   ; yes jump to _getUsernameinput
	jmp .inputdone          ; else jump to inputdone

.inputdone:
	mov cx,0                ; set counter to 0
	jmp _getUsernameinput   ; jump to _getUsernameinput
	ret                     ; return

.exitinput:
	hlt
; *****************************************
_getPasswordinput:

	mov ax,0x00
	int 0x16

	cmp ah,0x1C
	je .exitinput
    
	cmp ah,0x01
	je _skipLogin

	inc cx

	cmp cx,5
	jbe _getPasswordinput
    
	jmp .inputdone

.inputdone:
	mov cx,0
	jmp _getPasswordinput
	ret
.exitinput:
	hlt

; *****************************************
_skipLogin:
    
        ; *****************************************
        ; load third sector into memory

	mov ah, 0x03                    ; load third stage to memory
	mov al, 1
	mov dl, 0x80
	mov ch, 0
	mov dh, 0
	mov cl, 3                       ; sector number 3
	mov bx, _Desktop_Enviroment
	int 0x13

	jmp _Desktop_Enviroment



_Desktop_Enviroment:


	mov ax,0x13              ; clears the screen
	int 0x10

