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