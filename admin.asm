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
	resetAlt
	
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
			
		push si
		mov si, 8
		mov di, 0
		%%altura_Max:
			mov dl, ar_linea[si]
			mov dh, alt_Aux[di]
			cmp dl, dh
			ja %%altura_MaxLlenar
			cmp dl, dh
			jb %%altura_MaxContinuar
			inc si
			inc di
			cmp di, 4
			jb %%altura_Max
		jmp %%altura_MaxContinuar
		%%altura_MaxLlenar:
			mov si, 8
			mov di, 0
			%%altura_MaxLlenarCiclo:
				mov dl, ar_linea[si]
				mov alt_Aux[di], dl
				inc si
				inc di
				cmp di, 4
				jb %%altura_MaxLlenarCiclo
		%%altura_MaxContinuar:
			pop si
			
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
			%%precionarBarra:
				getChar
				cmp al, ' '
				jne %%precionarBarra
			ordenamiento
			guardarTop10Puntos
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
		mostrarTop10Puntos
	jmp %%fin
	
	%%fin_error:
		errorAdmin
	%%fin:
 %endmacro
 
 %macro ordenamiento 0
	setAlturaNum
	mov [alt_max], al
	
	load_grafica
	
	%%mensajeOrdenamiento:
		salto
		mov dx, g_1
		int 21h
		mov dx, g_2
		int 21h
		mov dx, g_3
		int 21h
		getChar
		cmp al, '1'
		je %%siguiente
		cmp al, '2'
		je %%siguiente
		errorOrd
		jmp %%mensajeOrdenamiento
	%%siguiente:
		mov cl, al
		sub cl, '0'
	%%mensajeVelocidad:
		salto
		mov dx, v_1
		int 21h
		getChar
		cmp al, '0'
		jb %%error_
		cmp al, '9'
		ja %%error_
		jmp %%siguiente2
		%%error_:
		errorVel
		jmp %%mensajeVelocidad
	%%siguiente2:
		sub al,'0'
		mov [vel], al
	%%mensajeDesc:
		salto
		mov dx, g_4
		int 21h
		mov dx, g_5
		int 21h
		mov dx, g_6
		int 21h
		getChar
		cmp al, '1'
		je %%ordenar
		cmp al, '2'
		je %%ordenar
		errorOrd
		jmp %%mensajeDesc
	%%ordenar:
		sub al, '0'
		mov [as_des], al
		cmp cl, 2
		je %%dos
	%%uno:
		ordenarBubble
		jmp %%fin
	%%dos:
		ordenarQuick
	%%fin:
 %endmacro
 
 %macro guardarTop10Puntos 0
	mov ah,3dh			; abriendo un archivo
	mov al,0			; indicando que lo estoy abriendo en modo lectura
	mov dx,f_rep		;especifico la ruta del archivo
	int 21h
	jc %%fin
	mov bx,ax			; handle del archivo lo copio a bx
	
	resetTexto
	
	mov si, 0
	mov di, 0
	mov bl, 10				;ENTER
	mov bh, ','				;COMA
	%%ciclo_Titulo:
		mov dl,t_ep[di]
		mov texto[si], dl
		inc si
		inc di
		cmp si, 41
		jb %%ciclo_Titulo
	mov texto[si], bl
	
	inc si
	mov di, 0
	mov ch, 0
	mov al, 1
	mov ah, [tcant]
	%%ciclo_Data:
		cmp al, ah
		ja %%continuar
		
		inc ch
		cmp ch, 10
		jb %%menor_diez
			mov dl, 31h
			mov texto[si], dl
			inc si
			mov ch, 0
		%%menor_diez:
			mov dl, ch
			add dl, 30h
			mov texto[si], dl
		inc si
		mov texto[si], bh
		inc si
							;ESCRIBIENDO EL USUARIO
		
		mov cl, 0
		%%ciclo_Data_Usuario:
			mov dl, ar_desor[di]
			mov texto[si], dl
			inc si
			inc di
			inc cl
			cmp cl, 7
			jb %%ciclo_Data_Usuario
		%%ciclo_Data_Nivel:
			mov texto[si], bh
			inc si
			mov dl, ar_desor[di]
			mov texto[si], dl
			inc si
			mov texto[si], bh
			inc di
			inc si
		mov cl, 0
		%%ciclo_Data_Puntaje:
			mov dl, ar_desor[di]
			mov texto[si], dl
			inc si
			inc di
			inc cl
			cmp cl, 4
			jb %%ciclo_Data_Puntaje
		mov texto[si], bl
		inc si
		inc al
		cmp di, 120
		jb %%ciclo_Data
		
	%%continuar:
	
	mov  ah, 3ch
	mov  cx, 0
	mov  dx,  f_rep
	int  21h  

	mov [filehndl],ax

	mov  ah, 40h
	mov  bx, [filehndl]
	mov  cx, si
	mov  dx, texto
	int  21h
	
	mov ah,03Eh        ; the close-the-file function
	mov bx,[filehndl]  ; the file handle
	int 021h  
	
	salto
	mov dx, p_3
	int 21h
	
	%%fin:
 %endmacro