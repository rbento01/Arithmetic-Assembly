name 'PartirArray'    
org 100h


;Ir para o inicio do programa
jmp start
start:  
  
;Escreve a mensagem de introducao do dividendo
mensagemDividendo:
    mov dl, 10; New line ASCII
    mov ah, 02h; Escreve um caracter
    int 21h; Do it
    mov dl, 13
    mov ah, 02h
    int 21h
    
    lea dx, msgHelloWrld; Endereco da source
    mov ah,9h; Escreve string
    int 21h  
    jmp InsercArray

;Vai buscar o dividendo, 1 digito de cada vez, ou seja cada 
;iteracao vai buscar um digito	
InsercArray: 
    mov ah,1h; Input de um caracter
    int 21h
    mov dl,al
    
    cmp dl, 0Dh; Compara com o valor introduzido pela tecla ENTER
    ;(0DH)
    jz juntarNumeros; Caso o utilizador carregue no ENTER
    
    mov bx, index; Numero de digitos atuais
    sub dl, 48; Converte para decimal
    mov digitosArray[bx],dl; Vai por os elementos no array 
    inc lengthArray; Aumenta o valor do numero de digitos 
    inc index 
    loop InsercArray
    
xor cx,cx

juntarNumeros:   

    mov ax,10           ;ax = 10
    mul array[cx]       ;ax = 10*array[cx]
    inc cx              ;cx = cx + 1  
    add ax, array[cx]   ;ax = 10*array[cx] + array[cx+1] 
    
    inc cx              ;cx = cx + 1  
     
     
    cmp bx, lengthArray ;compara se o indice ja chegou ao final do array
    ;se for passa para o proximo passo
    je NextPasso 
   
   
    loop juntarNumeros
    
   

;Para o programa
stop:
    ret; return


  
;Mensagens a apresentar
msgHelloWrld db "Insira um array $"


;Variaveis e constantes
numMax equ 5
index dw 0 
aux dw 1

 
digitosArray db numMax Dup(0); Array que vai conter os digitos do array
lengthArray dw 0;Numero de digitos do array
