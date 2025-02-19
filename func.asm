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

section .bss

NUM resb 16
NUM_INV resb 16
NUM_SZ resb 16

section .data

newline db 0Ah

msg1 db "Mensagem 1: Cabe no Primeiro!", 0Ah  ; Mensagem 1
len1 equ $ - msg1  ; Tamanho da mensagem 1

msg2 db "Mensagem 2: Cabe no Segundo!", 0Ah    ; Mensagem 2
len2 equ $ - msg2  ; Tamanho da mensagem 2

msg3 db "Mensagem 3: Cabe no Terceiro!", 0Ah   ; Mensagem 3
len3 equ $ - msg3  ; Tamanho da mensagem 3

msg4 db "Mensagem 4: Cabe no Quarto!", 0Ah     ; Mensagem 4
len4 equ $ - msg4  ; Tamanho da mensagem 4

; Mensagem de saída: Alocação no segmento: x, alocado do x byte ao y byte. 0xA
header db "Alocação no segmento "  
lenheader equ $ - header  

alocadoDo db ": alocado do "  
lenalocadoDo equ $ - alocadoDo 

byteAo db " byte ao "  
lenbyteAo equ $ - byteAo 

byteOxA db " byte.", 0Ah
lenbyteOxA equ $ - byteOxA 

naoCabe db "O programa não cabe na memória!", 0Ah
lenNCabe equ $ - naoCabe

section .text 
global carregador

carregador:
    enter 0, 0

    push programSize
    push addressOne
    mov ebx, programSize
    cmp ebx, sizeOne
    jbe cabeNoPrimeiro; isso aqui nao seta o ra?
    pop eax
    pop eax

    push programSize
    push addressTwo
    mov ebx, programSize
    cmp ebx, sizeTwo
    jbe cabeNoSegundo; isso aqui nao seta o ra?
    pop eax
    pop eax

    push programSize
    push addressThree
    mov ebx, programSize
    cmp ebx, sizeThree
    jbe cabeNoTerceiro; isso aqui nao seta o ra?
    pop eax
    pop eax

    push programSize
    push addressFour
    mov ebx, programSize
    cmp ebx, sizeFour
    jbe cabeNoQuarto; isso aqui nao seta o ra?
    pop eax
    pop eax

    mov eax, sizeOne
    add eax, sizeTwo
    add eax, sizeThree
    add eax, sizeFour
    cmp eax, programSize
    jl naoNaoPraAlocar


fim:
    leave
    ret


cabeNoPrimeiro:
    enter 0, 0

    ; "Cabe no primeiro"
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, len1
    int 0x80

    mov eax, [EBP + 4]; + 4? wtf
    mov ebx, [EBP + 8]

    dec ebx ; range fechado, precisa subtrair um
    add ebx, eax

    push eax
    push ebx
    call printSegment
    pop eax
    pop eax

    leave
    jmp fim

cabeNoSegundo:
    enter 0, 0

    ; "Cabe no segundo"
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, len2
    int 0x80

    mov eax, [EBP + 4]; + 4? wtf
    mov ebx, [EBP + 8]

    dec ebx ; range fechado, precisa subtrair um
    add ebx, eax

    push eax
    push ebx
    call printSegment
    pop eax
    pop eax

    leave
    jmp fim

cabeNoTerceiro:
    enter 0, 0

    ; "Cabe no terceiro"
    mov eax, 4
    mov ebx, 1
    mov ecx, msg3
    mov edx, len3
    int 0x80

    mov eax, [EBP + 4]; + 4? wtf
    mov ebx, [EBP + 8]

    dec ebx ; range fechado, precisa subtrair um
    add ebx, eax

    push eax
    push ebx
    call printSegment
    pop eax
    pop eax

    leave
    jmp fim

cabeNoQuarto:
    enter 0, 0

    ; "Cabe no quarto"
    mov eax, 4
    mov ebx, 1
    mov ecx, msg4
    mov edx, len4
    int 0x80

    mov eax, [EBP + 4]; + 4? wtf
    mov ebx, [EBP + 8]

    dec ebx ; range fechado, precisa subtrair um
    add ebx, eax

    push eax
    push ebx
    call printSegment
    pop eax
    pop eax

    leave
    jmp fim

naoNaoPraAlocar:
    enter 0, 0

    ; "Não cabe"
    mov eax, 4
    mov ebx, 1
    mov ecx, naoCabe
    mov edx, lenNCabe
    int 0x80

    leave
    jmp fim

printSegment:
    enter 0, 0

    ; Alocação no segmento: 
    mov eax, 4
    mov ebx, 1
    mov ecx, header
    mov edx, lenheader
    int 0x80

    mov eax, [EBP + 12]
    push eax
    call print_num
    pop eax

    ; alocado do
    mov eax, 4
    mov ebx, 1
    mov ecx, alocadoDo
    mov edx, lenalocadoDo
    int 0x80

    mov eax, [EBP + 12]
    push eax
    call print_num
    pop eax

    ; byte ao
    mov eax, 4
    mov ebx, 1
    mov ecx, byteAo
    mov edx, lenbyteAo
    int 0x80

    mov eax, [EBP + 8]
    push eax
    call print_num
    pop eax

    ; byte ao
    mov eax, 4
    mov ebx, 1
    mov ecx, byteOxA
    mov edx, lenbyteOxA
    int 0x80

    leave
    ret

print_num:
    enter 0, 0

    mov eax, [ebp + 8]; pega o parametro da stack
    mov ebx, NUM_INV; ponteiro pra NUM
    mov byte [NUM_SZ], 0; coloca 0 no size (por enquanto)

    print_loop:
        mov edx, 0; limpa o regitrador 
        mov ecx, 10; vou dividir por 10
        div ecx; divide por ecx -- nao posso fazer div 10?
        ; eax -> quociente e edx -> resto
        add edx, '0'
        mov [ebx], edx
        add ebx, 1; move o ponteiro
        inc byte [NUM_SZ]
        cmp eax, 0
        jne print_loop

    dec ebx; volta pro ultimo caractere (tava no proximo disponivel)

    mov eax, NUM; ponteiro pra NUM
    mov ecx, [NUM_SZ]; pega o size
    reverse_loop:
        mov edx, [ebx]; salva o digito em edx
        mov [eax], edx; copia o digito para num
        inc eax; move o ponteiro pra frente
        dec ebx; move o ponteiro pra tras
        loop reverse_loop

    mov eax, 4
    mov ebx, 1
    mov ecx, NUM
    mov edx, [NUM_SZ]
    int 80h

    leave
    ret