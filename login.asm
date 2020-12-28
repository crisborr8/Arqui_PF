%macro ingresar 0
	mov ah, 09h
	mov dx, l_1
	int 21h
	
	mov dx, l_3
	int 21h
	resetUsr
	getDatoUsr
	
	mov ah, 09h
	mov dx, l_4
	int 21h
	resetPsw
	getDatoPsw
	
	cmp cl, 1
	je %%errorPsw
	leerUsers
	call %%fin
	%%errorPsw:
		salto
		mov ah, 09h
		mov dx, er_IngrPsw
		int 21h
		salto
	%%fin:
%endmacro

%macro leerUsers 0
	salto
	
	mov cl, 0
	
	mov ah, 3dh				;FUNCION PARA ABRIR UN ARCHIVO CON 21h
	mov al, 0				;MODO 0 LECTURA, 1 ESCRITURA, 2 AMBOS
	mov dx, f_user			;NOMBRE DEL ARCHIVO A LEER
	int 21h
	mov [filehndl], ax		;handler
	
	mov ah, 3fh				;READ-FROM-A-FILE
	mov bx, [filehndl]		
	mov cx, 0ffh			;BYTES MAXIMOS A LEER
	mov dx, iobuf			;DIRECCION DEL BUFFER
	int 21h
	mov [read_len], ax		;GUARDAR EL NUMERO DE BYTES A LEER
	
	mov ah, 3eh				;CERRAR ARCHIVO
	mov bx, [filehndl]		
	int 21h
	
	
	
	;mov ah,040h        ; write-to-a-file
    ;mov bx,1           ; file handle for standard output
    ;mov cx,4  ; bytes to write - same number we read :)
    ;mov dx,iobuf + 9       ; buffer to write from
    ;int 021h           ; call on Good Old Dos
	
	;mov al, 0  		    ;7 para usuario, 14 para usuario y contraseña 16 para primer caracter de siguiente usuario
							;0 para usuario, 9 para contraseña
	
	mov si,iobuf
	mov di, 0
	%%ciclo:
	cmp di,[read_len]
	ja %%fin
	
	add di, 8
	mov ah,040h        		;write-to-a-file	
    mov bx,1           		;file handle for standard output
    mov cx,7  				;7 para usuario
    mov dx,si		;buffer to write from
    int 21h           		;call on Good Old Dos
	
	add di, 5
	add si, 9
	mov ah,040h        		;write-to-a-file	
    mov bx,1           		;file handle for standard output	
    mov cx,4  				;7 para usuario
    mov dx,si		;buffer to write from
    int 21h           		;call on Good Old Dos	
	add si, 6
	salto
	jmp %%ciclo
	
	;add al, 9
	salto
	
	%%fin:
	salto
%endmacro

%macro registrar 0
	mov ah, 09h
	mov dx, l_2
	int 21h
	
	mov dx, l_3
	int 21h
	resetUsr
	getDatoUsr
	
	mov ah, 09h
	mov dx, l_4
	int 21h
	resetPsw
	getDatoPsw
%endmacro