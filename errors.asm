%macro errorMain 0
	mov ah, 09h
	mov dx, er_Main
	int 21h
%endmacro

%macro errorJuego 0
	mov ah, 09h
	mov dx, er_Jue
	int 21h
%endmacro