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
		mov dx, er_Psw
		int 21h
		salto
	%%fin:
%endmacro

%macro leerUsers 0
	salto
	resetTexto
	
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
	cmp cl, 0			;USUARIO INCORRECTO
	je %%usr_inc
	cmp cl, 1			;CONTRASEÑA INCORRECTA
	je %%psw_inc
	cmp cl, 2			;2 USUARIO, 3 ADMIN
	je %%us_user
	%%us_admin:
		admin_Main
		jmp %%fin
	%%us_user:
		user_Main
		jmp %%fin
	%%psw_inc:
		mov ah, 09h
		mov dx, er_IngP
		int 21h
		jmp %%fin
	%%usr_inc:
		mov ah, 09h
		mov dx, er_IngU
		int 21h
	%%fin:
	salto
%endmacro

%macro compararUsr 0
	;------------------COMPARAR USUARIO
	mov si, 0
	mov bl, '$'
	%%ciclo:
		mov cl, 0
		cmp texto[si], bl
		je %%fin2
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
				add si, 7
				jmp %%fin_ciclo2
			%%contiunar:
				inc di
				inc si
				mov cl, 1
				jmp %%ciclo_2
			%%fin_ciclo2:
		cmp cl, 1
		je %%verificarPsw
		add si, 6
		jmp %%ciclo
	jmp %%fin2
	
	%%verificarPsw:
		add si, 1
		mov di, 0
		%%ciclo_p:
			cmp di, 4
			je %%fin
			mov bh, psw[di]
			cmp texto[si], bh
			je %%contiunar_p
			%%noigual_p:
				mov cl, 1
				jmp %%fin2
			%%contiunar_p:
				inc di
				inc si
				mov cl, 2
				jmp %%ciclo_p
	%%fin:
		cmp si, 16
		ja %%fin2
		mov cl, 3
	%%fin2:
%endmacro

%macro registrar 0
	mov ah, 09h
	mov dx, l_2
	int 21h
	
	mov dx, l_3
	int 21h
	
	resetUsr
	resetTexto
	getDatoUsr
	existeUsr
	
	cmp cl, 1
	je %%errorUsr
	mov cl, 0
	
	%%ingresoPsw:
	mov ah, 09h
	mov dx, l_4
	int 21h
	resetPsw
	getDatoPsw
	
	cmp cl, 1
	je %%errorPsw
	regiUser
	call %%fin
	%%errorPsw:
		salto
		mov ah, 09h
		mov dx, er_Psw
		int 21h
		salto
		jmp %%ingresoPsw
	%%errorUsr:
		salto
		mov ah, 09h
		mov dx, er_Usr
		int 21h
		salto
	%%fin:
%endmacro

%macro existeUsr 0

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
		
		
	mov si, 0
	mov bl, '$'
	%%ciclo:
		mov cl, 0
		cmp texto[si], bl
		je %%fin
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
				add si, 7
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

%macro regiUser 0
	mov si, 0
	mov bl, '$'
	%%ciclo:
		cmp texto[si], bl
		je %%llenado_enter
		inc si
		jmp %%ciclo
		
	%%llenado_enter:
		mov psw[4], bl
		mov bl, 10
		mov usr[7], bl
		mov texto[si], bl
		inc si
		mov bl, 13
		mov texto[si], bl
	
	%%escritura:
		mov  ah, 3ch
	    mov  cx, 0
		mov  dx,  f_user
		int  21h  
  
		mov [filehndl],ax
	
		mov  ah, 40h
		mov  bx, [filehndl]
		mov  cx, si
		mov  dx, texto
		int  21h
	  
		mov  ah, 40h
		mov  bx, [filehndl]
		mov  cx, 8  ;STRING LENGTH.
		mov  dx, usr
		int  21h
	  
		mov  ah, 40h
		mov  bx, [filehndl]
		mov  cx, 5  ;STRING LENGTH.
		mov  dx, psw
		int  21h
		
		mov ah,03Eh        ; the close-the-file function
		mov bx,[filehndl]  ; the file handle
		int 021h    
	
		mov ah, 09h
		mov dx, l_5
		int 21h
%endmacro