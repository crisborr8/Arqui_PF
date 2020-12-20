section .data
	m1 db '**********************************', 10, 13, '$'
	m2 db 'BIENVENIDO - SELECCIONE UNA OPCION', 10, 13, '$'
	m3 db '   1 - Ingresar', 10, 13, '$'
	m4 db '   2 - Registrar', 10, 13, '$'
	m5 db '   3 - Salir', 10, 13, '$'
	
	igs db 'ES IGUAL', 10, 13, '$'
	ign db 'NO ES IGUAL', 10, 13, '$'
	
	len db 10
	act db 0
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
	mov ah, 0ah				;FUNCION DE LECTURA
	mov dx, len				;TAMAÑO DEL BUFFER
	int 21h
	
	mov ah,02h				;SALIDA DE CARACTER
	mov dl,10				;SALTO DE LINEA ASCII
	int 21h
	mov dl,13				;RETORNO DE CARRO
	int 21h
	
	mov bx, act    			;PUNTERO DEL TAMAÑO DEL TEXTO
	mov dx, bf 				;PUNTERO DEL INICIO DEL CARACTER EN DX
	add dl, byte[bx]     	;AGREGAR LA LONGITUD DEL PUNTERO DE CARACTER
							; we need ^ the "byte" otherwise we will be adding the full 16bit number at that location.
	mov bx,dx            	;MUEVE EL PUNTERO DX A BC
	mov byte[bx],'$'    	;AGREGAMOS EL FINAL DE LINEA $.
%endmacro

_start:				
	mostrarMenu
	getDato
	mov ah, 09h
	mov dx, bf
	cmp dx, '1'
	jne noUno
	mov dx, igs
	jmp sig
	
	noUno:
		mov dx, ign
	sig:
	int 21h
	mov dx, bf
	int 21h
	
	mov ah, 4ch
	int 21h
end	

