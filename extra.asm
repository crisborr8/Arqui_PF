%macro salto 0
	mov ah, 09h
	mov dx, slt
	int 21h
	mov dx, pts
	int 21h
%endmacro