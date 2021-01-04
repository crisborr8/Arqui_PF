%macro inic_Graph 0
	;iniciar el modo video., 13h
	mov al,13h
	xor ah,ah
	int 10h	

	;posicionar directamente a la memoria de video
	mov ax,0A000H
	mov es,ax
	xor di,di
%endmacro

%macro load_grafica 0
	inic_Graph
	
	imprimir t_p2, 0AH	;Nivel
	setAncho
	setMargen
	dibujarBarras
	
	%%precionarBarra:
		xor ax, ax
		getChar
		cmp al, ' '
		jne %%precionarBarra
	
	mov ax,3h		; funcion para el modo texto	
	int 10h
%endmacro
;****************************************************
%macro setXY 0
	mov cx,bx	;coord x
	shl cx,8	
	shl bx,6
	add bx,cx	; bx = 320
	add ax,bx	; sumar x a y
	mov di, ax
%endmacro
%macro getXY 0			;Se tiene ancho, alto, al final ax -> X   bx -> Y
						;SE SABE QUE Xin = 15   Yin = 25
						;PARA X = 15 + X*5 + (X-1)*ANCHO
	pop cx
	push cx
	
	xor ax, ax
	mov al, 4
	mul cx
	
	mov bx, ax
	xor ax, ax
	dec cx
	mov al, [ancho]
	mul cx
	
	add bx, 19
	add ax, bx
						;PARA Y = 140 + 25 - ALTURA
	xor dx, dx
	mov dl, [altura]
	mov bx, 140
	add bx, 30
	sub bx, dx
	
%endmacro
%macro setAncho 0		;(290 - [(X+1)*5])/X
	mov cl, [tcant]		; X
	mov ax, 290
	mov dx, 0
	div cl
	mov dx, ax
	
	
	inc cl				; X+1
	mov al, 5
	mul cl				;(X+1)*5
	dec cl
	div cl
	
	sub dl, al
	mov [ancho], dl
%endmacro
%macro setAltura 0		;(140*ALTURA)/ALTURA_MAXIMA
	mov al, [altura]
	mov bl, 140
	mul bl
	
	mov bl, [alt_max]
	div bl
	
	mov [altura], al
%endmacro
%macro setColor 0		;color
	mov cl, [altura]
	%%rojo:
		cmp cl, 20
		ja %%azul
		mov bl, 4
		jmp %%pintar
	%%azul:
		cmp cl, 40
		ja %%amarillo
		mov bl, 1
		jmp %%pintar
	%%amarillo:
		cmp cl, 60
		ja %%verde
		mov bl, 14
		jmp %%pintar
	%%verde:
		cmp cl, 80
		ja %%blanco
		mov bl, 2
		jmp %%pintar
	%%blanco:
		cmp cl, 100
		ja %%ninguno
		mov bl, 15
		jmp %%pintar
	%%ninguno:
		mov bl, 5
	%%pintar:
	mov [color], bl
%endmacro
;***************************************************************************
%macro setMargenSupInf 0
	mov ax, 29		;COLOR DEL 
	mov dx, 290	;ANCHO DEL FONDO
	%%margen:	;LOOP PARA DIBUJAR A LA IZQUIERDA
		mov [es:di], ax		;PINTAR EN ES+DI CON COLOR AX
		inc di
		dec dx
		jnz %%margen
%endmacro
%macro setMargenDerIzq 0
	mov ax, 29		;COLOR DEL 
	mov bx, 170		;ALTURA DEL FONDO
	%%margen:		;LOOP PARA DIBUJAR HACIA ABAJO
		mov [es:di], ax		;PINTAR EN ES+DI CON COLOR AX
		add di, 320	;NUEVA FILA
		dec bx
		jnz %%margen
%endmacro
%macro setMargen 0
	mov ax, 15			;MARGEN ARRIBA
	mov bx, 25
	setXY
	setMargenSupInf
	
	mov ax, 15			;MARGEN ABAJO
	mov bx, 195
	setXY
	setMargenSupInf
	
	mov ax, 15			;MARGEN IZQUIERDA
	mov bx, 25
	setXY
	setMargenDerIzq
	
	mov ax, 305			;MARGEN DERECHA
	mov bx, 25
	setXY
	setMargenDerIzq
%endmacro
%macro clearBarras 0
	mov ax, 15			;MARGEN ARRIBA
	mov bx, 25
	setXY
	mov ax, 0		;COLOR DEL 
	mov bx, 170		;ALTURA DEL FONDO
	%%loopRow:		;LOOP PARA DIBUJAR HACIA ABAJO
		mov dx, 290	;ANCHO DEL FONDO
		push di
		%%loopCol:	;LOOP PARA DIBUJAR A LA IZQUIERDA
			mov [es:di], ax		;PINTAR EN ES+DI CON COLOR AX
			inc di
			dec dx
			jnz %%loopCol
		pop di
		add di, 320	;NUEVA FILA
		dec bx
		jnz %%loopRow
%endmacro
;***************************************************************************
 %macro imprimirPnt1 2			; 1er = la cantidad que lleva el cronometro ; 2do = posicion donde quiero imprimirlo
	mov bx, [%1]
	push bx
	cmp bx, 100
	jb %%dosDigitos
		mov ax, bx
		mov bx, 100
		mov dx, 0 
		div bx
		mov [%1], ax
		push dx
		imprimirPnt2 %1, %2
		pop dx
		mov [%1], dx
	%%dosDigitos:
		imprimirPnt2 %1, %2 + 02h
	pop bx
	mov [%1], bx
%endmacro
%macro imprimirPnt2 2 
	mov al,[%1]	; numero al registro al
	AAM			; divide los numeros en digitos
				; al = unidades , ah = decenas	
				
	; preparamos la unidad para ser impresa, es decir le sumamos el ascii
	add al,30h	
	mov [uni],al
	
	; preparamos la decena para ser impresa, es decir le sumamos el ascii
	add ah,30h
	mov [dece],ah
	
	imprimirPtn3 dece, %2+01h
	imprimirPtn3 uni, %2 +02h
 %endmacro
%macro imprimirPtn3 2
	
	mov dl, %2	;columna
	add dl, al
	
	xor ax, ax
	mov ah,02h	
	mov bh,0		;pagina
	mov dh, 16h	;fila
	int 10h	
  
	mov dx,%1	
	mov ah,09h
	int 21h
%endmacro
%macro dibujarBarra 0
	mov ax, [color]		;COLOR DEL 
	mov bx, [altura]		;ALTURA DEL FONDO
	%%loopRow:		;LOOP PARA DIBUJAR HACIA ABAJO
		mov dx, [ancho]	;ANCHO DEL FONDO
		push di
		%%loopCol:	;LOOP PARA DIBUJAR A LA IZQUIERDA
			mov [es:di], ax		;PINTAR EN ES+DI CON COLOR AX
			inc di
			dec dx
			jnz %%loopCol
		pop di
		add di, 320	;NUEVA FILA
		dec bx
		jnz %%loopRow
%endmacro
%macro dibujarBarras 0		;BARRAS PAPA, BARRAS APRENDELAS :U
	mov dx, [tcant]
	mov cx, 0				;0-12-24-32-...-120
	mov bx, 1				;0-1-2-...-10
	%%cicloLectura:
		cmp dx, 0
		je %%fin			
		push dx
		push cx	
		push bx
							;OBTENCION DE LA ALTURA Y COLOR
		mov si, cx
		add si, 8
		mov di, 0
		%%cicloAltura:
			mov dl, ar_desor[si]
			mov alt_Aux[di], dl
			inc si
			inc di
			cmp di, 4
			jb %%cicloAltura
			
		setAlturaNum
		setColor
		setAltura
		
		getXY
		setXY
		dibujarBarra
		
		pop bx
		pop cx
		pop dx
		dec dx
		inc bx
		add cx, 12
		jmp %%cicloLectura
	%%fin:
%endmacro