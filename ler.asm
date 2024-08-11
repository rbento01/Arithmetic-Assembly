.model small
.stack 100
.data 

    fname1 db "teste.txt",0
    
    text db 1024 dup(?) ;nao tenho a certeza disto
    
    endereco db 23 dup(?)
    
    tamanhoEnde dw ?
    
    fhand dw ?
    
    posicao dw 0
    
    IndexCount dw 5
    
    Index dw ?
   ; teste dw ?
    
    dois db 2
    dez db 10
    
    arrayIndex db 8 dup(0)
    
.code
    mov ax,@data
    mov ds,ax
 

    mov ah,3dh    ; 3dh funcao para abrir o ficheiro
    mov al,0      ; 0 para leitura
    lea dx,fname1 ; dx aponta para o nome do ficheiro
    int 21h       ;
    mov fhand,ax  ; guarda o handle do ficheiro
    mov si, 0
    
Ler:

    mov ah,3fh    ; 3fh funcao para ler do ficheiro
    mov bx,fhand  ; bx recebe o valor do file handle 
    mov cx,1      ; le um byte
    lea dx,text[si]
    int 21h       ; se chegou ao fim o al passa a 0

    cmp al,cl     ; compara se ja chegou ao fim, se 0 = 0
    JNE fechaFile
    INC SI        ; Incrementa o SI(source index)
    JMP Ler     

fechaFile:
    MOV AH,3EH    ; fecha o ficheiro
    INT 21H
testEndereco:
    mov dl, 10
    mov ah, 02
    int 21h
    
    mov dl, 13      ;vai buscar o proximo endereco do array text
    mov ah, 02
    int 21h
    mov si,posicao 
    mov di, 0 
    mov tamanhoEnde, 0
    
runEndereco:
    xor ax,ax
    MOV al, text[si]
    mov endereco[di], al
    
    cmp endereco[di], 29h     ; tira um endereco do array text para o endereco
    je sairEndereco
    
    inc di
    inc si
    inc posicao
    inc tamanhoEnde
    jmp runEndereco
    
   
sairEndereco:
    
    inc di 
    MOV endereco[di],"$"
    mov ah,9h     ; mostra no ecra o endereco
    lea dx,endereco
    int 21h
    
    mov ah,2h     ; mostra no ecra uma barra
    mov dx,179
    int 21h
    inc posicao
    xor si, si
    
    ;mov ah,2h     ; mostra no ecra um S
;    mov dx,83
;    int 21h
    
    
    sub tamanhoEnde, 3
    mov si, tamanhoEnde  
    
    sub si, IndexCount    ; para calculo do index
    
    mov bx, IndexCount
    dec bx
    mov Index, 0

separa:  ;separa a Index
    
    xor cx, cx
    mov cx, bx
    
    mov ah,2h     ; mostra no ecra o elemento que esta no endereco    
    mov dl,endereco[si]
    int 21h
    
    mov al, endereco[si]
    sub ax, 30h
    
    cmp bx, 0
    je eZero
    
    
    multiplicador:
    
    mul dois
    dec cx
    ;mov teste, ax        ;passa a Index para decimal
    cmp cx, 0
    je sairMultiplicador
    
           
    
    jmp multiplicador       
         
    sairMultiplicador:
      
    add Index, ax  
    
    inc si
    
    dec bx
    cmp si, tamanhoEnde
    je  mostraConjunto
    
    
    jmp separa

eZero:
    
    cmp endereco[si], 30h
    je naoAdiciona
   
    add Index, 1  
     
naoAdiciona:
       
     
     
                         ; ATe aqui esta certo
mostraConjunto:
    
    
    mov arrayIndex, 0
    xor ax, ax
    xor si, si
    mov ax, Index
    
    mov si, 7
   
    meteArray:
      xor dx, dx
      xor ah, ah
     div dez
     
     mov arrayIndex[si], ah
     dec si
     cmp si, 0
     je sairArray
     
     jmp meteArray         
              
              
    sairArray:
    xor ax, ax
    mov si, 0
    
    mov ah,2h     ; mostra no ecra uma barra
    mov dx,179
    int 21h
    
    
    
    mov ah,2h     ; mostra no ecra um S
    mov dx,83
    int 21h
    
    mostraArray:
    xor dx, dx
    cmp arrayIndex[si], 0
    je seZero
    jne seNumero
    
    seZero:
    inc si
    jmp mostraArray
    
    seNumero:
    mov ah,2h     ; mostra no ecra    
    mov dl,arrayIndex[si]
    add dx, 30h
    int 21h
    inc si
    cmp si, 8
    je testEndereco
    jmp seNumero
    
    mov ah,4ch
    int 21h
end