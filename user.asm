 %macro user_Main 0
	%%ciclo:
		mostrarMenu_Usuario
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
		mov ax, [nvM]
		cmp ax, 0
		jne %%siguiente
			errorJuego
			jmp %%ciclo
		%%siguiente:
			load_JuegoData
			load_Juego
			guardarDatosJuego
			mov ax, 0
			mov [nvM], ax
			jmp %%ciclo
	%%dos:
		user_Cargar
		jmp %%ciclo
	%%fin:
 %endmacro
 
 ;CARGA DE ARCHIVO
 %macro user_Cargar 0
	mov ah, 09h
	mov dx, j_1
	int 21h
	
	resetPth
	getDatoPth
	leerNivel
 %endmacro
 
 %macro leerNivel 0
	
	salto
	resetTexto
	
	mov ax, 0
	mov [nvM], ax
	
	mov ah,3dh			; abriendo un archivo
	mov al,0			; indicando que lo estoy abriendo en modo lectura
	mov dx,pth			;especifico la ruta del archivo
	int 21h
	jc %%fin
	mov bx,ax			; handle del archivo lo copio a bx
	
	mov ah,3fh			;funcion para leer archivo
	mov dx,texto		; indico la variable en donde guardare lo leido
	mov cx,0ffh			; numero de bytes a leer
	int 21h
	jc %%finMal
	cmp ax,0			; si ax = 0 significa que EOF
	jz %%finMal	
	
	
	mov si, 0
	mov ax, 0
	%%cicloLectura:
		mov dl, texto[si]
		cmp dl, '$'
		je %%fin
		inc si
		cmp dl, ';'
		jne %%cicloLectura
		inc ax
		jmp %%cicloLectura
		
	%%finMal:
		errorJuego
	%%fin:	
		mov [nvM], ax
 %endmacro
 
 %macro setDatosNivel 0
	mov si, 6
	mov dh, [nv0]
	add dh, 30h
	%%ciclo:
		mov dl, texto[si]
		cmp dl, '$'
		je %%fin
		cmp dl, dh
		je %%setDatos
		%%siguienteLinea:
			inc si
			mov dl, texto[si]
			cmp dl, ';'
			jne %%siguienteLinea
			add si, 9
			jmp %%ciclo
		%%setDatos:
			add si, 2
			mov cl, 0
			%%setTiempoMax:
				mov al, cl
				mov dl, 10
				mul dl
				mov cx, ax
				mov dl, texto[si]
				sub dl, '0'
				add cl, dl
				inc si
				mov dl, texto[si]
				cmp dl, ','
				jne %%setTiempoMax
				mov [segMax], cl
				mov cl, 0
				inc si
			%%setTiempoObs:
				mov al, cl
				mov dl, 10
				mul dl
				mov cx, ax
				mov dl, texto[si]
				sub dl, '0'
				add cl, dl
				inc si
				mov dl, texto[si]
				cmp dl, ','
				jne %%setTiempoObs
				mov [obs_tmp], cl
				mov cl, 0
				inc si
			%%setTiempoPre:
				mov al, cl
				mov dl, 10
				mul dl
				mov cx, ax
				mov dl, texto[si]
				sub dl, '0'
				add cl, dl
				inc si
				mov dl, texto[si]
				cmp dl, ','
				jne %%setTiempoPre
				mov [pre_tmp], cl
				mov cl, 0
				inc si
			%%setPuntosPre:
				mov al, cl
				mov dl, 10
				mul dl
				mov cx, ax
				mov dl, texto[si]
				sub dl, '0'
				add cl, dl
				inc si
				mov dl, texto[si]
				cmp dl, ','
				jne %%setPuntosPre
				mov [pre_pts], cl
				mov cl, 0
				inc si
			%%setPuntosObs:
				mov al, cl
				mov dl, 10
				mul dl
				mov cx, ax
				mov dl, texto[si]
				sub dl, '0'
				add cl, dl
				inc si
				mov dl, texto[si]
				cmp dl, ';'
				jne %%setPuntosObs
				mov [obs_pts], cl
	%%fin:
 %endmacro
 
 %macro guardarDatosJuego 0
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
	mov bl, '$'
	%%cicloEscritura:
		%%ciclo:
			cmp texto[si], bl
			je %%llenado_enter
			inc si
			jmp %%ciclo
		%%llenado_enter:
			mov bl, 10
			mov texto[si], bl
			inc si
			mov di, 0
		%%escritura_user:
			mov dl, usr[di]
			mov texto[si], dl
			inc si
			inc di
			cmp di, 7
			jb %%escritura_user
			mov dl, ','
			mov texto[si], dl
		%%escritura_nivel:
			inc si
			mov dl, [nv0]
			add dl, 30h
			mov texto[si], dl
			inc si
			mov dl, ','
			mov texto[si], dl
		%%escritura_pts:
			inc si
			escritura_num1 ptn
			inc si
			mov dl, ','
			mov texto[si], dl
		%%escritura_tiempo:
			inc si
			escritura_num1 segAct
			inc si
			mov dl, ';'
			mov texto[si], dl
			inc si
			mov dl, '$'
			mov texto[si], dl
		%%escritura:
			mov  ah, 3ch
			mov  cx, 0
			mov  dx,  f_pts
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
	%%fin:
 %endmacro
 
 %macro escritura_num1 1
	mov bx, [%1]
	cmp bx, 100
	jb %%dosCeros
		mov ax, bx
		mov bx, 100
		mov dx, 0
		div bx
		mov [%1], ax
		push dx
		escritura_num2 %1
		pop dx
		mov [%1], dx
		inc si
		jmp %%dosDigitos
	%%dosCeros:
		mov al, '0'
		mov texto[si], al
		inc si
		mov texto[si], al
		inc si
	%%dosDigitos:
		escritura_num2 %1
	
 %endmacro
 %macro escritura_num2 1
	xor al, al
	xor ah, ah
	mov al, [%1]
	AAM
	add ah, 30h
	mov texto[si], ah
	inc si
	add al, 30h
	mov texto[si], al
 %endmacro