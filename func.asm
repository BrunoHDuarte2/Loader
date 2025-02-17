; Locais dos parametros na pilha
%define programSize dword [EBP+8]
%define addressOne dword [EBP+12]
%define sizeOne dword [EBP+16]
%define addressTwo dword [EBP+20]
%define sizeTwo dword [EBP+24]
%define addressThree dword [EBP+28]
%define sizeThree dword [EBP+32]
%define addressFour dword [EBP+36]
%define sizeFour dword [EBP+40]

section .data
    msg1 db "Mensagem 1: Cabe no Primeiro!", 0xA  ; Mensagem 1
    len1 equ $ - msg1  ; Tamanho da mensagem 1

    msg2 db "Mensagem 2: Cabe no Segundo!", 0xA    ; Mensagem 2
    len2 equ $ - msg2  ; Tamanho da mensagem 2

    msg3 db "Mensagem 3: Cabe no Terceiro!", 0xA   ; Mensagem 3
    len3 equ $ - msg3  ; Tamanho da mensagem 3

    msg4 db "Mensagem 4: Cabe no Quarto!", 0xA     ; Mensagem 4
    len4 equ $ - msg4  ; Tamanho da mensagem 4
    
    ; Mensagem de saída: Alocação no segmento: x, alocado do x byte ao y byte. 0xA
    header db "Alocação no segmento: "  
    lenheader equ $ - header  
    
    alocadoDo db ", alocado do "  
    lenalocadoDo equ $ - alocadoDo 

    byteAo db " byte ao "  
    lenbyteAo equ $ - byteAo 

    byteOxA db " byte.", 0xA
    lenbyteOxA equ $ - byteOxA 

    naoCabe db "O programa não cabe na memória!", 0xA
    lenNCabe equ $ - naoCabe 

section .bss 
    buffer resb 16
section .text 
    global carregador

carregador:
    ; Função chamada pelo C
    ; Da forma como foi empilhado no C os parametros estão da forma mais usual possível
    ; Sendo assim, o tamanho do programa se encontra no [EBP+8] e assim por diante.
    push ebp
    mov ebp, esp ; Essas duas linhas podem ser substituidas por enter 0,0

    mov ebx, programSize  ; Carrega programSize em EBX
    cmp ebx, sizeOne
    jbe cabeNoPrimeiro  ; Se programSize <= sizeOne, pula para cabeNoPrimeiro
	cmp ebx, sizeTwo
    jbe cabeNoSegundo  ; Se programSize <= sizeOne, pula para cabeNoPrimeiro
	cmp ebx, sizeThree
    jbe cabeNoTerceiro  ; Se programSize <= sizeOne, pula para cabeNoPrimeiro
	cmp ebx, sizeFour
    jbe cabeNoQuarto  ; Se programSize <= sizeOne, pula para cabeNoPrimeiro
	jmp alocador

fim:
	pop ebp 
	ret

cabeNoPrimeiro:
    mov eax, 4            
    mov ebx, 1           
    mov ecx, msg1        
    mov edx, len1        
    int 0x80             
    jmp fim             

cabeNoSegundo:
    mov eax, 4           
    mov ebx, 1            
    mov ecx, msg2         
    mov edx, len2        
    int 0x80             
    jmp fim              

cabeNoTerceiro:
    mov eax, 4          
    mov ebx, 1            
    mov ecx, msg3        
    mov edx, len3         
    int 0x80            
    jmp fim              

cabeNoQuarto:
    mov eax, 4            
    mov ebx, 1            
    mov ecx, msg4         
    mov edx, len4         
    int 0x80              
    jmp fim 


alocador:
    ; totalSize
    mov eax, 0
    add eax, sizeOne
    add eax, sizeTwo
    add eax, sizeThree
    add eax, sizeFour
    cmp eax, programSize
    jl naoVaiCaber

	mov ebx, programSize
	; Alocação primeiro segmento
    sub ebx, sizeOne ; Subtrai de programSize o sizeOne 
    ; Empilhando parametros pra chamada de função: 
    push ebx ; Tamanho do programa atualmente -> programSize-sizeOne
    push sizeOne ; tamanho do segmento  
    push addressOne ; endereço do primeiro segmento
    call printSegment ; Mostra o segmento
    pop eax ; desempilha o que foi empilhado anteriormente 
    pop eax
    pop eax
    cmp ebx, 0 ; Se o programSize for menor ou igual a zero ele foi totalmente alocado
    jle totallyAlocated
    ; Alocação segundo segmento
	sub ebx, sizeTwo ; Subtrai de programSize o sizeTwo
    push ebx ; Tamanho do programa atualmente
    push sizeTwo ; tamanho do segmento  
    push addressTwo ; endereço do primeiro segmento
    call printSegment ; Mostra o segmento
    pop eax ; desempilha o que foi empilhado anteriormente 
    pop eax
    pop eax
    cmp ebx, 0 ; Se o programSize for menor ou igual a zero ele foi totalmente alocado
    jle totallyAlocated
    ; Alocação segundo Terceiro
	sub ebx, sizeThree ; Subtrai de programSize o sizeTwo
    push ebx ; Tamanho do programa atualmente
    push sizeThree ; tamanho do segmento  
    push addressThree ; endereço do primeiro segmento
    call printSegment ; Mostra o segmento
    pop eax ; desempilha o que foi empilhado anteriormente 
    pop eax
    pop eax
    cmp ebx, 0 ; Se o programSize for menor ou igual a zero ele foi totalmente alocado
    jle totallyAlocated
    ; Alocação segundo Quarto
	sub ebx, sizeFour ; Subtrai de programSize o sizeTwo
    push ebx ; Tamanho do programa atualmente
    push sizeFour ; tamanho do segmento  
    push addressFour ; endereço do primeiro segmento
    call printSegment ; Mostra o segmento
    pop eax ; desempilha o que foi empilhado anteriormente 
    pop eax
    pop eax
    cmp ebx, 0 ; Se o programSize for menor ou igual a zero ele foi totalmente alocado
    jle totallyAlocated

naoVaiCaber:
    call printNaoCabe
    pop ebp
    ret 

printNaoCabe:
    push EBP
    mov ebp, esp
    mov eax, 4            
    mov ebx, 1           
    mov ecx, naoCabe        
    mov edx, lenNCabe        
    int 0x80  
    pop ebp 
    ret

totallyAlocated:
    pop ebp
    ret
printSegment:
    push ebp
    mov ebp, esp
    push ebx ; salva o valor de ebx que está sendo usado no alocador

    mov eax, 4
    mov ebx, 1
    mov ecx, header
    mov edx, lenheader
    int 80h

    ; Printar o valor salvo em addressOne, que está na pilha em [ebp+8]
    mov eax, [EBP+8]
    mov edi, buffer+15
    mov byte [edi], 0 ; str =....0
convertAddress:
    dec edi ; move o ponteiro do buffer 
    ; str[i] = (char) ((v%10)+0x30)
    mov edx, 0 ; tirar lixo de memória
    mov ecx, 10
    div ecx
    add dl, 30h
    mov [edi], dl ; move o char para o buffer

    test eax, eax   ; Verifica se ainda há mais dígitos
    jnz convertAddress ; Se EAX ainda for maior que 0, continua

    ; Imprimir string armazenada em buffer
    mov eax, 4      ; syscall write
    mov ebx, 1      ; stdout
    mov ecx, edi    ; Ponteiro para a string
    mov edx, buffer
    add edx, 16
    sub edx, edi
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, alocadoDo
    mov edx, lenalocadoDo
    int 80h
    
    mov eax, 4      ; syscall write
    mov ebx, 1      ; stdout
    mov ecx, edi    ; Ponteiro para a string
    mov edx, buffer
    add edx, 16
    sub edx, edi
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, byteAo
    mov edx, lenbyteAo
    int 80h

    mov ebx, [EBP+16] ; -> programSize-sizeOne-> se é positivo então falta alocação, se é negativo ou 0 foi totalmente alocado
    mov ecx, [EBP+12]
    cmp ebx, 0 
    jge programaFaltaAlocar ; Se falta alocar então ele vai pro próximo segmento, então só falta mostrar o tamanho do size empilhado
    ; Nesse caso, como simplesmente ocupou tudo, foi do byte de inicio ao byte de fim
    ; Nesse caso só precisa saber quanto foi alocado, já sabendo que ele foi completamente alocado nesse segmento
    ; Sobrou espaço
    add ebx, ecx ; programsize
    sub ecx, ebx
    add ecx, [ebp+8]
    mov eax, ecx
    sub eax, 1
    mov edi, buffer+15
    mov byte [edi], 0 ; str =....0
    jmp printSize
programaFaltaAlocar:
    mov eax, [EBP+12] ; sizeOne
    add eax, [EBP+8]
    sub eax, 1
    mov edi, buffer+15
    mov byte [edi], 0 ; str =....0
printSize:
    dec edi ; move o ponteiro do buffer 
    ; str[i] = (char) ((v%10)+0x30)
    mov edx, 0 ; tirar lixo de memória
    mov ecx, 10
    div ecx
    add dl, 30h
    mov [edi], dl ; move o char para o buffer

    test eax, eax   ; Verifica se ainda há mais dígitos
    jnz printSize ; Se EAX ainda for maior que 0, continua

    ; Imprimir string armazenada em buffer
    mov eax, 4      ; syscall write
    mov ebx, 1      ; stdout
    mov ecx, edi    ; Ponteiro para a string
    mov edx, buffer
    add edx, 16
    sub edx, edi
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, byteOxA
    mov edx, lenbyteOxA
    int 80h

    pop ebx
    pop ebp 
    ret







