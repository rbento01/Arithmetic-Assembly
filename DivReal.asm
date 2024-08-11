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
    erroPontoVirg db 13,10, "Erro, foi introduzido mais do que 1 Ponto Final $"  
    
    contPontVirgNum db 0  
    contPontVirgDiv db 0
    
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
        add numerador[0],48
	
        cmp numerador[0], 2Ch
        je erroPontVirgNum
                      
        cmp numerador[0], 2Eh
        je erroPontVirgNum
	
        sub numerador[0],48
        
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

erroPontVirgNum:
     
    lea dx, erroPontoVirg
    mov ah,09h
    int 21h
    mov contPontVirgNum, 0
    mov contNum, 0
    jmp regNumerador    
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
      
        add divisor[0],48
	
        cmp divisor[0], 2Ch
        je erroPontVirgDiv
                      
        cmp divisor[0], 2Eh
        je erroPontVirgDiv
	
        sub divisor[0],48
        
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
        
erroPontVirgDiv:
     
    lea dx, erroPontoVirg
    mov ah,09h
    int 21h
    mov contPontVirgDiv, 0
    mov contDiv, 0
    jmp regDivisor  
     
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
fim:              