org 100h	
%include "texts.asm"
%include "login.asm"	
%include "getData.asm"	
%include "errors.asm"	
%include "extra.asm"		
				
section .text 		
global _start		

%macro mostrarMenu_Principal 0
	mov ah, 09h
	mov dx, pts
	int 21h
	mov dx, m_1
	int 21h
	mov dx, m_2
	int 21h
	mov dx, m_3
	int 21h
	mov dx, m_4
	int 21h
	mov dx, pts
	int 21h
%endmacro	


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
