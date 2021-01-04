 %macro ordenarBubble 0
	setDataSort
	inic_Graph
	
	imprimir t_orB, 04H	
	ordenamientoEspacio	
		
	ordenar_PintarBubble
	mov cl, [as_des]
	cmp cl, 1
	je %%siguiente
	ordenarBubble_Des
	jmp %%finProg
	%%siguiente:
	ordenarBubble_Asc
	%%finProg:
	imprimir t_orB, 04H	
	ordenamientoEspacio	
	mov ax,3h		; funcion para el modo texto	
	int 10h
 %endmacro
 %macro ordenarBubble_Des 0
	mov si, 1			;I = 1
	%%For_I:
		mov cx, [tcant] 	;T
		cmp si, cx
		jnb %%fin
			mov di, cx			
			dec di				;J = T- 1
			%%For_J:
			cmp di, si
			jb %%finFor_I
			%%codigo:		;ar_desor[] <  ar_linea[]
				push si
				push di
				
				xor ax, ax
				mov al, 12
				mul di
				mov di, ax
				mov si, 0
				%%llenarLinea:	; J normal
					mov dl, ar_desor[di]
					mov ar_linea[si], dl
					inc si
					inc di
					cmp si, 12
					jb %%llenarLinea
					
				sub di, 24
				add di, 8
				mov si, 8
				%%comparar:
					mov dl, ar_desor[di]
					mov dh, ar_linea[si]
					cmp dh, dl
					ja %%finComparar
					cmp dh, dl
					jb %%cambio
					inc di
					inc si
					cmp si, 12
					jb %%comparar
					jmp %%finComparar
					
				%%cambio:
					sub di, si 
					mov si, 0
					%%llenarAux:
						mov dl, ar_desor[di]
						mov ar_liaux[si], dl
						inc si
						inc di
						cmp si, 12
						jb %%llenarAux
					sub di, 12 
					mov si, 0
					%%llenarOrig:
						mov dl, ar_linea[si]
						mov ar_desor[di], dl
						inc si
						inc di
						cmp si, 12
						jb %%llenarOrig
					mov si, 0
					%%llenarAnt:
						mov dl, ar_liaux[si]
						mov ar_desor[di], dl
						inc si
						inc di
						cmp si, 12
						jb %%llenarAnt
					clearBarras
					sonidoAsignar
					sonidoIniciar
					ordenar_PintarBubble
					sonidoTerminar
					
				%%finComparar:
					pop di
					pop si
			%%finFor_J:
			dec di
			jmp %%For_J
		%%finFor_I:
		inc si
		jmp %%For_I
	%%fin:
 %endmacro
 
 %macro ordenarBubble_Asc 0
	mov si, 1			;I = 1
	%%For_I:
		mov cx, [tcant] 	;T
		cmp si, cx
		jnb %%fin
			mov di, cx			
			dec di				;J = T- 1
			%%For_J:
			cmp di, si
			jb %%finFor_I
			%%codigo:		;ar_desor[] <  ar_linea[]
				push si
				push di
				
				xor ax, ax
				mov al, 12
				mul di
				mov di, ax
				mov si, 0
				%%llenarLinea:	; J normal
					mov dl, ar_desor[di]
					mov ar_linea[si], dl
					inc si
					inc di
					cmp si, 12
					jb %%llenarLinea
					
				sub di, 24
				add di, 8
				mov si, 8
				%%comparar:
					mov dl, ar_desor[di]
					mov dh, ar_linea[si]
					cmp dh, dl
					jb %%finComparar
					cmp dh, dl
					ja %%cambio
					inc di
					inc si
					cmp si, 12
					jb %%comparar
					jmp %%finComparar
					
				%%cambio:
					sub di, si 
					mov si, 0
					%%llenarAux:
						mov dl, ar_desor[di]
						mov ar_liaux[si], dl
						inc si
						inc di
						cmp si, 12
						jb %%llenarAux
					sub di, 12 
					mov si, 0
					%%llenarOrig:
						mov dl, ar_linea[si]
						mov ar_desor[di], dl
						inc si
						inc di
						cmp si, 12
						jb %%llenarOrig
					mov si, 0
					%%llenarAnt:
						mov dl, ar_liaux[si]
						mov ar_desor[di], dl
						inc si
						inc di
						cmp si, 12
						jb %%llenarAnt
					clearBarras
					sonidoAsignar
					sonidoIniciar
					ordenar_PintarBubble
					sonidoTerminar
					
				%%finComparar:
					pop di
					pop si
			%%finFor_J:
			dec di
			jmp %%For_J
		%%finFor_I:
		inc si
		jmp %%For_I
	%%fin:
 %endmacro
 %macro ordenar_PintarBubble 0
	%%ciclo:
		mov al, [segs]
		mov ah, [segMax]
		cmp ah, al
		jb %%fin
		imprimir t_orB, 04H
		ordenamientoDibujo
		Delay	
		jmp %%ciclo
	%%fin:
		mov al, 0
		mov [segs], al
 %endmacro
 ;*********************************************************
 %macro ordenarQuick 0
	setDataSort
	inic_Graph
	
	imprimir t_orQ, 04H	
	ordenamientoEspacio	
		
	ordenar_PintarQuick
	
	mov si, 0			;INDEX MENOR
	mov	di, [tcant]
	dec di
	
	call %%inicio
	jmp %%finProg
	
	%%inicio:
		cmp si, di
		jnb %%fin
			%%codigo:
			push di
			push si
			
			mov cl, [as_des]
			cmp cl, 2
			je %%quickAsc
				ordenarQuick_Des	;PIVOTE EN AX
			jmp %%siguiente
			%%quickAsc:
				ordenarQuick_Asc	;PIVOTE EN AX
			
			%%siguiente:
				pop si
				push ax
				mov di, ax		;MAYOR
				dec di
				call %%inicio
				pop ax
				pop di
				mov si, ax		;MENOR
				inc si
				call %%inicio
	%%fin:
	ret
	
	%%finProg:
	imprimir t_orQ, 04H	
	ordenamientoEspacio	
	mov ax,3h		; funcion para el modo texto	
	int 10h
 %endmacro
 %macro ordenarQuick_Des 0
	push di
	push si
	
	xor ax, ax
	mov al, 12
	mul di
	mov di, ax
	mov si, 0
	%%llenarLinea:			;PIVOTE
		mov dl, ar_desor[di]
		mov ar_linea[si], dl
		inc si
		inc di
		cmp si, 12
		jb %%llenarLinea
		
	pop si
	pop di
	mov cx, si
	dec cx					;I = MENOR - 1
							;J = MENOR
	%%For_J:
		cmp si, di
		jnb %%finFor_J
		push di				;HIGH
		push si				;HIGH - J
		
		xor ax, ax
		mov al, 12
		mul si
		mov di, ax
		
		add di, 8
		mov si, 8
		%%comparar:
			mov dl, ar_desor[di]
			mov dh, ar_linea[si]
			cmp dl, dh
			ja %%finComparar
			cmp dl, dh
			jb %%cambio
			inc di
			inc si
			cmp si, 12
			jb %%comparar
			jmp %%finComparar
			
		%%cambio:
			inc cx
			
			xor ax, ax 
			mov al, 12
			mul cx
			mov di, ax
			
			mov si, 0
			%%llenarAux:
				mov dl, ar_desor[di]
				mov ar_liaux[si], dl
				inc si
				inc di
				cmp si, 12
				jb %%llenarAux
				
			sub di, 12 			;I
			
			pop ax				;->(J)
			push ax	
			mov si, 12
			mul si
			mov si, ax
			
			mov bx, 0
			%%llenarOrig:
				mov dl, ar_desor[si]
				mov ar_desor[di], dl
				inc si
				inc di
				inc bx
				cmp bx, 12
				jb %%llenarOrig
			
			
			mov di, si
			sub di, 12
			mov si, 0
			%%llenarAnt:
				mov dl, ar_liaux[si]
				mov ar_desor[di], dl
				inc si
				inc di
				cmp si, 12
				jb %%llenarAnt
			
			push cx
			clearBarras
			sonidoAsignar
			sonidoIniciar
			ordenar_PintarQuick
			sonidoTerminar
			pop cx 
			
		%%finComparar:
			pop si
			pop di
			inc si
			jmp %%For_J
	%%finFor_J:
	
		push di
		
		xor ax, ax
		mov al, 12
		inc cx
		mul cx
		dec cx
		
		mov di, ax
		mov si, 0
		%%llenarTemp:			;TEMPORAL
			mov dl, ar_desor[di]
			mov ar_liaux[si], dl
			inc si
			inc di
			cmp si, 12
			jb %%llenarTemp
			
		sub di, 12
		pop ax
		mov si, 12
		mul si
		mov si, ax
		mov bx, 0
		%%llenarArr:
			mov dl, ar_desor[si]
			mov ar_desor[di], dl
			inc si
			inc di
			inc bx
			cmp bx, 12
			jb %%llenarArr
		
		
		mov di, si
		sub di, 12
		mov si, 0
		%%llenarFar:
			mov dl, ar_liaux[si]
			mov ar_desor[di], dl
			inc si
			inc di
			cmp si, 12
			jb %%llenarFar
		
		push cx
		clearBarras
		sonidoAsignar
		sonidoIniciar
		ordenar_PintarQuick
		sonidoTerminar
		pop cx 

		mov ax, cx
		inc ax
 %endmacro
 %macro ordenarQuick_Asc 0
	push di
	push si
	
	xor ax, ax
	mov al, 12
	mul di
	mov di, ax
	mov si, 0
	%%llenarLinea:			;PIVOTE
		mov dl, ar_desor[di]
		mov ar_linea[si], dl
		inc si
		inc di
		cmp si, 12
		jb %%llenarLinea
		
	pop si
	pop di
	mov cx, si
	dec cx					;I = MENOR - 1
							;J = MENOR
	%%For_J:
		cmp si, di
		jnb %%finFor_J
		push di				;HIGH
		push si				;HIGH - J
		
		xor ax, ax
		mov al, 12
		mul si
		mov di, ax
		
		add di, 8
		mov si, 8
		%%comparar:
			mov dl, ar_desor[di]
			mov dh, ar_linea[si]
			cmp dl, dh
			ja %%finComparar
			cmp dl, dh
			jb %%cambio
			inc di
			inc si
			cmp si, 12
			jb %%comparar
			jmp %%finComparar
			
		%%cambio:
			inc cx
			
			xor ax, ax 
			mov al, 12
			mul cx
			mov di, ax
			
			mov si, 0
			%%llenarAux:
				mov dl, ar_desor[di]
				mov ar_liaux[si], dl
				inc si
				inc di
				cmp si, 12
				jb %%llenarAux
				
			sub di, 12 			;I
			
			pop ax				;->(J)
			push ax	
			mov si, 12
			mul si
			mov si, ax
			
			mov bx, 0
			%%llenarOrig:
				mov dl, ar_desor[si]
				mov ar_desor[di], dl
				inc si
				inc di
				inc bx
				cmp bx, 12
				jb %%llenarOrig
			
			
			mov di, si
			sub di, 12
			mov si, 0
			%%llenarAnt:
				mov dl, ar_liaux[si]
				mov ar_desor[di], dl
				inc si
				inc di
				cmp si, 12
				jb %%llenarAnt
			
			push cx
			clearBarras
			sonidoAsignar
			sonidoIniciar
			ordenar_PintarQuick
			sonidoTerminar
			pop cx 
			
		%%finComparar:
			pop si
			pop di
			inc si
			jmp %%For_J
	%%finFor_J:
	
		push di
		
		xor ax, ax
		mov al, 12
		inc cx
		mul cx
		dec cx
		
		mov di, ax
		mov si, 0
		%%llenarTemp:			;TEMPORAL
			mov dl, ar_desor[di]
			mov ar_liaux[si], dl
			inc si
			inc di
			cmp si, 12
			jb %%llenarTemp
			
		sub di, 12
		pop ax
		mov si, 12
		mul si
		mov si, ax
		mov bx, 0
		%%llenarArr:
			mov dl, ar_desor[si]
			mov ar_desor[di], dl
			inc si
			inc di
			inc bx
			cmp bx, 12
			jb %%llenarArr
		
		
		mov di, si
		sub di, 12
		mov si, 0
		%%llenarFar:
			mov dl, ar_liaux[si]
			mov ar_desor[di], dl
			inc si
			inc di
			cmp si, 12
			jb %%llenarFar
		
		push cx
		clearBarras
		sonidoAsignar
		sonidoIniciar
		ordenar_PintarQuick
		sonidoTerminar
		pop cx 

		mov ax, cx
		inc ax
 %endmacro
 %macro ordenar_PintarQuick 0
	%%ciclo:
		mov al, [segs]
		mov ah, [segMax]
		cmp ah, al
		jb %%fin
		imprimir t_orQ, 04H
		ordenamientoDibujo
		Delay	
		jmp %%ciclo
	%%fin:
		mov al, 0
		mov [segs], al
 %endmacro
 ;*********************************************************
 %macro ordenamientoDibujo 0
	setHeaderSort
	setAncho
	setMargen
	dibujarBarras
 %endmacro
 %macro ordenamientoEspacio 0
	ordenamientoDibujo
	%%precionarBarra:
		xor ax, ax
		getChar
		cmp al, ' '
		jne %%precionarBarra
 %endmacro
 ;*********************************************************
 %macro setDataSort 0
	mov ax, 0
	mov [t_mi], ax				;MICROSEGUNDOS A 0
	mov [t_s], ax				;SEGUNDOS A 0
	mov [t_m], ax				;MINUTOS A 0 
	mov [segs], ax			
	mov [perdido], ax
	
	mov ah, 3ah
	mov [dosP], ah				;DOS PUNTOS A ':'
	
	mov bl, [vel]
	mov al, 10
	sub al, bl
	mul al
	add al, 10
	mov [segMax], al
 %endmacro
 %macro setHeaderSort 0
	imprimir t_or, 00H	;NOMBRE USUARIO
	
	imprimir t_vel, 10H	;Nivel
	imprimirNumeros vel, 13H	;Nivel
	
	imprimir t_tmp, 18H	;Nivel
	setTiempo
 %endmacro
 ;*********************************************************
 %macro sonidoAsignar 0
	mov di, 0
	mov si, 8
	%%cicloAltura:
		mov dl, ar_liaux[si]
		mov alt_Aux[di], dl
		inc si
		inc di
		cmp di, 4
		jb %%cicloAltura
	setAlturaNum
	
	mov al, [altura]
	%%rojo:
		cmp al, 20
		ja %%azul
		mov cx, 100
		jmp %%fin
	%%azul:
		cmp al, 40
		ja %%amarillo
		mov cx, 300
		jmp %%fin
	%%amarillo:
		cmp al, 60
		ja %%verde
		mov cx, 500
		jmp %%fin
	%%verde:
		cmp al, 80
		ja %%cxanco
		mov cx, 700
		jmp %%fin
	%%cxanco:
		cmp al, 100
		ja %%ninguno
		mov cx, 900
		jmp %%fin
	%%ninguno:
		mov cx, 0
	%%fin:
 %endmacro
 %macro sonidoIniciar 0
  %%STARTSOUND:	;CX=FREQUENCY IN HERTZ. DESTROYS AX & DX
	CMP CX, 014H
	JB %%STARTSOUND_DONE
	;CALL STOPSOUND
	IN AL, 061H
	;AND AL, 0FEH
	;OR AL, 002H
	OR AL, 003H
	DEC AX
	OUT 061H, AL	;TURN AND GATE ON; TURN TIMER OFF
	MOV DX, 00012H	;HIGH WORD OF 1193180
	MOV AX, 034DCH	;LOW WORD OF 1193180
	DIV CX
	MOV DX, AX
	MOV AL, 0B6H
	PUSHF
	CLI	;!!!
	OUT 043H, AL
	MOV AL, DL
	OUT 042H, AL
	MOV AL, DH
	OUT 042H, AL
	POPF
	IN AL, 061H
	OR AL, 003H
	OUT 061H, AL
	%%STARTSOUND_DONE:
 %endmacro
 %macro sonidoTerminar 0
	 IN AL, 061H
	AND AL, 0FCH
	OUT 061H, AL
 %endmacro