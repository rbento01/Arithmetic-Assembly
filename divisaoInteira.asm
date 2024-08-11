org 100h                                                    
.data ;variaveis a serem utilizadas

;13 -> codigo do carriage return -> coloca o cursor no inicio da linha atual
;10 -> codigo de line feed  
    numerador db 8 dup(0) ;array que vai conter o valor para o numerador
    msgNum db 13, 10, "Introduza os valores para o numerador: $"
    divisor db 8 dup(0)
    msgDiv db 13,10, "Introduza os valores para o divisor: $" 
    contNum db 0
    contDiv db 0
    erroPonto db 13,10, "Erro, foi introduzido 1 Ponto Final $" 
    erroTecla db 13,10, "Foram introduzidos caracteres invalidos $"                         
    msgDivMaior db 13,10, "Resultado = 0 e Resto =  $"
    erroZero db 13, 10, "Nao e possivel dividir por zero $"
    mostraResto db 13, 10, "Resto = $"
    mostraResult db 13, 10, "Resultado = $"  
    numeradorInt dw 0
    divisorInt dw 0
    contHifen db 0
    contHifenDiv db 0 
    erroHifen db  " Hifen : $"
    contQuo db 0
    quo dw 0
    quociente db 8 dup(0)
    indice db 0 
    resto db 0 
    aux dw 0
    indQuo db 0     
    
.code
regNumerador:

    
    lea dx, msgNum ; load endereco msgNum
    mov ah,09h     ; escreve string
    int 21h
     
    lea si, numerador ;load endereco numerador
    
    loopNum:
        mov ah, 01h  ; recebe input
        int 21h
        cmp al, 0Dh  ; compara o codigo ASCII da tecla pressionada com o codigo ASCII do Enter (Carriage Return)
        je enter     ; se for igual salta para label enter
        sub al, 48   ; subtrai 48 para colocar no array um valor inteiro (0-9)
        mov [si],al  ; coloca no array             
        jmp verificaNum          
    
    verificaNum:      
    
        add al, 48           
        ;Compara com Backspace
        cmp al, 08h
        je backspace   
        
        ;Compara com Ponto Final
        ;cmp al, 2Eh
        ;je pontoFinal
        
        ;Compara com Virgula
        ;cmp al, 2Ch
        ;je pontoFinal  
        
        ;Compara com o Hifen
        cmp al,2Dh
        je numNegativo
        
        ;abaixo de 0
        cmp al,30h
        jb caracterInvalido
        
        ;acima de 9
        cmp al,39h
        ja caracterInvalido 
        
        inc contNum
        inc indice
        inc si 
        jmp loopNum             

numNegativo:
;se foi introduzido Hifen   
    inc contNum
    inc contHifen 
    cmp contNum,1
    ja apresentaErroHifen
    dec contNum
    jmp loopNum  
    
apresentaErroHifen:
; se foi incorretamente introduzido hifen    
    mov contHifen, 0
    mov contNum,0
    
    lea dx, erroHifen
    mov ah, 09h
    int 21h 
    
    jmp regNumerador
       
caracterInvalido:  

     lea dx, erroTecla
     mov ah, 09h
     int 21h
     mov contNum, 0 
     mov contHifen,0
     jmp regNumerador 
     
backspace:
    dec indice
    dec si
    dec contNum
    mov ah, 02h         
    mov dl, 20h ;introduz o codigo ASCII da spacebar para que apresente um espaco vazio          
    int 21h                
    mov dl, 08h ;introduz o codigo ASCII da tecla backspace para que recue uma casa          
    int 21h              
    jmp loopNum        
    
enter:
    mov cl, contNum
    cmp cl, 0
    je regNumerador   
    lea si, numerador
    xor ax,ax 
    xor cx, cx
    mov cl, contNum
    loopConv: ; loop que vai converter o conjunto de numeros do array do numerador num so numero inteiro
        mul aux                      
        mov bl,[si]                 
        mov aux,10                   
        add al,bl
        mov numeradorInt, ax 
        inc si
        loop loopConv
    mov dl,10
    mov ah,02h
    int 21h
    
    mov dl,13
    mov ah,02h
    int 21h 
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;DIVISOR;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    
regDivisor:
    xor ax, ax

    lea dx, msgDiv
    mov ah,09h
    int 21h
    mov cx, 100 
    lea si, divisor ;load endereco divisor
    
    loopDiv:
        mov ah, 01h
        int 21h
        cmp al, 0Dh                   
        je  enterDiv
        sub al, 48       
        
        mov [si],al
        jmp verificaDiv          
        
verificaDiv:      
        
        add al,48   
        
        ;Compara com Ponto Final
        ;cmp al, 2Eh
        ;je pontoFinalDiv
        
        ;Compara com Virgula
        ;cmp al, 2Ch
        ;je pontoFinalDiv
        
        ;Compara com Backspace
        cmp al, 08h
        je backspaceDiv
        
        cmp al, 2Dh
        je divNegativo
        
        
        cmp al,30h
        jb caracterInvalidoDiv
        
        cmp al,39h
        ja caracterInvalidoDiv 
         
        inc si 
        inc contDiv
        
        sub al, 48
        jmp loopDiv
        
divNegativo:   
    inc contDiv
    inc contHifenDiv 
    cmp contDiv,1
    ja apresentaErroHifenDiv
    dec contDiv
    jmp loopDiv   

apresentaErroHifenDiv:
    
    mov contHifenDiv, 0
    mov contDiv,0
    
    lea dx, erroHifen
    mov ah, 09h
    int 21h 
    
    jmp regDivisor    
        
caracterInvalidoDiv:  

     lea dx, erroTecla
     mov ah, 09h
     int 21h
     mov contDiv, 0
	 mov contHifenDiv, 0
     jmp regDivisor 
     
backspaceDiv:
    dec si
    dec contDiv
    mov ah, 02h       
    mov dl, 20h      
    int 21h          
    mov dl, 08h   
    int 21h             
    jmp loopDiv        
        
    
enterDiv:
    mov cl, contDiv
    cmp cl, 0      
    je regDivisor
    lea si, divisor
    xor ax,ax 
    xor cx, cx
    mov cl, contDiv 
    
    loopConvDiv: ; loop que vai converter o conjunto de numeros do array do numerador num so numero inteiro
        mul aux                      
        mov bl,[si]                 
        mov aux,10                   
        add al,bl
        mov divisorInt, ax 
        inc si
        loop loopConvDiv 
           
    mov dl,10
    mov ah,02h
    int 21h
    
    mov dl,13
    mov ah,02h
    int 21h         

verificaCont:
    mov bl, contHifen
    cmp bl, 1
    jne verificaCont1
    
    dec contNum
    
verificaCont1:

    mov bl, contHifenDiv
    cmp bl, 1
    jne calculo
    
    dec contDiv

    jmp calculo

tudoZeroDiv: 
    ; se o divisor tiver o valor de 0
    lea dx, erroZero
    mov ah, 09h ;escreve string
    int 21h
    jmp regDivisor

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;CALCULOS;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
calculo:
    mov ax, numeradorInt
    mov bx, divisorInt
    cmp bx, 0; verifica se o divisor tem o valor de 0
    je tudoZeroDiv
    cmp ax, bx ; compara o valor do numerador e do divisor
    inc contQuo; Incrementa o numero de digitos do quociente pois sera 0  
    jb Resultado; salta para o label que calcula o resultado
    mov bx, 0
    mov quociente[bx], 1
    mov bx, divisorInt
    cmp ax, bx
    je Resultado
    dec contQuo
    mov aux, 10
    xor ax,ax
    
selecionaNum: ;seleciona parte do numerador que e superior ao divisor
    xor bx,bx
    mov bl, indice ; Index do numerador 
    dec bl
    add al, numerador[bx] ;coloca no al o elemento [bx] do numerador 
    mov bx, divisorInt ; 
    cmp ax,bx ; compara o numero selecionado com o valor do divisor 
    jae loopMultiplicacao ; se for superior procede para o loop
    mov bx, aux
    mul bx ; multiplica o numero selecionado por 10 para poder somar o proximo elemento do array do numerador
    inc indice ; incrementa o index do array do numerador para poder selecionar o proximo elemento
    loop selecionaNum
        
loopMultiplicacao: ;loop que ira encontrar o valor de cada digito do quociente
    mov ax, divisorInt
    mov cx, numeradorInt
    mov bx, quo
    mul bx ; multiplica o valor do divisor pelo valor 
    cmp ax, cx ; compara o valor da multiplicacao do valor do digito do quociente atual com o valor do numerador
    ja decQuo ; se for superior salta para a label decQuo para decrementar uma unidade ao quo
    inc quo ; sendo a multiplicacao menor, incrementa-se o quo
    loop loopMultiplicacao
        
    decQuo: ;decrementa um unidade ao quo  e coloca o seu valor no array do quociente 
        dec quo ;decrementa o quo  
        xor bh, bh
        mov bl, indQuo  
        mov cx, quo
        mov quociente[bx], cl ;coloca o valor de quo no array do quociente
        inc contQuo ; incrementa o contador de numero de digitos do quociente 
        inc indQuo ; incrementa o index do quociente, avanca uma posicao
        
        mov ax, divisorInt ;valor do divisor
        mul cx  ; multiplica pelo quo ; ax sera igual a multiplicacao do quo pelo divisor 
        mov cx, numeradorInt ;valor do numerador 
        sub cx, ax ; ao valor do numerador subtrai-se o valor da multiplicacao que sera o resto
        mov numeradorInt, cx; O novo valor do numerador sera o valor da subtracao anterior
        
        inc indice; Incrementa o index do numerador
        mov bl, contNum ; contador de digitos do numerador
        dec bl ;decrementa para que possa ser comparado igualmente com o indice do array
        mov al, indice ;move o valor do indice do array
        cmp al, bl ; compara o valor do contador do numerador com o valor do indice do array
        ja Resultado ; se o valor do indice for superior ao do contador ja foram percorridos todos os numeros
        
        mov ax, numeradorInt ;move o valor do numerador
        mov bx, aux  ;move a variavel auxiliar com o valor de 10
        mul bx; Multiplica o numerador por 10   
        xor bh, bh
        mov bl, indice ;move o valor do indice do array numerador
        xor dx, dx
        mov dl, numerador[bx] ; move para o dl o proximo digito
        add ax, dx; Soma ao numerador o digito selecionado        
        mov numeradorInt, ax ; o numerador recebe o valor da soma anterior
   
        xor ax,ax
        xor cx,cx
        xor dx,dx
        mov quo, 0 ;novo digito para o quociente
        
        jmp loopMultiplicacao

Resultado:
    mov dl, 10
    mov ah, 02h
    int 21h
    mov dl, 13
    mov ah, 02h
    int 21h
    
    lea dx, mostraResult; load endereco mostraResult
    mov ah,9h ;escreve string
    int 21h 
    xor bh, bh
    mov bx, numeradorInt ; move o valor final do numerador para o bx
    mov resto, bl ; o resto sera o valor final do numerador
    xor bx,bx 
    xor dx, dx
    
    mov dl, contHifen
    cmp dl, contHifenDiv
    je mostraQuociente ; verifica se existem hifens em apenas um dos numeros, nos dois ou nenhum
                      ; se nao houver ou se ambos tiverem segue para a escrita do quociente    
                      ; se houver apenas num dos numeros imprime um hifen para representar um resultado negativo
    mov dx, 2Dh       ;apresenta um hifen
    mov ah,02h
    int 21h 
    
    xor dx, dx 
    mostraQuociente: ; ciclo que ira mostrar o quociente
        mov dl, contQuo ;contador do quociente
        dec dx ; decremetna um valor ao contador do quociente para ser tratado como index
        cmp bx, dx ; compara o bx, com o contador do quociente
        ja apresentaResto ;se o bx for superior ja todos os numeros foram percorridos e salta para o resto
        mov dl, quociente[bx] ; se ainda restam numeros move para o dl o digito do quociente selecionado
        mov ah,2h ;imprime esse digito
        add dl, 48 ;adiciona 48 para apresentar na consola o numero de 0-9
        int 21h
        inc bx ;incrementa bx para seguir para o proximo elemento do array do quociente
        jmp mostraQuociente

    apresentaResto: ; apresenta o resto da divisao 
        xor bx, bx
        mov dl, quociente[bx]
        cmp dl, 1
        je restoZero
        mov dl, 10
        mov ah, 02h
        int 21h
        mov dl, 13
        mov ah, 02h
        int 21h
        
        
        lea dx, mostraResto ; load endereco mostraResto
        mov ah, 09h ;escreve string
        int 21h
    
        mov dl, resto ; coloca o valor do resto no dl para que possa ser apresentado
        add dl, 48    ;adiciona 48 para apresentar na consola o numero de 0-9
        mov ah,2h     ; imprime na consola        
        int 21h
        jmp fim
        
restoZero: 
        lea dx, mostraResto ; load endereco mostraResto
        mov ah, 09h ;escreve string
        int 21h
        
        mov resto, 0 
        mov dl, resto ; coloca o valor do resto no dl para que possa ser apresentado
        add dl, 48    ;adiciona 48 para apresentar na consola o numero de 0-9
        mov ah,2h     ; imprime na consola        
        int 21h
        
         
fim:              