%macro errorMain 0
	mov ah, 09h
	mov dx, er_Main
	int 21h
%endmacro