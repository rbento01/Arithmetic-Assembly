org 100h

.data
    numerador db 100 dup(0) ;array que vai conter o valor para o numerador
    msgNum db 13, 10, "Introduza os valores para o numerador: $"; enter (carriage return), linefeed, m
    divisor db 100 dup(0)
    msgDiv db 13,10, "Introduza os valores para o divisor: $" 
    contNum db 0
    contDiv db 0
    erroPonto db 13,10, "Erro, foi introduzido 1 Ponto Final $"; enter, linefeed, msg
    pont db 0
    contZero db 0 
    erroTecla db 13,10, "Foram introduzidos caracteres invalidos $"
    msgContDiv db 13,10, "Contador do Divisor = $" 
    msgContNum db 13,10, "Contador do Numerador = $"                         
    msgDivMaior db 13,10, "Resultado = 0 e Resto =  $"  
    msgNumMaiorIgual db 13,10, " Contador do Numerador maior ou igual que o do Divisor $"
    erroZero db 13, 10, "Nao e possivel dividir por zero $"
    contZeroDiv db 0  
    msgDigMaior db 13,10, " digito maior que o do divisor $"
    msgDigIgual db 13,10, " digito igual $"
    msgDigMenor db 13,10, " digito menor que o do divisor $"
    numeradorInt db 100 dup(0)
    divisorInt db 100 dup(0)
    msgTeste db  " TESTE DE CONVERSAO : $"
    contHifen db 0
    contHifenDiv db 0 
    erroHifen db  " Hifen : $"
    cont db 0 
    contQuociente db 0
    quociente db 100 dup(0)
    indice db 0 
    numerMaior db "Numerador Maior $"
     
.code
regNumerador:
    
    mov ax,@data
    mov ds, ax
    
    lea dx, msgNum ; loading the address of msgNum
    mov ah,09h
    int 21h
    
    mov cx, 100 ; going through the loop 4 times
    lea si, numerador ;loading the address of array
    
    loopNum:
        mov ah, 01h
        int 21h
        ;sub al, 30h
        sub al, 48
        mov [si],al
        mov quociente[bx], al
        inc bx               
        inc indice
        jmp verificaNum          

        loop loopNum

;loop to request 4 numbers to the array    
    verificaNum:      
        
        add al, 48   
        ;Compara com ENTER
        cmp al, 0Dh ;compare the key pressed with the enter ASCII code
        je  enter    ;if enter was pressed jump to "rest"   
;        
;        ;Compara com Ponto Final
;        cmp al, 2Eh
;        je pontoFinal
;        
;        ;Compara com Virgula
;        cmp al, 2Ch
;        je pontoFinal
;        
;        Compara com Backspace
        cmp al, 08h
        je backspace
        
        ;Compara com o Hifen
        cmp al,2Dh
        je numNegativo
        
        sub al, 48
        
        cmp al,0
        jb caracterInvalido
        
        cmp al,9
        ja caracterInvalido 
         
        inc si 
        inc contNum
        
        cmp al, 0
        je zero
        jmp loopNum

numNegativo:   
    inc contNum
    inc contHifen 
    cmp contNum,1
    ja apresentaErroHifen
    
    jmp loopNum  
     
    inc contHifen
    
    cmp contHifen,2
    ja apresentaErroHifen
    
apresentaErroHifen:
    
    mov contHifen, 0
    mov contNum,0
    
    lea dx, erroHifen
    mov ah, 09h
    int 21h 
    
    jmp regNumerador
    
zero: 
    inc contZero
    jmp loopNum
       
caracterInvalido:  

     lea dx, erroTecla
     mov ah, 09h
     int 21h
     mov pont, 0
     mov contNum, 0 
     mov contHifen,0
     jmp regNumerador 
     
backspace:
    
    dec si
    dec contNum
    mov ah, 02h         ; DOS Display character call 
    mov dl, 20h         ; A space to clear old character 
    int 21h             ; Display it  
    mov dl, 08h         ; Another backspace character to move cursor back again
    int 21h             ; Display it 
    jmp loopNum        
        
pontoFinal:
     
    lea dx, erroTecla ; loading the address of erroTecla
    mov ah,09h
    int 21h
    mov pont, 0
    mov contNum, 0
    mov contHifen, 0
    jmp regNumerador
    
enter:   

    mov dl,10
    mov ah,02h
    int 21h
    
    mov dl,13
    mov ah,02h
    int 21h
                   
;    mov bl, contZero
;    cmp bl, contNum
;    je tudoZero
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;DIVISOR;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    
regDivisor:
    mov contZero, 0   

    lea dx, msgDiv
    mov ah,09h
    int 21h
    mov cx, 100 ; going through the loop 4 times
    lea si, divisor ;loading the address of array
    
    loopDiv:
        mov ah, 01h
        int 21h
        sub al, 48       
        
        mov [si],al
        jmp verificaDiv          
              
        loop loopDiv
        
verificaDiv:      
        
        add al,48
        ;Compara com ENTER
        cmp al, 0Dh ;compare the key pressed                     ;with the enter ASCII code
        je  enterDiv    ;if enter was pressed jump to "rest"   
        
        ;Compara com Ponto Final
        cmp al, 2Eh
        je pontoFinalDiv
        
        ;Compara com Virgula
        cmp al, 2Ch
        je pontoFinalDiv
        
        ;Compara com Backspace
        cmp al, 08h
        je backspaceDiv
        
        cmp al, 2Dh
        je divNegativo
        sub al,48
        
        cmp al,0
        jb caracterInvalidoDiv
        
        cmp al,9
        ja caracterInvalidoDiv 
         
        inc si 
        inc contDiv
        
        cmp al, 0
        je zeroDiv
        jmp loopDiv
        
divNegativo:   
    inc contDiv
    inc contHifenDiv 
    cmp contDiv,1
    ja apresentaErroHifenDiv
    
    jmp loopDiv   

apresentaErroHifenDiv:
    
    mov contHifenDiv, 0
    mov contDiv,0
    
    lea dx, erroHifen
    mov ah, 09h
    int 21h 
    
    jmp regDivisor
zeroDiv: 
    inc contZeroDiv
    jmp loopDiv    
        
caracterInvalidoDiv:  

     lea dx, erroTecla
     mov ah, 09h
     int 21h
     mov pont, 0
     mov contDiv, 0
	 mov contHifenDiv, 0
     jmp regDivisor 
     
backspaceDiv:
    
    dec si
    dec contDiv
    mov ah, 02h         ; DOS Display character call 
    mov dl, 20h         ; A space to clear old character 
    int 21h             ; Display it  
    mov dl, 08h         ; Another backspace character to move cursor back again
    int 21h             ; Display it 
    jmp loopDiv        
        
pontoFinalDiv:
     
    lea dx, erroTecla ; loading the address of erroTecla
    mov ah,09h
    int 21h
    mov pont, 0
    mov contDiv, 0
	mov contHifenDiv, 0
    jmp regDivisor
    
enterDiv:  

    mov dl,10
    mov ah,02h
    int 21h
    
    mov dl,13
    mov ah,02h
    int 21h 
    
    mov bl, contZeroDiv
    cmp bl, contDiv
;    je tudoZeroDiv

;    mov bl, contZeroDiv
;    cmp bl, contDiv
;    je tudoZeroDiv
       

verificaCont:
    mov bl, contHifen
    cmp bl, 1
    jne verificaCont1
    
    dec contNum
    
verificaCont1:
    mov bl, contHifenDiv
    cmp bl, 1
    jne mostraCont
    
    dec contDiv
 
mostraCont:
;
;;print do CONTADOR ( HEX para DECIMAL)
;lea dx, msgContNum
;mov ah,09h
;int 21h    
;mov al, contNum      ; Your example (12)
;aam                ; -> AH is quotient (1) , AL is remainder (2)
;add ax, 3030h      ; -> AH is "1", AL is "2"
;push ax            ; (1)
;mov dl, ah         ; First we print the tens
;mov ah, 02h        ; DOS.PrintChar
;int 21h
;pop dx             ; (1) Secondly we print the ones (moved from AL to DL via those PUSH AX and POP DX instructions
;mov ah, 02h        ; DOS.PrintChar
;int 21h
;
;lea dx, msgContDiv
;mov ah,09h
;int 21h    
;mov al, contDiv      ; Your example (12)
;aam                ; -> AH is quotient (1) , AL is remainder (2)
;add ax, 3030h      ; -> AH is "1", AL is "2"
;push ax            ; (1)
;mov dl, ah         ; First we print the tens
;mov ah, 02h        ; DOS.PrintChar
;int 21h
;pop dx             ; (1) Secondly we print the ones (moved from AL to DL via those PUSH AX and POP DX instructions
;mov ah, 02h        ; DOS.PrintChar
;int 21h
    
comparaCont:  

    mov bl, contNum
    cmp bl, contDiv
    jb divMaior
    jae numIguais

    jmp calculo

numIguais:
    lea dx, msgNumMaiorIgual
    mov ah,09h
    int 21h
    jmp calculo
        
divMaior:
;jmp quociente = 0 e resto = divisor  
    lea dx, msgDivMaior
    mov ah,09h
    int 21h
    
    lea si, numerador
    loopRestoNum:   
        
        mov dl,[si]
        mov ah,02h
        int 21h
        add dl, 48        
        cmp dl, 0Dh  
        je  selecDig
        
        inc si
     loop loopRestoNum
     jmp converte
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;CALCULOS;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
calculo:
mov cl, contDiv
mov si, 0
comparaDigitos:
     ;lea si, numerador
     cmp cl, 0
     je  converte
      
     mov dl, 10
     mov ah, 02
     int 21h
     
     mov dl, 13
     mov ah, 02
     int 21h
     
     mov dl,numerador[si]
     mov ah,02h
     int 21h
     
     mov dl, 10
     mov ah, 02
     int 21h
     
     mov dl, 13
     mov ah, 02
     int 21h
     
     mov dl,divisor[si]
     mov ah,02h
     int 21h
     
     mov dl, 10
     mov ah, 02
     int 21h
     
     mov dl, 13
     mov ah, 02
     int 21h
     
     mov bl, numerador[si]
     cmp bl, divisor[si]
     
     ja digitoMaior
     jb digitoMenor
     je digitoIgual
     loop comparaDigitos
     jmp converte

digitoMaior:
    lea dx, msgDigMaior
    mov ah, 09h 
    int 21h
    dec cl
    inc si
    jmp comparaDigitos

digitoMenor:
    lea dx, msgDigMenor
    mov ah, 09h 
    int 21h
    dec cl
    inc si    
    jmp comparaDigitos
    ;jmp quociente = 0 e resto = numerador
    
digitoIgual:
    lea dx, msgDigIgual
    mov ah, 09h 
    int 21h
    dec cl
    inc si
    jmp comparaDigitos

converte:
    
    xor ax, ax
    xor bx, bx
     
    mov al, 9
    mov bl,quociente[0]
    mul bx 
    
    mov quociente[0], al
;    add quociente[0], 30h
    xor bx, bx
    escreveDigitos:
        mov dl, indice
        dec dx
        cmp bx, dx
        ja escreveDigitos1; Quando o contador bx for maior que tamanho-1
        mov ah,2h
        mov dl, quociente[bx]
        add dl, 48; Converte para hex outra vez para poder
        ;escrever corretamente na consola
        int 21h
        inc bx
        jmp escreveDigitos     
        
    
    escreveDigitos1:
        xor bx, bx
        mov dl,10
        mov ah,02h
        int 21h
        
        mov dl,13
        mov ah,02h
        int 21h
        escreveDigitos2:
        mov dl, indice
        dec dx
        cmp bx, dx
        ja selecDig; Quando o contador bx for maior que tamanho-1 
        
        mov ah,2h
        mov dl, numerador[bx]
        add dl, 48; Converte para hex outra vez para poder
        ;escrever corretamente na consola
        int 21h
        inc bx
        jmp escreveDigitos2

numeradorMaior:
    lea dx, numerMaior
    mov ah, 02h
    int 21h    
           
selecDig: