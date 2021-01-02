 %macro load_Juego 0
	setData
	;iniciar el modo video., 13h
	mov al,13h
	xor ah,ah
	int 10h	

	;posicionar directamente a la memoria de video
	mov ax,0A000H
	mov es,ax
	xor di,di
	
	dibujarTodo
	
	%%mainLoop:
		setHeader
		set_Items
		
		mov ax, [perdido]
		cmp ax, 0
		je %%finProg
		;===================delay==========================
		
		Delay	

		;============leer el buffer de mi teclado =========
		HasKey 		; hay tecla?
		jz %%mainLoop
		
		GetCh			; si hay una tecla presiona, cual tecla es la que se presiono
		
		cmp al,20h			; es espacio ? ,si sí,  se sale
		jne %%Ps_			;sino comprobar movimientos
		jmp %%finProg	
	%%Ps_:
		cmp al, 1bh	;ESC
		je %%Pausa
		
	%%Mov1:
		cmp al,'d'
		jne %%Mov2
		
		; si llega aqui es la tecla d
		mov ax,[CoordX_car]
		cmp ax, 290
		jae %%mainLoop
		add ax, 10
		mov [CoordX_car],ax
		dibujarTodo
		jmp %%mainLoop
		
	%%Mov2:
		cmp al,'a'
		jne %%mainLoop
		mov ax,[CoordX_car]
		cmp ax, 15
		jbe %%mainLoop
		sub ax, 10
		mov [CoordX_car],ax
		dibujarTodo
		jmp %%mainLoop
		
	%%Pausa:
		HasKey 		; hay tecla?
		jz %%Pausa
	
		GetCh			; si hay una tecla presiona, cual tecla es la que se presiono
	
		cmp al,1bh			; es ESC
		je %%mainLoop			;sino comprobar movimientos
		cmp al,20H			; es ESC
		je %%finProg			;sino comprobar movimientos
		
	%%finProg:
		mov ax,3h		; funcion para el modo texto	
		int 10h
 %endmacro
 ;**************************FUNCIONAMIENTO DEL CARRO
 %macro setData 0
	mov ax, 0
	mov [t_mi], ax				;MICROSEGUNDOS A 0
	mov [t_s], ax				;SEGUNDOS A 0
	mov [t_m], ax				;MINUTOS A 0
	mov [obs_tmpAnt], ax		;TIEMPO ANTERIOR DE OBSTACULOS A 0
	mov [pre_tmpAnt], ax		;TIEMPO ANTERIOR DE PREMIOS A 0
	mov [ptn], ax				;PUNTAJE A 0
	
								;TODOS LOS PREMIOS EMPEZARAN EN LA PARTE DE ARRIBA
	mov [pre_CoordY1], ax
	mov [pre_CoordY2], ax
	mov [pre_CoordY3], ax
	mov [pre_CoordY4], ax
	mov [pre_CoordY5], ax
								;TODOS LOS OBSTACULOS EMPEZARAN EN LA PARTE DE ARRIBA
	mov [obs_CoordY1], ax
	mov [obs_CoordY2], ax
	mov [obs_CoordY3], ax
	mov [obs_CoordY4], ax
	mov [obs_CoordY5], ax
	
	mov ah, 3ah
	mov [dosP], ah				;DOS PUNTOS A ':'
	
	mov ah, 155
	mov [CoordX_car], ah		;CENTRAR EL CARRO EN X
	mov ah, 165
	mov [CoordY_car], ah		;CENTRAR EL CARRO EN Y	
	
	
	;ESTO SE BORRARA SOLO PARA PRUEBAS
	mov ax, 1
	mov [obs_tmp], ax
	mov [pre_tmp], ax
	mov ax, 15
	mov [pre_pts], ax			;PUNTAJE DE PREMIOS
	mov [obs_pts], ax			;PUNTAJE DE OBSTACULOS
 %endmacro
 ;---------------------------------------------------------------------
 %macro Delay 0
	mov ah,86h
	mov cx,0			; tiempo del delay
	mov dx,10000			; tiempo del delay
	int 15h
 %endmacro
 %macro HasKey 0
	push ax
	mov ah,01h	
	int 16h
	pop ax
 %endmacro
 %macro GetCh 0
	xor ah,ah
	int 16h
 %endmacro
 ;---------------------------------------------------------------------
 
 %macro imprimirNumeros 2 
	mov al,[%1]	; numero al registro al
	AAM			; divide los numeros en digitos
				; al = unidades , ah = decenas	
				
	; preparamos la unidad para ser impresa, es decir le sumamos el ascii
	add al,30h	
	mov [uni],al
	
	; preparamos la decena para ser impresa, es decir le sumamos el ascii
	add ah,30h
	mov [dece],ah
	
	imprimir dece, %2+01h
	imprimir uni, %2 +02h
 %endmacro
 %macro ImprimirPuntaje 2			; 1er = la cantidad que lleva el cronometro ; 2do = posicion donde quiero imprimirlo
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
		imprimirNumeros %1, %2
		pop dx
		mov [%1], dx
	%%dosDigitos:
		imprimirNumeros %1, %2 + 02h
	pop bx
	mov [%1], bx
%endmacro
 %macro imprimir 2		; 1ro = lo que imprimo ; 2do = currimiento del cursor
  ;funcion 02h, interrupción 10h 
  ;Correr el cursor N cantidad de veces
  ;donde dl = N
  
  mov ah,02h	
  mov bh,0		;pagina
  mov dh,0		;fila
  mov dl, %2	;columna
  int 10h	
  
  ;Funcion 09H, interrupcion 21h
  ;imprimir  caracteres en consola
  mov dx,%1	
  mov ah,09h
  int 21h
  
%endmacro
%macro setTiempo 0
	mov ax, [t_mi]
	inc ax
	mov [t_mi], ax
	cmp ax, 100
	jae %%mas_seg
	jmp %%fin
	%%mas_seg:
		mov ax, 0
		mov [t_mi], ax
	
		mov ax, [t_s]
		inc ax
		mov [t_s], ax
		cmp ax, 60
		jae %%mas_min
		jmp %%fin
	%%mas_min:
		mov ax, 0
		mov [t_s], ax
	
		mov ax, [t_m]
		inc ax
		mov [t_m], ax
	%%fin:
		imprimirNumeros t_mi, 24H
		imprimir dosP, 24H
		imprimirNumeros t_s, 21H
		imprimir dosP, 21H
		imprimirNumeros t_m, 1EH
%endmacro
%macro setHeader 0
	imprimir usr, 01H	;NOMBRE USUARIO
	imprimir nv_, 0BH	;Nivel
	imprimir nv0, 0FH	;Nivel
	ImprimirPuntaje ptn, 16H	;Numero nivel
	
	setTiempo
%endmacro
 ;---------------------------------------------------------------------
%macro dibujarTodo 0
	setFondo
	DibujarCarro
	DibujarEstrellas
%endmacro
 ;---------------------------------------------------------------------
%macro setFondo 0
	mov ax, 15
	mov bx, 25
	mov cx,bx	;coord x
	shl cx,8	
	shl bx,6
	add bx,cx	; bx = 320
	add ax,bx	; sumar x a y
	mov di, ax
	
	mov ax, 27		;COLOR DEL 
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
 ;---------------------------------------------------------------------
%macro setCarro 1
	push ax
	mov di, ax
	mov si, 0
	%%loop:
		mov ax, %1[si]
		mov [es:di], ax		;PINTAR EN ES+DI CON COLOR AX
		inc di
		inc si
		cmp si, 8
		jb %%loop
	pop ax
%endmacro
%macro DibujarCarro 0
	mov ax, [CoordX_car]
	mov bx, [CoordY_car]
	mov cx,bx	;coord x
	shl cx,8	
	shl bx,6
	add bx,cx	; bx = 320
	add ax,bx	; sumar x a y
	mov di, ax
	
	setCarro car_f1
	add ax, 320
	setCarro car_f2
	add ax, 320
	setCarro car_f3
	add ax, 320
	setCarro car_f4
	add ax, 320
	setCarro car_f5
	add ax, 320
	setCarro car_f6
	add ax, 320
	setCarro car_f7
	add ax, 320
	setCarro car_f8
	add ax, 320
	setCarro car_f9
	add ax, 320
	setCarro car_f10
	add ax, 320
	setCarro car_f11
	add ax, 320
	setCarro car_f12
	add ax, 320
	setCarro car_f13
	add ax, 320
	setCarro car_f14
%endmacro
 ;---------------------------------------------------------------------
%macro DibujarEstrellas 0
	pre_Mover pre_CoordX1, pre_CoordY1
	pre_Mover pre_CoordX2, pre_CoordY2
	pre_Mover pre_CoordX3, pre_CoordY3
	pre_Mover pre_CoordX4, pre_CoordY4
	pre_Mover pre_CoordX5, pre_CoordY5
	
	obs_Mover obs_CoordX1, obs_CoordY1
	obs_Mover obs_CoordX2, obs_CoordY2
	obs_Mover obs_CoordX3, obs_CoordY3
	obs_Mover obs_CoordX4, obs_CoordY4
	obs_Mover obs_CoordX5, obs_CoordY5
%endmacro
%macro setEstrella 1
	push ax
	mov di, ax
	mov si, 0
	%%loop:
		mov ax, %1[si]
		mov [es:di], ax		;PINTAR EN ES+DI CON COLOR AX
		inc di
		inc si
		cmp si, 8
		jb %%loop
	pop ax
%endmacro
 ;---------------------------------------------------------------------
%macro verCosilion 2	;1-X  2-Y
	mov cl, 0			;CONDICION INCIIAL, SI ES 0 NO HAY, 1 SI HAY COLISICION
	
	mov bx, [%2]		;OBTENEMOS Y SUPERIOR DE LA ESTRELLA
	add bx, 9			;OBTENEMOS Y INFERIOR DE LA ESTRELLA
	mov dx, [CoordY_car]	;OBTENEMOS Y DEL CARRO
	cmp bx, dx			
	jb %%fin			;SI NO HA LLEGADO A Y DEL CARRO TERMINA
	
	mov bx, [%1]		;OBTENEMOS X DERECHA DE LA ESTRELLA
	mov dx, [CoordX_car]	;OBTENEMOS X DERECHA DEL CARRO
						
						;PRIMERO VERIFICAMOS SI LA ESQUINA DERECHA DE LA ESTRELLA
						;TOCA CON LA ESQUINA IZUIQERDA DEL CARRO
	add bx, 9
	cmp bx, dx
	jb %%fin
						;AHORA COMPARAMOS LA ESQUINA IZQUIERDA DE LA ESTRELLA
						;CON LA ESQUINA DERECHA DEL CARRO
	sub bx, 9
	add dx, 9
	cmp bx, dx
	ja %%fin
	
	mov cl, 1			;HAY COLISION
	mov ax, 185			;PARA ELIMINAR LA ESTRELLA DEL FONDO
	
	%%fin:
%endmacro
 ;---------------------------------------------------------------------
%macro pre_Mover 2		;1-X  2-Y
	mov ax, [%2]
	cmp ax, 0
	je %%fin
	%%mover:
		add ax, 10
		mov [%2],ax
		
		verCosilion %1, %2
		
		cmp ax, 185
		jb %%dibujar
		mov ax, 0
		mov [%2], ax
		mov ax,[%1]
		add ax, 60
		cmp ax, 270
		jbe %%asignar
		sub ax, 270
		cmp ax, 15
		jae %%asignar
		add ax, 15
		%%asignar:
		mov [%1], ax
		
		cmp cl, 1		;colision verdadera
		je %%colision
		
		jmp %%fin
	%%colision:			;SUMA
		mov ax, [ptn]
		add ax, [pre_pts]
		mov [ptn], ax
		jmp %%fin
	%%dibujar:
		mov ax, [%1]	;X
		mov bx, [%2]	;Y
		mov cx,bx	;coord x
		shl cx,8	
		shl bx,6
		add bx,cx	; bx = 320
		add ax,bx	; sumar x a y
		mov di, ax
		
		setEstrella stb_1
		add ax,320
		setEstrella stb_2
		add ax,320
		setEstrella stb_3
		add ax,320
		setEstrella stb_4
		add ax,320
		setEstrella stb_5
		add ax,320
		setEstrella stb_6
		add ax,320
		setEstrella stb_7
		add ax,320
		setEstrella stb_8
		add ax,320
		setEstrella stb_9
	%%fin:
%endmacro	
%macro pre_Nuevo 1		;Y
	cmp cl, 0
	jne %%fin
	mov ax, [%1]
	cmp ax, 0
	jne %%fin
	%%nuevo:
		mov ax, 25
		mov [%1], ax
		mov cl, 1
	%%fin:
%endmacro
%macro setPremios 0
	mov ax, [t_s]
	mov bx, [pre_tmpAnt]
	sub ax, bx
	cmp ax, [pre_tmp]
	jb %%movimiento
	%%dibujar:
		mov cl, 0 		;0 no ingresado
		pre_Nuevo pre_CoordY1
		pre_Nuevo pre_CoordY2
		pre_Nuevo pre_CoordY3
		pre_Nuevo pre_CoordY4
		pre_Nuevo pre_CoordY5
		mov ax, [t_s]
		mov [pre_tmpAnt], ax
	%%movimiento:
		dibujarTodo
	%%fin:
%endmacro
 ;---------------------------------------------------------------------
%macro obs_Mover 2		;1-X  2-Y
	mov ax, [%2]
	cmp ax, 0
	je %%fin
	%%mover:
		add ax, 10
		mov [%2],ax
		
		verCosilion %1, %2
		
		cmp ax, 185
		jb %%dibujar
		mov ax, 0
		mov [%2], ax
		mov ax,[%1]
		add ax, 60
		cmp ax, 270
		jbe %%asignar
		sub ax, 270
		cmp ax, 15
		jae %%asignar
		add ax, 15
		%%asignar:
		mov [%1], ax
		
		cmp cl, 1		;colision verdadera
		je %%colision
		
		jmp %%fin
	%%colision:			;RESTA
		mov ax, [ptn]
		mov bx, [obs_pts]
		cmp ax, bx
		jb %%perdida
		sub ax, bx
		cmp ax, 0
		jae %%resta
		%%perdida:
		mov ax, 0
		mov [perdido], ax
		%%resta:
		mov [ptn], ax
		jmp %%fin	
	%%dibujar:
		mov ax, [%1]	;X
		mov bx, [%2]	;Y
		mov cx,bx	;coord x
		shl cx,8	
		shl bx,6
		add bx,cx	; bx = 320
		add ax,bx	; sumar x a y
		mov di, ax
		
		setEstrella stm_1
		add ax,320
		setEstrella stm_2
		add ax,320
		setEstrella stm_3
		add ax,320
		setEstrella stm_4
		add ax,320
		setEstrella stm_5
		add ax,320
		setEstrella stm_6
		add ax,320
		setEstrella stm_7
		add ax,320
		setEstrella stm_8
		add ax,320
		setEstrella stm_9
	%%fin:
%endmacro	
%macro obs_Nuevo 1		;Y
	cmp cl, 0
	jne %%fin
	mov ax, [%1]
	cmp ax, 0
	jne %%fin
	%%nuevo:
		mov ax, 25
		mov [%1], ax
		mov cl, 1
	%%fin:
%endmacro
%macro setObstaculos 0
	mov ax, [t_s]
	mov bx, [obs_tmpAnt]
	sub ax, bx
	cmp ax, [obs_tmp]
	jb %%movimiento
	%%dibujar:
		mov cl, 0 		;0 no ingresado
		obs_Nuevo obs_CoordY1
		obs_Nuevo obs_CoordY2
		obs_Nuevo obs_CoordY3
		obs_Nuevo obs_CoordY4
		obs_Nuevo obs_CoordY5
		mov ax, [t_s]
		mov [obs_tmpAnt], ax
	%%movimiento:
		dibujarTodo
	%%fin:
%endmacro
 ;---------------------------------------------------------------------
%macro set_Items 0
	mov ax, [t_mi]
	mov si, [vel]
	mov cx, 0
	%%ciclo:
	cmp cx, 100
	jae %%fin
	cmp ax, cx
	jne %%aumento
		setPremios
		setObstaculos
		jmp %%fin
	%%aumento:
		add cx, si
		jmp %%ciclo
	%%fin:
%endmacro