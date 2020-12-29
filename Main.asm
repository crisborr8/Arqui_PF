org 100h	
%include "data.asm"
%include "bss.asm"
%include "login.asm"	
%include "user.asm"
%include "admin.asm"
%include "getData.asm"	
%include "errors.asm"	
%include "extra.asm"		
				
section .text 		
global _start		

_start:				
	mostrarMenu_Principal
	getChar
	salto
	
	cmp al, 49
	je uno
	cmp al, 50
	je dos
	cmp al, 51
	je fin
	errorMain
	call _start
	
;----------------------------------------
fin:
	mov ah, 09h
	mov dx, ads
	int 21h
	mov ah, 4ch
	int 21h
;----------------------------------------
uno:
	ingresar
	call _start
;----------------------------------------
dos:
	registrar
	call _start
