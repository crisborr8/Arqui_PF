 %macro user_Main 0
	%%ciclo:
		mostrarMenu_Usuario
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
		load_Juego
		jmp %%ciclo
	%%dos:
		user_Cargar
		jmp %%ciclo
	%%fin:
 %endmacro
 
 ;CARGA DE ARCHIVO
 %macro user_Cargar 0
	mov ah, 09h
	mov dx, p_2
	int 21h
 %endmacro