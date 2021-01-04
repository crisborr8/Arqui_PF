%macro salto 0
	mov ah, 09h
	mov dx, slt
	int 21h
	mov dx, pts
	int 21h
%endmacro

%macro mostrarMenu_Principal 0
	mov ah, 09h
	mov dx, pts
	int 21h
	mov dx, m_1
	int 21h
	mov dx, m_2
	int 21h
	mov dx, m_3
	int 21h
	mov dx, m_4
	int 21h
	mov dx, pts
	int 21h
%endmacro	

%macro mostrarEncabezado 0
	mov ah, 09h
	mov dx, pts
	int 21h
	mov dx, e_1
	int 21h
	mov dx, e_2
	int 21h
	mov dx, e_3
	int 21h
	mov dx, e_4
	int 21h
	mov dx, e_5
	int 21h
	mov dx, e_6
	int 21h
	mov dx, e_7
	int 21h
	mov dx, pts
	int 21h
%endmacro

%macro mostrarMenu_Usuario 0
	mostrarEncabezado
	mov dx, u_1
	int 21h
	mov dx, u_2
	int 21h
	mov dx, u_3
	int 21h
%endmacro

%macro mostrarMenu_Admin 0
	mostrarEncabezado
	mov dx, a_1
	int 21h
	mov dx, a_2
	int 21h
	mov dx, a_3
	int 21h
%endmacro

%macro mostrarTop10Puntos 0
	mov ah, 09h
	mov dx, t_p
	int 21h
	mov dx, t_ep
	int 21h
	mostrarTop10
%endmacro

%macro mostrarTop10Tiempo 0
	mov ah, 09h
	mov dx, t_t
	int 21h
	mov dx, t_et
	int 21h
	mostrarTop10
%endmacro

%macro mostrarTop10 0
	mov bx, [tcant]
	mov di, 0
	mov ax, 0
	push ax
	%%ciclo:
		cmp bx, 0
		je %%fin
		
		fill_t_txt
							;ESCRIBIENDO EL NUMERO
		pop ax
		inc ax
		push ax
		cmp ax, 10
		jb %%menor_diez
			mov ax, 31h
			mov t_txt[0], ax
			mov ax, 0
		%%menor_diez:
			add ax, 30h
			mov t_txt[1], ax
							;ESCRIBIENDO EL USUARIO
		mov si, 8
		mov cl, 0
		%%ing_usuario:
			mov dl, ar_desor[di]
			mov t_txt[si], dl
			inc si
			inc di
			inc cl
			cmp cl, 7
			jb %%ing_usuario
							;ESCRIBIENDO EL NIVEL
		add si, 9
		%%ing_nivel:
			mov dl, ar_desor[di]
			mov t_txt[si], dl
			inc si
			inc di
							;ESCRIBIENDO EL TIEMPO
		add si, 11
		mov cl, 0
		%%ing_puntos:
			mov dl, ar_desor[di]
			mov t_txt[si], dl
			inc si
			inc di
			inc cl
			cmp cl, 4
			jb %%ing_puntos
			
		mov dl, 10
		mov t_txt[si], dl
		inc si
		mov dl, 13
		mov t_txt[si], dl
		%%imprimir_fila:
			mov ah, 09h
			mov dx, t_txt
			int 21h
			
		dec bx
		jmp %%ciclo
		
	%%fin:
%endmacro

%macro fill_t_txt 0
	mov si, 0
	mov dl, ' '
	%%ciclo:
		mov t_txt[si], dl
		inc si
		cmp si, 42
		jb %%ciclo
%endmacro

%macro setAlturaNum 0	;alt_maxAux(char 4) a altura(int xx)
	mov si, 0
	mov al, 0		;ALTURA INT
	mov cl, 10
	%%ciclo:
		mov dl, alt_Aux[si]
		sub dl, 30h
		mul cl
		add al, dl
		inc si
		cmp si, 4
		jb %%ciclo
	mov [altura], al
%endmacro