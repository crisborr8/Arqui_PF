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
	
	DibujarCarro
	
	%%mainLoop:
		setHeader
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
		DibujarCarro
		jmp %%mainLoop
		
	%%Mov2:
		cmp al,'a'
		jne %%Mov3
		mov ax,[CoordX_car]
		cmp ax, 15
		jbe %%mainLoop
		sub ax, 10
		mov [CoordX_car],ax
		DibujarCarro
		jmp %%mainLoop
	
	%%Mov3:
		cmp al,'w'
		jne %%Mov4	
		mov ax,[CoordY_car]
		cmp ax, 25
		jbe %%mainLoop
		sub ax, 10
		mov [CoordY_car],ax
		DibujarCarro
		jmp %%mainLoop
		
	%%Mov4:
		cmp al,'s'
		jne %%mainLoop
		mov ax,[CoordY_car]
		cmp ax, 175
		jae %%mainLoop
		add ax, 10
		mov [CoordY_car],ax
		DibujarCarro
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
	mov [t_mi], ax
	mov [t_s], ax
	mov [t_m], ax
	mov ah, 3ah
	mov [dosP], ah
	mov ah, 155
	mov [CoordX_car], ah
	mov ah, 165
	mov [CoordY_car], ah
 %endmacro
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
	imprimir ptn, 16H	;Numero nivel
	
	setTiempo
%endmacro
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
	setFondo
	
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
 
 