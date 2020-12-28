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
		
	mov ah,3dh			; abriendo un archivo
	mov al,0			; indicando que lo estoy abriendo en modo lectura
	mov dx,f_user		;especifico la ruta del archivo
	int 21h
	jc %%fin
	mov bx,ax			; handle del archivo lo copio a bx

	mov ah,3fh			;funcion para leer archivo
	mov dx,texto		; indico la variable en donde guardare lo leido
	mov cx,0ffh			; numero de bytes a leer
	int 21h
	jc %%fin
	cmp ax,0			; si ax = 0 significa que EOF
	jz %%fin	
		
	compararUsr
	
	%%fin:
	salto
%endmacro

%macro compararUsr 0
	mov si, 0
	mov bl, '$'
	
	%%ciclo:
	mov cl, 0
	cmp texto[si], bl
	je %%fin
	mov ah, 02h
	mov dl, texto[si]
	int 21h
	
	inc si
	jmp %%ciclo
	
	%%fin:
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