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
	mov ax, 0
	mov cx, 0
	%%cicloLectura:
		mov dl, texto[si]
		cmp dl, '$'
		je %%fin_lectura
			mov di, 0
		%%lectura_user:		;LEER USUARIO 7 ESPACIOS
			mov dl, texto[si]
			mov ar_linea[di], dl
			inc di
			inc si
			cmp di, 7
			jb %%lectura_user
		%%lectura_nivel:	;LEER NIVEL 1 ESPACIO
			inc si
			mov dl, texto[si]
			mov ar_linea[di], dl
			inc di	;sale con 8
			add si, 2
		%%lectura_puntaje:	;LEER PUNTAJE 4 ESPACIOS
			mov dl, texto[si]	
			mov ar_linea[di], dl
			inc di
			inc si
			cmp di, 12
			jb %%lectura_puntaje
		%%nuevaLinea:
			add si, 7
		inc ax
		cmp ax, 11
		jb %%ingresarNuevaLinea
		%%ingresarEnLinea:
			push si
			mov si, 8
			mov di, 0
			jmp %%llenar_Auxil
			%%recorrer_Matriz:
				mov dl, ar_desor[si]
				mov dh, ar_auxil[di]
				cmp dl, dh
				jb %%llenar_Auxil
				cmp dl, dh
				ja %%continuar_Matriz
				inc si
				inc di
				cmp di, 4
				jb %%recorrer_Matriz
			%%continuar_Matriz:
				sub si, 8
				sub si, di
				mov di, 0
				add si, 12
				cmp si, 120
				jb %%recorrer_Matriz
			jmp %%reemplazo_Fila
			
			%%llenar_Auxil:
				sub si, di
				mov bx, si
				sub bx, 8
				mov di, 0
				%%llenar_ciclo:
					mov dl, ar_desor[si]
					mov ar_auxil[di], dl
					inc si
					inc di
					cmp di, 4
					jb %%llenar_ciclo
			jmp %%continuar_Matriz
			
			%%reemplazo_Fila:
				mov si, 8
				mov di, 0
				%%reemplazo_Verificar:
					mov dh, ar_auxil[di]
					mov dl, ar_linea[si]
					cmp dh, dl
					jb %%reemplazar
					inc si
					inc di
					cmp si, 12
					jb %%reemplazo_Verificar
				jmp %%reemplazo_Fin
					
				%%reemplazar:
					mov di, bx
					mov si, 0
					mov ax, 10
					jmp %%ciclo_NuevaLinea
			
			%%reemplazo_Fin:
				pop si
				mov ax, 10
				jmp %%cicloLectura
				
				
		%%ingresarNuevaLinea:
			mov di, cx
			add cx, 12
			push si
			mov si, 0
			%%ciclo_NuevaLinea:
				mov dl, ar_linea[si]
				mov ar_desor[di], dl
				inc si
				inc di
				cmp si, 12
				jb %%ciclo_NuevaLinea
			pop si
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