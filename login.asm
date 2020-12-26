%macro ingresar 0
	mov ah, 09h
	mov dx, l_1
	int 21h
	
	mov dx, l_3
	int 21h
	resetUsr
	getDatoUsr
	
	mov ah, 09h
	mov dx, l_4
	int 21h
	resetPsw
	getDatoPsw
	
	cmp cl, 1
	je %%errorPsw
		ingresarData
	call %%fin
	%%errorPsw:
		salto
		mov ah, 09h
		mov dx, er_IngrPsw
		int 21h
		salto
	%%fin:
%endmacro

%macro ingresarData 0
	salto
	mov ah, 09h
	mov dx, usr
	int 21h
	salto
%endmacro

%macro registrar 0
	mov ah, 09h
	mov dx, l_2
	int 21h
	
	mov dx, l_3
	int 21h
	resetUsr
	getDatoUsr
	
	mov ah, 09h
	mov dx, l_4
	int 21h
	resetPsw
	getDatoPsw
%endmacro