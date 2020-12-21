section .data
	m1 db '**********************************', 10, 13, '$'
	m2 db 'BIENVENIDO - SELECCIONE UNA OPCION', 10, 13, '$'
	m3 db '   1 - Ingresar', 10, 13, '$'
	m4 db '   2 - Registrar', 10, 13, '$'
	m5 db '   3 - Salir', 10, 13, '$'
	
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
	mov ah, 0ah	;LECTURA DEL BUFFER
	mov dx, len	;VA PRIMERO LA LONGITUD DEL STRING
	int 21h		;DEVUELVE EN DX LA CADENA INGRESADA
	
	mov ah, 02h ;SALIDA DE CARACTER EN ASCCI
	mov dl, 10 	;CARACTER EN ASCII SALTO DE LINEA
	int 21h
	mov dl, 13	;RETORNO DE CARRO
	int 21h
	
	mov bx, act	;SE GUARDA LA CANTIDAD DE CARACTERES INGRESADOS
	mov dx, bf	;APUNTA AL INICIO DE BF
	add dl, byte[bx]	;AÑADE LA LONGITUD A BX (ACT), EN BYTE O SE AGREGARA EL NUMERO EN 16BITS
	mov bx,dx 			;MUEVE EL PUNTERO A BX
	mov byte[bx], '$'	;FINAL DE LA CADENA
%endmacro

_start:				
	mostrarMenu
	getDato
	
	mov ah, 09h
	mov dx, bf
	int 21h
	
	cmp dx, '1$'
	jne sig
		mov dx, igs
		jmp fin
	sig:
		mov dx, ign
		
	int 21h
	
	fin:
	mov ah, 4ch
	int 21h
end	

