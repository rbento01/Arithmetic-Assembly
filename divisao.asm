org 100h

.data
    numerador db 100 dup(0)
    msgIn db 13, 10, "Introduza os valores para o numerador: $"; enter, linefeed, msg
    msgFi db "O numerador contem os valores: $"
    divisor db 100 dup(0)
    msgDiv db 13,10, "Introduza os valores para o divisor: $"
    msgDivFi db 13,10, "O divisor contem os valores: $" 
    contNum db 0
    contDiv db 0
    erroPonto db 13,10, "Erro, foi introduzido 1 Ponto Final $"; enter, linefeed, msg
    pont db 0 
    erroTecla db 13,10, "Foram introduzidos caracteres invalidos $"
    msgContDiv db 13,10, "Contador do Divisor = $" 
    msgContNum db 13,10, "Contador do Numerador = $"
    msgDivMaior db 13,10, "Resultado = 0 e Resto =  $"  
    msgNumMaiorIgual db 13,10, " Contador do Numerador maior ou igual que o do Divisor $"
    erroZero db 13, 10, "Nao e possivel dividir por zero $"
    contZero db 0
    soZero db 13,10, "O numero so tem zeros $"
    contZeroDiv db 0  
    msgDigMaior db 13,10, " digito maior que o do divisor $"
    msgDigIgual db 13,10, " digito igual $"
    msgDigMenor db 13,10, " digito menor que o do divisor $"
    numeradorInt db 100 dup(0)
    divisorInt db 100 dup(0)
    msgTeste db  " TESTE DE CONVERSAO : $"
    teste db 0
     
.code
regNumerador:
    
    mov ax,@data
    mov ds, ax
    
    lea dx, msgIn ; loading the address of msgIn
    mov ah,09h
    int 21h
    
    mov cx, 100 ; going through the loop 4 times
    lea si, numerador ;loading the address of array
    
    loopNum:
        mov ah, 01h
        int 21h

        mov [si],al
        jmp verificaNum          

        loop loopNum

;loop to request 4 numbers to the array    
    verificaNum:      
           
        ;Compara com ENTER
        cmp al, 0Dh ;compare the key pressed with the enter ASCII code
        je  enter    ;if enter was pressed jump to "rest"   
        
        ;Compara com Ponto Final
        cmp al, 2Eh
        je pontoFinal
        
        ;Compara com Virgula
        cmp al, 2Ch
        je pontoFinal
        
        ;Compara com Backspace
        cmp al, 08h
        je backspace
        
        cmp al,30h
        jb caracterInvalido
        
        cmp al,39h
        ja caracterInvalido 
         
        inc si 
        inc contNum
        
        cmp al, 30h
        je zero
        jmp loopNum

zero: 
    inc contZero
    jmp loopNum
       
caracterInvalido:  

     lea dx, erroTecla
     mov ah, 09h
     int 21h
     mov pont, 0
     mov contNum, 0
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
     
    lea dx, erroPonto ; loading the address of erroPonto
    mov ah,09h
    int 21h
    mov pont, 0
    mov contNum, 0
    jmp regNumerador
    
enter:   

    mov dl,10
    mov ah,02h
    int 21h
    
    mov dl,13
    mov ah,02h
    int 21h 
       
    lea dx,msgFi ;loading the address of msgFi
    mov ah,09h
    int 21h
         
    lea si, numerador ;loading the address of array
    mov cl,contNum


    mov bl, contZero
    cmp bl, contNum
    je tudoZero


;loop to print the numbers of the array    
    loopmostraNum:   
        
        mov dl,[si]
        mov ah,02h
        int 21h
                
        cmp dl, 0Dh ;compare the key pressed 
                    ;with the enter ASCII code
        je  regDivisor    ;if enter was pressed jump to "rest"   
        
        inc si
        loop loopmostraNum
        jmp regDivisor  

tudoZero:
    mov cl, 1
    mov contNum, 1
    ;lea dx, soZero
    ;mov ah, 09h
    ;int 21h
    jmp loopMostraNum
        
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
        
        mov [si],al
        jmp verificaDiv          
              
        loop loopDiv
        
verificaDiv:      
        
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
        
        cmp al,30h
        jb caracterInvalidoDiv
        
        cmp al,39h
        ja caracterInvalidoDiv 
         
        inc si 
        inc contDiv
        
        cmp al, 30h
        je zeroDiv
        jmp loopDiv 

zeroDiv: 
    inc contZeroDiv
    jmp loopDiv    
        
caracterInvalidoDiv:  

     lea dx, erroTecla
     mov ah, 09h
     int 21h
     mov pont, 0
     mov contDiv, 0
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
     
    lea dx, erroPonto ; loading the address of erroPonto
    mov ah,09h
    int 21h
    mov pont, 0
    mov contDiv, 0
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
    je tudoZeroDiv
       
    lea dx,msgDivFi ;loading the address of msgFi
    mov ah,09h
    int 21h
         
    lea si, divisor ;loading the address of array
    mov cl,contDiv
    
    mov bl, contZeroDiv
    cmp bl, contDiv
    je tudoZeroDiv

;loop to print the numbers of the array    
    loopmostraDiv: 
    
        mov dl,[si]
        mov ah,02h
        int 21h
                
        cmp dl, 0Dh ;compare the key pressed 
                    ;with the enter ASCII code
        je  mostraCont    ;if enter was pressed jump to "rest"   
        
        inc si
        loop loopmostraDiv
        jmp mostraCont
        
tudoZeroDiv:
    lea dx, erroZero
    mov ah, 09h
    int 21h
    mov contDiv, 0
    mov contZeroDiv, 0
    
    jmp regDivisor        

 
mostraCont:

;print do CONTADOR ( HEX para DECIMAL)
lea dx, msgContNum
mov ah,09h
int 21h    
mov al, contNum      ; Your example (12)
aam                ; -> AH is quotient (1) , AL is remainder (2)
add ax, 3030h      ; -> AH is "1", AL is "2"
push ax            ; (1)
mov dl, ah         ; First we print the tens
mov ah, 02h        ; DOS.PrintChar
int 21h
pop dx             ; (1) Secondly we print the ones (moved from AL to DL via those PUSH AX and POP DX instructions
mov ah, 02h        ; DOS.PrintChar
int 21h

lea dx, msgContDiv
mov ah,09h
int 21h    
mov al, contDiv      ; Your example (12)
aam                ; -> AH is quotient (1) , AL is remainder (2)
add ax, 3030h      ; -> AH is "1", AL is "2"
push ax            ; (1)
mov dl, ah         ; First we print the tens
mov ah, 02h        ; DOS.PrintChar
int 21h
pop dx             ; (1) Secondly we print the ones (moved from AL to DL via those PUSH AX and POP DX instructions
mov ah, 02h        ; DOS.PrintChar
int 21h
 

    
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
    xor si, si
    lea si, numerador
    mov cl, contNum
    
    lea dx, msgTeste
    mov ah,09h
    int 21h
    
    
        
;    loopConverte:
;        mov bl, numerador[si]
;        sub bl, 48
;        mov numeradorInt[si], bl
;        
;           
;        
;        mov dl, numeradorInt[si]
;        mov ah, 02h
;        int 21h
;      
;        inc si
;    loop loopConverte
;;bem ate aqui    
;    lea dx, msgTeste
;    mov ah,09h
;    int 21h

        mov bl, numerador[0]
        sub bl, 30h
        mov numeradorInt[0], bl
        
           
        
        mov dl, numeradorInt[0]
        mov ah, 02h
        int 21h
        
        mov ax, 0
        mov al, bl   
        ; mov bl, 9 RESULTA, 2 DIGITOS NAO
        mov bl, 10
        mul bl
        
        mov numeradorInt[0], al
        
        mov bl, numeradorInt[0]
        add bl, 30h
        mov numeradorInt[0], bl
        
        mov dl, numeradorInt[0]
        mov ah, 02h
        int 21h
        
        mov bl, numerador[1]
        sub bl, 30h
        mov numeradorInt[1], bl
        
           
        
        mov dl, numeradorInt[1]
        mov ah, 02h
        int 21h
        
        mov bl, numerador[2]
        sub bl, 30h
        mov numeradorInt[2], bl
        
           
        
        mov dl, numeradorInt[2]
        mov ah, 02h
        int 21h
    
;    lea dx, numeradorInt[0]
;    mov ah,02h
;    int 21h
;    
;    xor ah, ah
;    mov al, numeradorInt[0]
;    mov bl, 10
;    mul bl
;    add al, 30h
;    mov al, divisorInt[0]
;    add al, numeradorInt[1]
;    mov divisorInt[0], al
;    add al, 30h
;    mov teste, al
    
    
;    lea dx, ax
;    mov ah,02h
;    int 21h
    
;    mov dl, teste
;    mov ah, 02h
;    int 21h
    
        
        
        
selecDig:    