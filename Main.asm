section .data
	m1 db '**********************************', 10, 13, '$'
	m2 db 'BIENVENIDO - SELECCIONE UNA OPCION', 10, 13, '$'
	m3 db '   1 - Ingresar', 10, 13, '$'
	m4 db '   2 - Registrar', 10, 13, '$'
	m5 db '   3 - Salir', 10, 13, '$'
	
	uno db 'uno', 0
	igs db 'ES IGUAL', 10, 13, '$'
	ign db 'NO ES IGUAL', 10, 13, '$'
	
	len db 10	;LONGITUD
	act	db 0	;SE GUARDARA LA CANTIDAD DE CARACTERES INGRESADOS
	bf db 10 dup 0
	
org 100h							
section .text 		
global _start		

%macro mostrarMenu 0
	mov ah, 09h
	mov dx, m1
	int 21h
	mov dx, m2
	int 21h
	mov dx, m3
	int 21h
	mov dx, m4
	int 21h
	mov dx, m5
	int 21h
	mov dx, m1
	int 21h
%endmacro	

%macro getDato 0
	mov ah, 0ah
	mov dx, len
	int 21h
	
	mov ah, 02h
	mov dl, 10
	int 21h
	
	mov dl, 13
	int 21h
	
	mov bx, act
	mov dx, bf
	add dl, byte[bx]
	mov bx, dx
	mov byte[bx], 0
%endmacro

_start:				
	mostrarMenu
	getDato
	
	mov ax, uno  ; compare input with msg variable
	mov si,ax          ; SI is the first string
	mov ax,bf 
	mov di,ax          ; DI is the second string, it shouldn't matter what order.
	mov ax,121Eh    ; function number
	int 2Fh
	mov ah, 09h
	jnz sig
	mov dx, igs
		jmp fin
	sig:
		mov dx, ign
		
	
	fin:
	int 21h
	mov ah, 4ch
	int 21h
end	

