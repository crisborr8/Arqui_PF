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
	mov ah, 09h
	cmp cl, 0
	je %%noigual
	mov dx, p1
	jmp %%fin
	%%noigual:
	mov dx, p2
	%%fin:
	int 21h
	salto
%endmacro

%macro compararUsr 0
	;------------------COMPARAR USUARIO
	mov si, 0
	%%ciclo:
		mov cl, 0
		mov bl, '$'
		cmp texto[si], bl
		je %%fin
		mov bl, ' '
		mov di, 0
			%%ciclo_2:
				cmp di, 7
				je %%fin_ciclo2
				mov bh, usr[di]
				cmp texto[si], bh
				je %%contiunar
			%%noigual:
				mov cl, 0
				sub si, di
				add si, 9
				jmp %%fin_ciclo2
			%%contiunar:
				inc di
				inc si
				mov cl, 1
				jmp %%ciclo_2
			%%fin_ciclo2:
		cmp cl, 1
		je %%fin
		add si, 6
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