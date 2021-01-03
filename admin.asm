 %macro admin_Main 0
	%%ciclo:
		mostrarMenu_Admin
		getChar
		salto
		
		cmp al, 49
		je %%uno
		cmp al, 50
		je %%dos
		cmp al, 51
		je %%fin
		errorMain
		jmp %%ciclo
	%%uno:
		admin_Pts
		jmp %%ciclo
	%%dos:
		admin_Tiempo
		jmp %%ciclo
	%%fin:
 %endmacro
 
 %macro admin_Pts 0
	resetTexto
	
	mov ah,3dh			; abriendo un archivo
	mov al,0			; indicando que lo estoy abriendo en modo lectura
	mov dx,f_pts		;especifico la ruta del archivo
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
	
	
	mov si, 0
	mov di, 0
	mov ax, 0
	%%cicloLectura:
		mov dl, texto[si]
		cmp dl, '$'
		je %%fin_lectura
			mov cx, 0
		%%lectura_user:		;LEER USUARIO 7 ESPACIOS
			mov dl, texto[si]
			mov ar_desor[di], dl
			inc di
			inc si
			inc cx
			cmp cx, 7
			jb %%lectura_user
		%%lectura_nivel:	;LEER NIVEL 1 ESPACIO
			inc si
			mov dl, texto[si]
			mov ar_desor[di], dl
			inc di
			add si, 2
			mov cx, 0
		%%lectura_puntaje:	;LEER PUNTAJE 4 ESPACIOS
			mov dl, texto[si]	
			mov ar_desor[di], dl
			inc di
			inc si
			inc cx
			cmp cx, 4
			jb %%lectura_puntaje
		%%nuevaLinea:
			add si, 7
		inc ax
		jmp %%cicloLectura
		
	%%fin_lectura:
		mov [tcant], ax
		cmp ax, 0
		je %%fin_error
			mostrarTop10Puntos
		jmp %%fin
	
	%%fin_error:
		errorAdmin
	%%fin:
 %endmacro
 
 %macro admin_Tiempo 0
	mov ax, [tcant]
	mov ax, 0
	mov [tcant], ax
	
	cmp ax, 0
	je %%fin_error
		mostrarTop10Tiempo
	jmp %%fin
	
	%%fin_error:
		errorAdmin
	%%fin:
 %endmacro