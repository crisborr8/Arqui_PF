%macro errorMain 0
	mov ah, 09h
	mov dx, er_Main
	int 21h
%endmacro

%macro errorOrd 0
	mov ah, 09h
	mov dx, er_Ord
	int 21h
%endmacro

%macro errorVel 0
	mov ah, 09h
	mov dx, er_Vel
	int 21h
%endmacro

%macro errorJuego 0
	mov ah, 09h
	mov dx, er_Jue
	int 21h
%endmacro

%macro errorAdmin 0
	mov ah, 09h
	mov dx, er_Adm
	int 21h
%endmacro