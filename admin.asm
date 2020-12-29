 %macro admin_Main 0
	%%ciclo:
		mostrarMenu_Admin
		getChar
		salto
		
		cmp al, 49
		je %%uno
		cmp al, 50
		je %%dos
		cmp al, 51
		je %%fin
		errorMain
		jmp %%ciclo
	%%uno:
		admin_Pts
		jmp %%ciclo
	%%dos:
		admin_Tiempo
		jmp %%ciclo
	%%fin:
 %endmacro
 
 %macro admin_Pts 0
	mov ah, 09h
	mov dx, p_1
	int 21h
 %endmacro
 
 %macro admin_Tiempo 0
	mov ah, 09h
	mov dx, p_2
	int 21h
 %endmacro